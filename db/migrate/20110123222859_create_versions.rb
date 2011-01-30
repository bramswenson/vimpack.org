class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.integer :script_id
      t.integer :latest_for_id
      t.string :filename
      t.string :script_version
      t.date :date
      t.string :vim_version
      t.integer :author_id
      t.text :release_notes

      t.timestamps
    end
    add_index :versions, [ :script_version, :script_id ], :unique => true
  end

  def self.down
    drop_table :versions
  end
end
