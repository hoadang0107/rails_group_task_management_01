class CreateStudentJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :student_jobs do |t|
      t.integer :student_id
      t.integer :company_id
      t.integer :job_id
      t.integer :process_status, :default => 0

      t.timestamps
    end
  end
end
