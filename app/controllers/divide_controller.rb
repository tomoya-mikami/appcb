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

    image_path = Rails.public_path.join('img', @project.name).to_s
    src_dir =  image_path + '/src'
    output_dir = image_path + '/dest'
    extension = 'png'
    divid = 2 ** base_depth.to_i

    src = nil
    image = nil

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

  def setup_directory
    paths = []
    image_path = Rails.public_path.join('img', @project.name).to_s
    paths << image_path + '/src'
    paths << image_path + '/dest'
    paths << image_path + '/original'

    begin
      paths.each do |path|
        FileUtils.mkdir_p(path) unless FileTest.exist?(path)
      end
    rescue => exception
      @response['error'] = true
      @response['message'] = 'ディレクトリの作成に失敗しました'
      @response['status'] = 500
      return render :json => @response
    end

      @response['error'] = false
      @response['message'] = 'ディレクトリの作成に成功しました'
      @response['status'] = 200

      render :json => @response
  end

  def setup_image
    image_path = Rails.public_path.join('img', @project.name).to_s
    original_dir = image_path + '/original'
    src_dir =  image_path + '/src'
    output_dir = image_path + '/dest'

    image_init(original_dir, src_dir, output_dir)

    render :json => @response
  end

  def reset
    image_path = Rails.public_path.join('img', @project.name).to_s
    original_dir = image_path + '/original'
    src_dir =  image_path + '/src'
    output_dir = image_path + '/dest'

    begin
      FileUtils.rm_r(output_dir)
      FileUtils.mkdir_p(output_dir)
      FileUtils.rm_r(src_dir)
      FileUtils.mkdir_p(src_dir)
      image_init(original_dir, src_dir, output_dir)
    rescue => error
      @response['error'] = true
      @response['message']['fail'] = 'リセットに失敗しました'
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

    if @response['error']
      @response['status'] = 500
    end

  end

  def image_init(original_dir, src_dir, output_dir)

    dest_image = nil
    image = nil

    src_files = []
    num = 0

    begin

      originals = Dir.glob(original_dir + '/*')
      originals.each do |original|
        filename = File.basename(original)
        name, ext = /\A(.+?)((?:\.[^.]+)?)\z/.match(filename, &:captures)
        image = Magick::ImageList.new(original_dir + '/' + filename)
        image.write(src_dir + '/' + name + '.png')
        dest_image = image.resize_to_fit(500, 500)
        dest_image.write(output_dir + '/' + name + '_1_1_1.png')
        num = num + 1
        src_files.push([num, src_dir + '/' + name + '.png'])
        dest_image.destroy!
        image.destroy!
      end

      @response['message']['success'] = '画像の準備に成功しました'
      @response['status'] = 200

    rescue => error
      dest_image.destroy! if dest_image
      image.destroy! if image

      @response['error'] = true
      @response['message']['fail'] = '画像の準備に失敗しました'
      @response['message']['error'] = error
      @response['status'] = 500
    end

    return src_files
  end

end
