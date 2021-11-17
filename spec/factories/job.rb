# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    name { 'fake_job_1' }
    priority { 'low' }
    triggered_at { 10.days.from_now }
  end
end
