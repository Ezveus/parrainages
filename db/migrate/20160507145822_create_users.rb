class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :last_name
      t.string :first_name

      t.timestamps null: false
      t.index :login
      t.references :sponsor, index: true
    end
  end
end
