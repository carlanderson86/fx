class CreateFxLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :fx_logs do |t|
      t.string :label
      t.text :result
      t.timestamp :timestamp
      t.integer :status, :default => 0
      t.timestamps
    end
  end
end
