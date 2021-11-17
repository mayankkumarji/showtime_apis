# frozen_string_literal: true

require 'rails_helper'

describe JobApiCaller do
  describe '.call' do
    let!(:job) { create(:job) }

    context 'when process a waiting job' do
      it 'changes status' do
        job.progress!
        expect(job.reload.state).to eq 'done'
        expect(job.reload.movie).not_to eq nil
      end
    end
  end
end
