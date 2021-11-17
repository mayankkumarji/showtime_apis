# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TriggerJobWorker, type: :worker do
  describe '#perform' do
    let!(:job) { create(:job) }

    it 'returns and complete waiting job' do
      job.progress! # stubbed job

      described_class.new.perform(job.id)
      expect(job.reload.state).to eq 'done'
      expect(job.reload.movie).not_to eq nil
    end
  end
end
