class AddForeignKeysToVersion < ActiveRecord::Migration
  def self.up
    add_foreign_key(:versions, :scripts)
    add_foreign_key(:versions, :authors)
  end

  def self.down
    remove_foreign_key(:versions, :scripts)
    remove_foreign_key(:versions, :authors)
  end
end
