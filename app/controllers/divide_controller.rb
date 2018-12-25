class DivideController < ApplicationController

  require 'fileutils'
  before_action :project_check

  def index

    params_check
    if @response['error']
      return render :json => @response
    end

    basefile = params['basefile']
    base_depth = params['base_depth']
    base_vertical = params['base_vertical']
    base_horizontal = params['base_horizontal']
    column = params['column'].to_i
    row = params['row'].to_i
    source_id = params['source_id']

    project_path = Rails.public_path.join('img', @project.name).to_s
    src_dir =  project_path + '/src'
    output_dir = project_path + '/dest'
    extension = 'png'
    divid = 2 ** base_depth.to_i

    src = nil
    image = nil

    client = HTTPClient.new()
    if ! @project.auth_name.empty?
      client.set_auth(@project.estimate_url, @project.auth_name, @project.auth_password);
    end

    begin
      src = Magick::ImageList.new("#{src_dir}/#{basefile}.#{extension}")

      width = src.columns / divid
      height = src.rows / divid

      (1..row).each do |i|
        (1..column).each do |j|
          output_vertical = 2 * base_vertical.to_i + j - 2
          output_horizontal = 2 * base_horizontal.to_i + i - 2
          output_depth = base_depth.to_i + 1
          output_file = "#{output_dir}/#{basefile}_#{output_depth}_#{output_vertical}_#{output_horizontal}.#{extension}"
          next if File.exist?(output_file)
          image = src.crop(width * (output_horizontal - 1), height * (output_vertical - 1), width, height, true)
          dest_image = image.resize_to_fit(500, 500)
          dest_image.write(output_file)
          dest_image.destroy!
          image.destroy!
          image_path = Settings.url + '/img/' + @project.name + '/dest/' + "#{basefile}_#{output_depth}_#{output_vertical}_#{output_horizontal}.#{extension}"
          tuple = "source_id:#{source_id},image_url:#{image_path},status_id:-1"
          res = client.post(@project.estimate_url, 
            {
              :project_name => @project.name,
              :relation_name => "Image",
              :tuple => tuple
            }
          )
        end
      end
      src.destroy!

      @response['message']['success'] = '画像の分割に成功しました'
      @response['status'] = 200

    rescue StandardError => error
      src.destroy! if src
      image.destroy! if image

      @response['error'] = true
      @response['message']['fail'] = '画像の分割に失敗しました'
      @response['message']['error'] = error
      @response['status'] = 500

    end

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
  end

  def params_check

    if ! params.has_key?(:basefile)
      @response['error'] = true
      @response['message']['not_found_basefile'] = ['basefileを指定してください']
    end

    if ! params.has_key?(:base_depth)
      @response['error'] = true
      @response['message']['not_found_base_depth'] = ['base_depthを指定してください']
    end

    if ! params.has_key?(:base_vertical)
      @response['error'] = true
      @response['message']['not_found_base_vertical'] = ['base_verticalを指定してください']
    end

    if ! params.has_key?(:base_horizontal)
      @response['error'] = true
      @response['message']['not_found_base_horizontal'] = ['base_horizontalを指定してください']
    end

    if ! params.has_key?(:column)
      @response['error'] = true
      @response['message']['not_found_column'] = ['columnを指定してください']
    end

    if ! params.has_key?(:row)
      @response['error'] = true
      @response['message']['not_found_row'] = ['rowを指定してください']
    end

    if ! params.has_key?(:source_id)
      @response['error'] = true
      @response['message']['not_found_source_id'] = ['source_idを指定してください']
    end

    if @response['error']
      @response['status'] = 500
    end

  end

end
