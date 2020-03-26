module Api
  class TasksController < ApplicationController
    before_action :authorize_access_request!
    before_action :set_task, only: %i[update destroy]

    def index
      @tasks = current_user.tasks.where(done: false)
      @doneTasks = current_user.tasks.where(done: true)
      render json: { tasks: @tasks, doneTasks: @doneTasks }
    end

    def create
      @task = current_user.tasks.build(task_params)
      if @task.save
        render json: @task, status: :created, location: root_path
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def update
      if @task.update(done: params['task']['done'])
        render json: @task
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @task.destroy
    end

    private

    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :deadline, :done)
    end
  end
end
