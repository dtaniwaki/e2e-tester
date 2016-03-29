class ProjectTestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @project = current_user.projects.find(params[:project_id])
    authorize @project, :show?
    @tests = policy_scope(@project.tests).latest.page(params[:page]).per(20)
  end
end
