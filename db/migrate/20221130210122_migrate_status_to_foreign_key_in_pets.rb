class MigrateStatusToForeignKeyInPets < ActiveRecord::Migration[7.0]
  def change
    rename_column :pets, :status, :status_id
    change_column :pets, :status_id, :bigint
    add_foreign_key :pets, :statuses
  end
end
