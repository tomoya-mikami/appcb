class PositionController < ApplicationController

  protect_from_forgery :except=> [:create]
  before_action :project_check

  def index
    response = response_init
    position_id = 0
    if params.has_key?(:position_id)
      position_id = params[:position_id]
    end
    positions = Position.where("(id > ?) and (project_id = ?)", position_id, @project.id)
    response['results'] = positions
    response['stauts'] = 200
    render :json => response
  end

  def create
    position = @project.positions.build(latitude: params[:latitude], longitude: params[:longitude], description: params[:description], position_type: params[:position_type], disaster_id: params[:disaster_id], image: params[:image])
    if position.save
      @response['message']['success'] = '保存しました'
      @response['status'] = :create
    else
      @response['error'] = true
      @response['message']['fail'] = '保存に失敗しました'
      @response['message']['error'] = position.errors.full_messages
      @response['status'] = :unprocessable_entity
    end

    render :json => @response
  end

  private

  def postion_params
    params.require(:positions).permit(:latitude, :longitude, :description, :position_type)
  end

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
  end
end
