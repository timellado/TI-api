class AddCommentsToDelayedJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :delayed_jobs, :comments, :string
  end
end
