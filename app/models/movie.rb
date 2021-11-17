# frozen_string_literal: true

class Movie < ApplicationRecord
  belongs_to :job
  validates :title, presence: true
end
