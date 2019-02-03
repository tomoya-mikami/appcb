require 'rmagick'
require 'csv'
require 'fileutils'
require 'httpclient'
require 'uri'
require 'json'
require 'socket'

if ! ARGV[0]
  puts 'プロジェクトのトークンを入力してください'
  return false
end

project = Project.find_by(token: ARGV[0])
if ! project
  puts 'プロジェクトが見つかりません'
  return false
end

project_path = Rails.public_path.join('img', project.name).to_s
original_dir = project_path + '/original'
src_dir =  project_path + '/src'
output_dir = project_path + '/dest'

src_files = []
num = 0

dest_image = nil
image = nil

src_files = []
num = 0

client = HTTPClient.new()

sources = []

begin
  FileUtils.rm_r(output_dir)
  FileUtils.mkdir_p(output_dir)
  FileUtils.rm_r(src_dir)
  FileUtils.mkdir_p(src_dir)

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
    source = project.sources.build(name: name, uuid: SecureRandom.uuid)
    image_path = Settings.url + '/img/' + project.name + '/dest/' + source.name + '_1_1_1.png'
    tuple = "source_id:#{source.uuid},image_url:#{image_path},status_id:-1"
    res = client.post(project.estimate_url, 
      {
        :project_name => project.name,
        :relation_name => "Image",
        :tuple => tuple
      }
    )
    p res.status
    sources << source
  end

  puts '画像の準備に成功しました'

rescue => error
  dest_image.destroy! if dest_image
  image.destroy! if image

  puts = '画像の準備に失敗しました'
end

Source.import sources
