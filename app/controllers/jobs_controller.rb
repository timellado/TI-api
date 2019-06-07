class JobsController < ApplicationController
  def index
    @jobs = Delayed::Job.all
    # job = Ftp.delay(run_at: 4.minutes.from_now).get_id
    job = Ftp.delay.get_id
    job.update_column(:comments, "Evaluando FTP") if job.present?
  end
  # job = oc.delay.evalOC
  # job.update_column(:comments, "Evaluando OC:  #{params[:id]}") if job.present?
end
