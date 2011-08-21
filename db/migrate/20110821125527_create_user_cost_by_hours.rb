class CreateUserCostByHours < ActiveRecord::Migration
  def self.up
    create_table :user_cost_by_hours do |t|

      t.column :user_id, :integer

      t.column :cost_by_hour, :integer

      t.column :updated_at, :datetime

    end
  end

  def self.down
    drop_table :user_cost_by_hours
  end
end
