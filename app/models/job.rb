# frozen_string_literal: true

class Job < ApplicationRecord
  validates :name, :priority, presence: true
  validates :priority, inclusion: { in: %w[critical high low],
                                    message: '%{value} is not a valid priority' }
  validates :state, inclusion: { in: %w[waiting in_progress done failed],
                                 message: '%{value} is not a valid state' }
  has_one :movie, dependent: :destroy

  validate :triggered_at_check

  include AASM
  aasm column: :state, whiny_transitions: false do
    # job states
    state :waiting, initial: true
    state :in_progress
    state :done
    state :failed

    event :progress do
      transitions from: :waiting, to: :in_progress
      after %i[movie_title_and_date]
    end

    event :complete do
      transitions from: :in_progress, to: :done
    end

    event :fail do
      transitions from: :in_progress, to: :failed
    end
  end

  def invoke_job
    progress! if waiting?
  end

  private

  # should not update triggered_at once it set.
  def triggered_at_check
    return if triggered_at.nil?

    add_error and return if persisted? && attribute_changed?(:triggered_at)

    add_error if !persisted? && triggered_at <= Time.zone.now
  end

  # return current date and time when job done
  def movie_title_and_date
    job_movie = build_movie(title: random_movie_title)
    if job_movie.save
      Time.zone.now if complete!
    else
      fail!
    end
  end

  def random_movie_title
    (0...8).map { rand(65..90).chr }.join
  end

  def add_error
    errors.add(:triggered_at, 'must be greater than current date time or cant changed')
  end
end
