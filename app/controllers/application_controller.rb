# frozen_string_literal: true

class ApplicationController < ActionController::API
  protected

  def set_pagination_header(name, _options = {})
    scope = instance_variable_get("@#{name}")
    return if scope.blank?

    request_params = request.query_parameters
    unless request_params.empty?
      url_without_params = request.original_url.slice(0..(request.original_url.index('?') - 1))
    end
    url_without_params ||= request.original_url

    page = {}

    page[:first] = 1 if scope.total_pages > 1 && !scope.first_page?
    page[:last] = scope.total_pages  if scope.total_pages > 1 && !scope.last_page?
    page[:next] = scope.current_page + 1 unless scope.last_page?
    page[:prev] = scope.current_page - 1 unless scope.first_page?

    @pagination_links = {}
    page.each do |k, v|
      new_request_hash = { 'page' => { 'number' => v }}
      @pagination_links[k] = "<#{url_without_params}?#{new_request_hash.to_param}>; rel=\"#{k}\""
    end
    return if @pagination_links.blank?

    # headers["Link"] = @pagination_links
    response.body = JSON.generate(JSON.parse(response.body).push(links: @pagination_links))
  end
end
