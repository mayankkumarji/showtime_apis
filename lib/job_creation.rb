# frozen_string_literal: true

class JobCreation
  def initialize(options = {})
    options = options.instance_of?(Array) ? Hash[*options] : options
    @params        = options
  end

  def create_job
    job = Job.new(@params)
    if job.save && job.triggered_at.nil?
      job.invoke_job
    end
    job
  end
end
