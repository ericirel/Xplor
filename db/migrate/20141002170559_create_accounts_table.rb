class CreateAccountsTable < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.string :fname
      t.string :lname
      t.string :hometown
      t.integer :age
      t.string :interests
    end
  end
end
