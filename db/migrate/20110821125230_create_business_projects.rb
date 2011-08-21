class CreateBusinessProjects < ActiveRecord::Migration
  def self.up
    create_table :business_projects do |t|

      t.column :business_id, :integer

      t.column :project_id, :integer

    end
  end

  def self.down
    drop_table :business_projects
  end
end
