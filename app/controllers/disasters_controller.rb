class DisastersController < ActionController::Base

  def index
    response = response_init
    disasters = Disaster.all
    response['results'] = disasters
    response['stauts'] = 200
    render :json => response
  end

  private

    def disaster_params
      params.require(:disaster).permit(:disaster_name, :image)
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

