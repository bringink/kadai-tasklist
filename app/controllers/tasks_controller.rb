class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:new, :show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
  end

  def new
    @task = Task.new
  end

  def show
    if Task.find_by(id: params[:id])  
      @task = Task.find(params[:id])
    else
     redirect_to root_url 
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Task is created successfully'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Unable to create a task'
      render 'toppages/index'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Task is updated successfully'
      redirect_to @task
    else
      flash.now[:danger] = 'Fail to update task'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:success] = 'Task is removed'
    redirect_back(fallback_location: root_path)
  end

  private

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
