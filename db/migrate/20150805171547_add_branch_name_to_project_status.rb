class AddBranchNameToProjectStatus < ActiveRecord::Migration
  def change
    add_column :project_statuses, :branch_name, :string
  end
end
