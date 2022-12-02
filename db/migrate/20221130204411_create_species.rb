class CreateSpecies < ActiveRecord::Migration[7.0]
  def change
    create_table :species do |t|
      t.string :display_name
      t.string :normalized_name

      t.timestamps
    end
  end
end
