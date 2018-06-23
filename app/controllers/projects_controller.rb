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
    @project = Project.where(name: params[:project_name]).first
    if @project.nil?
      raise ActiveRecord::RecordNotFound.new("プロジェクトが存在しません")
    end
  end
end
