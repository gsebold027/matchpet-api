class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.float :lat
      t.float :lng
      t.string :address

      t.timestamps
    end
  end
end
