class CreateRuns < ActiveRecord::Migration[7.1]
  def change
    create_table :runs do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :start_lat
      t.decimal :start_lng
      t.decimal :end_lat
      t.decimal :end_lng
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :avg_heartbeat
      t.integer :calories
      t.integer :privacy

      t.timestamps
    end
  end
end
