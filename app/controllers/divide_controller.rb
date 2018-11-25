class DivideController < ApplicationController

  require 'fileutils'
  before_action :project_check

  def index
    render :json => @response
  end

  private

  def response_init
    response = {
      'error' => false,
      'message' => {},
      'status' => '',
      'results' => {}
    }
  end

  def project_check
    @response = response_init
    if ! params.has_key?(:project_token)
      @response['error'] = true
      @response['message']['error'] = ['プロジェクトのトークンを送ってください']
      return render :json => @response
    end

    @project = Project.find_by(token: params[:project_token])
    if ! @project
      @response['error'] = true
      @response['message']['error'] = ['プロジェクトが見つかりません']
      return render :json => @response
    end

    puts Rails.public_path.join('hoge', 'huga').to_s

  end

end
