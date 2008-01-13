class CreateUsers < Sequel::Migration
  def up
    create_table :users do
      primary_key :id
      varchar   :username, :size => 16, :unique => true, :null => false
      varchar   :password, :size => 32, :null => false
      text      :permissions, :null => false
    end
  end
  def down
    execute 'DROP TABLE users'
  end
end
