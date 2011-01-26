class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.integer :user_id
      t.string :user_name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :homepage

      t.timestamps
    end
  end

  def self.down
    drop_table :authors
  end
end
