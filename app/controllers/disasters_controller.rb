class DisastersController < ActionController::Base

  before_action :project_check

  def index
    response = response_init
    disasters = false
    if ! @project.nil?
      disasters = @project.disasters
    end
    response['results'] = disasters
    response['stauts'] = 200
    render :json => response
  end

  private

    def disaster_params
      params.require(:disaster).permit(:name, :image)
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
      @project = nil
      @response = response_init
      if ! params.has_key?(:project_token)
        @response['error'] = true
        @response['message']['error'] = ['プロジェクトのトークンを送ってください']
        render :json => @response
      end

      @project = Project.find_by(token: params[:project_token])
      if ! @project
        @response['error'] = true
        @response['message']['error'] = ['プロジェクトが見つかりません']
        render :json => @response
      end
    end

end

