class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|

      t.column :name, :string

      t.column :description, :text

      t.column :created_on, :datetime

    end
  end

  def self.down
    drop_table :customers
  end
end
