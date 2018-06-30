# README

* 初めに行うこと
  1. secrets_sample.ymlを複製してsecrets.ymlにリネーム、各種キーを設定する
  2. application/provisioning/files/.vault_password_sampleをホームに.vault_passwordという名前でコピーし、いつものパスワードを入力
  3. applicationディレクトリに移動し以下のコマンドを順に入力
      * bundle install
      * bundle exec rails db:create
      * bundle exec rails db:migrate
      * bundle exec rails db:seed

* 本番環境反映

  1. 本番環境にログイン
  2. masterをプルする
  3. applicationディレクトリに移動, sh start.shと打つ

* 画像設定

  画像をアップロードするとサイズを変更した複数の画像が生成されます

  - original max 1920*1080
  - icon 40*40
  - table 60*60
  - map_information 600*450

* Ruby version

  2.4.2

* Database creation

  positions

  |name           |type     |null   |default  |description  |
  |---------------|---------|-------|---------|-------------|
  |position_type  |int      |false  |0        |送信元        |
  |longitude      |decimal  |false  |999      |経度          |
  |latitude       |decimal  |false  |999      |緯度          |
  |disaster_id    |integer  |false  |         |災害の種類     |
  |description    |string   |false  |         |何があったか   |

  disaster

  |name           |type     |null   |default  |description  |
  |---------------|---------|-------|---------|-------------|
  |disaster_name  |string   |false  |         |災害の名称    |
  |image          |string   |false  |         |災害のアイコン |

* Database initialization
  1. bundle exec rails db:create
  2. bundle exec rails db:migrate
  3. bundle exec rails db:seed(初回のみ、管理者ページ用のアカウントが発行されます)

  本番環境で動かす場合はまず開発環境で、ansibleで暗号化されているファイルを編集してください. vagrantでログインし, /application/provisioning/varsに移動、以下のコマンドで編集できます

  ansible-vault edit secret.yml --vault-password-file ~/.vault_password

  特に編集の必要がなければそのままにしておいてください

* How to run the test suite
  * テストではrpsecを用いる
  * command : bundle exec rails spec or rails spec
