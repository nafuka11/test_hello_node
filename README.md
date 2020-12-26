# test_hello_node

hello_node のテスターです。

## 使い方

1. リポジトリをclone

   テストしたいプロジェクトより1階層上でcloneしてください。

   ```
   git clone https://github.com/nafuka11/test_hello_node.git
   ```

1. テストしたいプロジェクトのパスを指定

   デフォルトは `../hello_node` になっています。

   プロジェクトのディレクトリパスが異なる場合は、grademe.sh にある `PROJECT_DIR` を変更してください。

1. テストを実行

   `test_hello_node` のディレクトリに移動し、

   ```
   ./grademe.sh
   ```

   を実行してください。

## 注意

URLにアクセスするため、1秒間に何度もスクリプトを実行するような使い方は控えていただきますよう、お願いいたします。
