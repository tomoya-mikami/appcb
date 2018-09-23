class ProjectsController < ApplicationController

  before_action :project_check

  def map
    render :layout => 'map'
  end

  def analytics
    render :layout => 'analytics'
  end

  def image
    render :layout => 'image'
  end

  private

  def project_check
    @project = Project.find_by(name: params[:project_name])
    if @project.nil?
      raise ActiveRecord::RecordNotFound.new("プロジェクトが存在しません")
    end
    if @project.description.nil?
      @project.description = ""
    end
  end
end
