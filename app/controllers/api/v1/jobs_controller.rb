# frozen_string_literal: true

module Api
  module V1
    class JobsController < ApplicationController
      before_action :set_pagination_defaults, only: %i[index]
      after_action -> { set_pagination_header(:jobs) }, only: [:index]

      def index
        @jobs = Job.page(@page)&.per(@per)
        render json: @jobs
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

        jobs_by_priority = Job.waiting.where(id: job_ids).get_by_priority

        ActiveRecord::Base.transaction do
          jobs_by_priority.each(&:progress!)
        end
        render json: jobs_by_priority, status: :created
      end

      private

      def job_params
        params.require(:job).permit(:name, :priority, :triggered_at)
      end

      def set_pagination_defaults
        pagination_service = PaginationService.new(params[:page])
        @page = pagination_service.page
        @per = pagination_service.per
      end
    end
  end
end
