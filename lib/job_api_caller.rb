# frozen_string_literal: true

class JobApiCaller
  def call(job_id)
    response = rest_api(:get, "/api/v1/jobs/process_job?job_id[]=#{job_id}")
    Rails.logger.debug do
      "\n\n\n job info - \n #{begin
        response
      rescue StandardError
        nil
      end} \n\n\n"
    end
    response
  end

  private

  def rest_api(verb, path, data = nil)
    args = [url + path]
    if data
      if %i[post put patch].include?(verb)
        args << data.compact.to_json
        args << { 'Content-Type' => 'application/json' }
      else
        args << data.compact
        args << {}
      end
    else
      args << nil
      args << {}
    end

    response = Faraday.send(verb, *args)

    JSON.parse(response.body)
  end

  def url
    # change host URL accordingly
    'http://localhost:3000'
  end
end
