# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::JobsController do
  describe 'GET /api/v1/jobs' do
    context 'with list jobs with pagination' do
      let!(:incomplete_job) { create(:job) }
      let!(:complete_job) { create(:job, state: 'failed') }

      it 'returns jobs' do
        get :index

        response_text = JSON.parse(response.body)

        expect(response_text.count).to eq 2
        expect(response_text.map { |x| x['id'] }).to eq([incomplete_job.id, complete_job.id])
      end
    end
  end

  describe 'POST /api/v1/job' do
    let(:params) do
      {
        job: {
          name: 'test',
          priority: 'low',
          triggered_at: 10.days.from_now
        }
      }
    end

    context 'with valid parameters' do
      it 'returns http status created' do
        post :create, params: params

        expect(response.status).to eq 201
        expect(JSON.parse(response.body)['name']).to eq params[:job][:name]
      end
    end

    context 'with invalid parameters' do
      it 'returns Unprocessable Entity if name is not present' do
        params[:job].delete(:name)
        post :create, params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['name']).to eql(["can't be blank"])
      end

      it 'triggered_at should be greater than current date time' do
        params[:job][:triggered_at] = 1.day.ago
        post :create, params: params

        response_text = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_text['triggered_at']).to eql(['must be greater than current date time or cant changed'])
      end
    end
  end

  describe 'GET api/v1/jobs/process_job?job_id[]=1' do
    context 'when process job with waiting job status' do
      let!(:incomplete_job) { create(:job) }
      let(:params) do
        {
          job_id: [incomplete_job.id]
        }
      end

      it 'completes job and store movie' do
        post :process_job, params: params

        expect(response.status).to eq 201
        expect(incomplete_job.reload.state).to eq 'done'
        expect(incomplete_job.reload.movie).not_to eq nil
      end
    end

    context 'when status is not waiting' do
      let!(:complete_job) { create(:job, state: 'failed') }
      let(:params) do
        {
          job_id: [complete_job.id]
        }
      end

      it 'does not complete job and store movie' do
        post :process_job, params: params
        response_text = JSON.parse(response.body)

        expect(response.status).to eq 201
        expect(complete_job.reload.state).to eq 'failed'
        expect(complete_job.reload.movie).to eq nil
        expect(response_text).to eq []
      end
    end
  end
end
