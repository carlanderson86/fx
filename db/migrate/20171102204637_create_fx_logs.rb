class CreateFxLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :fx_logs do |t|
      t.string :label
      t.text :result
      t.integer :status
      t.timestamps
    end
  end
end
