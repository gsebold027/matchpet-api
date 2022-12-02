class MigrateSizeToForeignKeyInPets < ActiveRecord::Migration[7.0]
  def change
    rename_column :pets, :size, :size_id
    change_column :pets, :size_id, :bigint
    add_foreign_key :pets, :sizes
  end
end
