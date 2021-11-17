# frozen_string_literal: true

class AddColumnTriggeredAtToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :triggered_at, :timestamp
  end
end
