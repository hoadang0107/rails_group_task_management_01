class TasksController < ApplicationController
  before_action :find_task,
    only: [:edit, :update, :show, :destroy]
  
  def index 
    @tasks = Task.search(params[:title])
  end
  
  def show
    @job = Task.find_by_id(params[:id])
    @user = User.find_by_id(@job.member_id)
    @task = Task.find(params[:id])
    @applyed = StudentJob.where(job_id: @task.id, student_id: current_user.id)
  end

  def create
    @task = Task.new params.require(:task).permit :title,
    :content, :start_date, :end_date, :skill, :salary, :member_id
    if @task.save
      flash[:info] = t "flash.create_job_successful"
    else
      flash.now[:danger] = t "flash.create_job_eror"
    end
    redirect_back(fallback_location: current_user)
  end

  def destroy
    Task.delete(params.require(:id))
    flash[:info] = t "flash.deleted"
    redirect_to request.referrer || root_url
  end

  def task_save
    if @task.save
      flash[:info] = t "flash.add_task_successful"
      @group.members.each do |member|
        member.sent_mail_deadline @task
      end
    else
      flash[:danger] = t "flash.add_task_error"
    end
  end

  def statistic
    @users = @group.members.paginate page: params[:page],
                                     per_page: Settings.users.per_page
    @task = Task.new
    @task.subtasks.build
    @task_statistic = Task.where group_task_id: params[:id]
  end

  def change_subtask
    @subtask = Subtask.find_by id: params[:subtask][:subtask_id]
    @subtask.update_attribute :done, !@subtask.done?
    respond_to do |format|
      format.js
      format.html
    end
  end

  private

  def check_members_exist
    return unless @group.members.count.zero?
    redirect_to group_path(@group.id)
    flash[:danger] = t "flash.member_null"
  end

  def generate_group_task_id
    return 1 if Task.last.blank?
    Task.last.group_task_id + 1
  end

  def find_group group_id
    @group = Group.find_by id: group_id
    return if @group
    redirect_to root_path
    flash[:danger] = t "flash.cant_find_group"
  end

  def task_params
    params.require(:task).permit :title,
    :content, :start_date, :end_date, :skill, :salary
  end

  def leader_of_group group_id
    group = Group.find_by id: group_id
    return false unless group
    group.leader == current_user
  end

  def find_task
    @task = Task.find_by id: params[:id]
    return if @task
    redirect_to group_path
    flash[:danger] = t "flash.cant_find_task"
  end
  
  def task_params
    params.require(:task).permit(:term)
  end

  def check_task_in_group
    return if @task.group_id == params[:group_id].to_i
    redirect_to group_path
    flash[:danger] = t "flash.not_true_group"
  end

  def check_leader_group group_id
    return if leader_of_group group_id
    redirect_to current_user
    flash[:danger] = t "flash.you_are_not_leader"
  end

  def find_group_with_id
    @group = Group.find_by id: params[:group_id]
  end

  def change_subtask_params
    params.require(:subtask).permit :subtask_id, :group_id
  end

  def check_leader_or_member group_id
    return if leader_of_group group_id
    return unless GroupMember.find_by(group_id: group_id,
                                      member_id: current_user.id).blank?
    redirect_to current_user
    flash[:danger] = t "flash.cant_access_group"
  end
end
