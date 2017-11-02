class CreateFxCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :fx_currencies do |t|
      t.string :label
      t.string :code
      t.string :symbol
      t.boolean :is_active
      t.timestamps
    end
  end
end
