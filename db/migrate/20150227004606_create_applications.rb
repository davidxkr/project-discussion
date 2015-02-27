class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :token, null: false, index: true
      t.string :name, null: false
      t.boolean :enable, default: false

      t.timestamps null: false
    end
  end
end
