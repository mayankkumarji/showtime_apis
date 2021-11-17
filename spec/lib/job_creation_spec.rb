# frozen_string_literal: true

require 'rails_helper'

describe JobCreation do
  describe '.create_job' do
    context 'when job is created by api' do
      let(:params) do
        {
          name: 'test',
          priority: 'low',
          triggered_at: 10.days.from_now,
          created_by: 'api'
        }
      end

      it 'creates job' do
        job = described_class.new(params.stringify_keys).create_job
        expect(job.name).to eq params[:name]
      end
    end

    context 'when job is created by terminal with ran time' do
      let(:params) do
        {
          name: 'test',
          priority: 'low',
          triggered_at: 10.days.from_now
        }
      end

      it 'creates job and process it' do
        job = described_class.new(params.stringify_keys).create_job

        expect(job.name).to eq params[:name]
        expect(job.state).to eq 'waiting'
        expect(job.reload.movie).to eq nil
      end
    end

    context 'when job is created by terminal without ran time' do
      let(:params) do
        {
          name: 'test',
          priority: 'low'
        }
      end

      it 'creates job and process it' do
        job = described_class.new(params.stringify_keys).create_job

        expect(job.name).to eq params[:name]
        expect(job.state).to eq 'done'
        expect(job.reload.movie).not_to eq nil
      end
    end
  end
end
