# frozen_string_literal: true

class TriggerJobWorker
  include Sidekiq::Worker

  def perform(*args)
    JobApiCaller.new.call(args[0])
    # job = Job.waiting.find_by(id: args[0])
    # job.invoke_job
  end
end
