class PositionController < ApplicationController

  protect_from_forgery :except=> [:create]

  def index
    response = response_init
    positions = Position.all
    response['results'] = positions
    response['stauts'] = 200
    render :json => response
  end

  def create
    position = Position.new(latitude: params[:latitude], longitude: params[:longitude], description: params[:description], position_type: params[:position_type], disaster_id: params[:disaster_id], image: params[:image])
    response = response_init
    if position.save
      response['message']['success'] = '保存しました'
      response['status'] = :create
    else
      response['error'] = true
      response['message']['fail'] = '保存に失敗しました'
      response['message']['error'] = position.errors.full_messages
      response['status'] = :unprocessable_entity
    end

    render :json => response
  end

  private

  def postion_params
    params.require(:positions).permit(:latitude, :longitude, :description, :type)
  end

  def response_init
    response = {
      'error' => false,
      'message' => {},
      'status' => '',
      'results' => {}
    }
  end
end
