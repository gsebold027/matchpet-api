class CreatePets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets do |t|
      t.string :name
      t.integer :species
      t.integer :gender
      t.integer :size
      t.integer :status
      t.string :breed
      t.integer :age
      t.float :weight
      t.string :description
      t.integer :neutered
      t.integer :special_need
      t.references :location, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
