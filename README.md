# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

positions

|name           |type     |null   |default  |description  |
|---------------|---------|-------|---------|-------------|
|position_type  |int      |false  |0        |送信元        |
|longitude      |decimal  |false  |999      |緯度          |
|latitude       |decimal  |false  |999      |経度          |
|description    |string   |false  |         |何があったか   |

disaster

|name           |type     |null   |default  |description  |
|---------------|---------|-------|---------|-------------|
|disaster_name  |string   |false  |         |災害の名称    |
|image          |string   |false  |         |災害のアイコン |

* Database initialization

* How to run the test suite
  - テストではrpsecを用いる
  - command : bundle exec rails spec or rails spec

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* 初めに行うこと
  - secrets_sample.ymlを複製してsecrets.ymlにリネーム、各種キーを設定する
