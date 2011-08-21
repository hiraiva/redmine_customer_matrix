class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|

      t.column :name, :string

      t.column :customer_id, :integer

      t.column :order_placed_cost, :integer

      t.column :target_cost, :integer

      t.column :actual_cost, :integer

      t.column :actual_hours, :float
 
      t.column :status, :string

      t.column :description, :text

      t.column :created_at, :datetime

      t.column :updated_at, :datetime

    end
  end

  def self.down
    drop_table :businesses
  end
end
