class AddEmailPhoneToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :phonenumber, :string
    add_column :users, :address, :string
    add_column :users, :staffname, :string
  end
end
