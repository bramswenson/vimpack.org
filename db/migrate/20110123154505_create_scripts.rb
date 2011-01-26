class CreateScripts < ActiveRecord::Migration
  def self.up
    create_table :scripts do |t|
      t.string  :name
      t.string  :display_name
      t.integer :script_id
      t.string  :script_type
      t.text    :summary
      t.text    :description
      t.text    :install_details

      t.timestamps
    end
  end

  def self.down
    drop_table :scripts
  end
end
