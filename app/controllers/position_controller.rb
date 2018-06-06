class PositionController < ApplicationController
  def index
    response = response_init
    positions = Position.all
    response['results'] = positions
    response['stauts'] = 200
    render :json => response
  end

  def create
    position = Position.new(latitude: params[:latitude], longitude: params[:longitude], description: params[:description], position_type: params[:position_type])
    response = response_init
    if position.save
      response['message'] = '保存しました'
      response['status'] = :create
    else
      response['error'] = true
      response['message'] = '保存に失敗しました'
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
      'messegae' => {},
      'status' => '',
      'results' => {}
    }
  end
end