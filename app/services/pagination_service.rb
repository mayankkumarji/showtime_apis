# frozen_string_literal: true

class PaginationService
  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_PAGE_SIZE = 10
  MAX_PAGE_SIZE = 500

  attr_reader :page, :per

  def initialize(page_params)
    page_params = page_params.permit(:number, :size).to_h.symbolize_keys if page_params

    @page = page_number_from(page_params) || DEFAULT_PAGE_NUMBER
    @per = page_size_from(page_params) || DEFAULT_PAGE_SIZE
  end

  private

  def page_number_from(page_params)
    return unless page_params.is_a? Hash

    number = page_params[:number].to_i
    return number if number.positive?
  end

  def page_size_from(page_params)
    return unless page_params.is_a? Hash

    size = page_params[:size].to_i
    return MAX_PAGE_SIZE if size > MAX_PAGE_SIZE

    return size if size.positive?
  end
end
