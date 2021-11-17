# frozen_string_literal: true

module Api
  module V1
    class JobsController < ApplicationController

      def index
        jobs = Job.all
        render json: jobs
      end

      def create
        job = JobCreation.new(job_params.merge({ created_by: 'api' })).create_job

        if job.errors.present?
          render json: job.errors, status: :unprocessable_entity
        else
          render json: job, status: :created
        end
      end

      def process_job
        job_ids = Array(params[:job_id])

        jobs= Job.waiting.where(id: job_ids)

        ActiveRecord::Base.transaction do
          jobs.each(&:progress!)
        end
        render json: jobs, status: :created
      end

      private

      def job_params
        params.require(:job).permit(:name, :priority, :triggered_at)
      end
    end
  end
end
