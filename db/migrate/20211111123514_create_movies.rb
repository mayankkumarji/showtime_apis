# frozen_string_literal: true

class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.references :job
      t.timestamps
    end
  end
end
