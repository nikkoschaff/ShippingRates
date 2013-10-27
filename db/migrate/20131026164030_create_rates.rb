class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.integer :weight
      t.string :country
      t.string :state
      t.string :city
      t.integer :zip

      t.timestamps
    end
  end
end
