class AddSalarySkillToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :salary, :string
    add_column :tasks, :skill, :string
  end
end
