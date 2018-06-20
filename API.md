# API仕様書

## WebAPI URL

https://mind-cpndd.slis.tsukuba.ac.jp/position/create/

## API 入力

- method : Post
- datatype : Json

POSTデータ

|name           |type     |require|description                                                          |
|---------------|---------|-------|---------------------------------------------------------------------|
|position_type  |string   |false  |システム : 1, 外部システム : 2                                         |
|longitude      |string   |true   |緯度                                                                  |
|latitude       |string   |true   |経度                                                                  |
|disaster_id    |string   |false  |災害の種類 アイコンの判別に使っているためなければデフォルトのピンになります |
|image          |file     |false  |画像がアップロードできます                                              |
|description    |string   |false  |その他、コメントがありましたらここに入れてください                        |

## API 返答

datatype : json

|name           |type     |description                                                          |
|---------------|---------|---------------------------------------------------------------------|
|error          |boolean  |true : 以上あり, false : 異常なし                                      |
|message        |string   |errorがtureであればエラーメッセージが入る                                |
|status         |string   |Http ステータスコード                                                   |
|result         |class    |[未実装] 登録した位置情報                                               |