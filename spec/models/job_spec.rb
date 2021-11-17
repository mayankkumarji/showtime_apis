# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  %i[name priority].each do |field|
    it { is_expected.to validate_presence_of(field) }
  end

  it { is_expected.to have_one :movie }

  describe '#invoke_job' do
    let!(:incomplete_job) { create(:job) }
    let!(:complete_job) { create(:job, state: 'failed') }

    context 'when job in waiting state' do
      it 'returns nil, if job state is not waiting' do
        expect(complete_job.invoke_job).to be nil
      end

      it 'is complete and create movie, if job state is waiting' do
        incomplete_job.invoke_job

        expect(incomplete_job.reload.state).to eq 'done'
        expect(incomplete_job.reload.movie).not_to eq nil
      end
    end
  end
end
