class CreateTokens < Sequel::Migration
  def up
    create_table :tokens do
      primary_key :id
      varchar   :username, :size => 16, :null => false
      varchar   :token, :size => 32, :null => false
      datetime  :expires_at, :null => false
    end
  end
  def down
    execute 'DROP TABLE tokens'
  end
end
