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

   `test_hello_node` のディレクトリに移動してからスクリプトを実行します。

   - 全てのテストを実行したい場合

     ```bash
     ./grademe.sh
     ```

   - 一部のテストを実行したい場合

     exerciseを指定することができます。

     ```bash
     # ex00をテスト
     ./grademe.sh ex00
     # ex00から05までテスト
     ./grademe.sh ex{00..05}
     ```

## 注意

URLにアクセスするため、1秒間に何度もスクリプトを実行するような使い方は控えていただきますよう、お願いいたします。
