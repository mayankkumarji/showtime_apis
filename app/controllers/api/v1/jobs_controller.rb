# frozen_string_literal: true

module Api
  module V1
    class JobsController < ApplicationController
      def process_job
        job_ids = Array(params[:job_id])

        jobs= Job.waiting.where(id: job_ids)

        ActiveRecord::Base.transaction do
          jobs.each(&:progress!)
        end
        render json: jobs, status: :created
      end
    end
  end
end
