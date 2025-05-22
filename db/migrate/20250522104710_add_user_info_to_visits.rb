class AddUserInfoToVisits < ActiveRecord::Migration[8.0]
  def change
    add_column :visits, :name, :string
    add_column :visits, :email, :string
    add_column :visits, :age, :integer
    add_column :visits, :comment, :text
  end
end
