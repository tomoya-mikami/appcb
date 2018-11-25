require 'fileutils'

if ! ARGV[0]
  puts 'プロジェクトのトークンを入力してください'
  return false
end

project = Project.find_by(token: ARGV[0])
if ! project
  puts 'プロジェクトが見つかりません'
  return false
end

paths = []
image_path = Rails.public_path.join('img', project.name).to_s
paths << image_path + '/src'
paths << image_path + '/dest'
paths << image_path + '/original'

begin
  paths.each do |path|
    FileUtils.mkdir_p(path) unless FileTest.exist?(path)
  end
rescue => exception
  puts 'ディレクトリの作成に失敗しました'
  return false
end
  
puts 'ディレクトリの作成に成功しました'