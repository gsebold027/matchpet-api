class CreateFavoritePets < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_pets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
