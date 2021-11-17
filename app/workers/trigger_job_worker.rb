# frozen_string_literal: true

class TriggerJobWorker
  include Sidekiq::Worker

  def perform(*args)
    job = Job.waiting.find_by(id: args[0])
    job.invoke_job
  end
end
