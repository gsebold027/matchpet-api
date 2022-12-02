class MigrateSpecieToForeignKeyInPets < ActiveRecord::Migration[7.0]
  def change
    rename_column :pets, :species, :specie_id
    change_column :pets, :specie_id, :bigint
    add_foreign_key :pets, :species, column: :specie_id
  end
end
