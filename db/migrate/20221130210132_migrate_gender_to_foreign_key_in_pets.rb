class MigrateGenderToForeignKeyInPets < ActiveRecord::Migration[7.0]
  def change
    rename_column :pets, :gender, :gender_id
    change_column :pets, :gender_id, :bigint
    add_foreign_key :pets, :genders
  end
end
