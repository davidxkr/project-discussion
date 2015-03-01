class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :user, index: true
      t.string :token, null: false, index: true
      t.string :ip_address, null: false

      t.timestamps null: false
    end
  end
end
