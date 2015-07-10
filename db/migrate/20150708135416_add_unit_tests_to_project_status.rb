class AddUnitTestsToProjectStatus < ActiveRecord::Migration
  def change
    add_column :project_statuses, :tests_status, :string
  end
end
