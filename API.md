# API仕様書

ウェブアプリケーションではプロジェクトごとにデータを管理します.そのため、APIの使用にはプロジェクトごとのtokenが必要となります.

## 位置情報登録

報告のあった場所を登録するAPI

### WebAPI URL

https://mind-cpndd.slis.tsukuba.ac.jp/position/create/

### API 入力

- method : Post
- datatype : Json

POSTデータ

|name           |type     |require|description                                                          |
|---------------|---------|-------|---------------------------------------------------------------------|
|project_token  |string   |true   |プロジェクトのAPIトークン. 送らない場合エラーになります                   |
|position_type  |string   |false  |システム : 1, 外部システム : 2                                         |
|longitude      |string   |true   |緯度                                                                  |
|latitude       |string   |true   |経度                                                                  |
|disaster_id    |string   |false  |災害の種類 アイコンの判別に使っているためなければデフォルトのピンになります |
|image          |file     |false  |画像がアップロードできます                                              |
|description    |string   |false  |その他、コメントがありましたらここに入れてください                        |

### API 返答

datatype : json

|name           |type     |description                                                          |
|---------------|---------|---------------------------------------------------------------------|
|error          |boolean  |true : 以上あり, false : 異常なし                                      |
|message        |string   |errorがtureであればエラーメッセージが入る                                |
|status         |string   |Http ステータスコード                                                   |
|result         |class    |[未実装] 登録した位置情報                                               |

## 位置情報取得

プロジェクトで登録された位置情報を取得するAPI

### WebAPI URL

https://mind-cpndd.slis.tsukuba.ac.jp/position/index/

### API 入力

- method : Get
- datatype : Json

POSTデータ

|name           |type     |require|description                                                          |
|---------------|---------|-------|---------------------------------------------------------------------|
|project_token  |string   |true   |プロジェクトのAPIトークン. 送らない場合エラーになります                   |
|position_id    |string   |false  |指定したid以降の位置情報を取得する                                      |

### API 返答

datatype : json

|name           |type     |description                                                                |
|---------------|---------|---------------------------------------------------------------------------|
|error          |boolean  |true : 以上あり, false : 異常なし                                            |
|message        |string   |errorがtureであればエラーメッセージが入る                                      |
|status         |string   |Http ステータスコード                                                        |
|result         |class    |プロジェクトで登録した位置情報, position_idを指定しない場合すべての位置情報を返す |