# monoge
monogeは、ユーザーの持っている「モノ」をリスト上にして管理するサービスです。
また、作成したリストを元にユーザー同士の情報共有およびユーザー同士の交流を図るSNSでもあります。

https://monoge.net ※ゲストログインをクリックすることで、ゲストアカウントとしてログインできます

![monoge_toppage](https://user-images.githubusercontent.com/63091391/108628424-30f5c500-749e-11eb-9a23-d30876fce9b0.png)

# 制作動機
**技術を用いて断捨離を試みる人やミニマルな生活を実現したい人が便利に使えるサービスを作成したいと考えたためです。**

私は大学卒業後の引越しで感じた面倒臭さから断捨離への志向が強くなり、その断捨離を機に新しく快適な生活環境を整えようとする中で、IoT家電を導入して家事等の生活の自動化を実現しました。この経験から、**自らも技術を用いてサービスを作成し、人の生活を便利にしたい**と考えるようになりました。

また、実際に私がモノ管理サービスを利用しようとしたところ、あまり便利なサービスが見つからなかったことや、世界的にミニマリストへの関心は高まっており、**サービスとしての需要や将来性も十分であると推測した**ことも一因です。

![google trends search](https://user-images.githubusercontent.com/63091391/108628295-749bff00-749d-11eb-9a4b-757e72c9a3e0.png)

# 機能一覧
### ユーザーアカウント管理機能
* ユーザー作成/表示/編集/削除機能
  * 画像アップロード機能
* ログイン/ログアウト機能
* アカウント有効化機能（メーラーを使用）
* パスワード再設定機能（メーラーを使用）
* 管理者機能
* ゲストユーザーでのログイン機能
* フォロー機能（Ajax利用）
### 投稿機能
* 投稿作成/表示/削除機能
  * 画像アップロード機能
* いいね機能（Ajax利用）
* コメント機能（Ajax利用）
### モノ管理リスト機能
* リストの作成/表示/編集/削除機能（Ajax利用）
  * 画像アップロード機能
* **楽天プロダクトを用いた商品検索および検索結果のリスト追加機能**
### 検索機能
* ユーザーの検索
* 投稿の検索

# 工夫した点
* 楽天プロダクトAPIを使用し、検索した商品情報をクリックするのみでリストへ追加する機能の実装
1. ログイン後、アカウント名下の[モノリスト]ボタンをクリックします。
![rws search description1](https://user-images.githubusercontent.com/63091391/108630311-5d620f00-74a7-11eb-81bb-94461f09aa8c.png)
2. あなたのモノリストが表示されるので、新規リスト作成フォームの下部にある[こちら]をクリックします。
![rws search description2](https://user-images.githubusercontent.com/63091391/108630310-5cc97880-74a7-11eb-8814-c0d52dc4432f.png)
3. 商品検索ページに遷移するので、リストに追加したい商品の名称をフォームに記入し、[検索]ボタンをクリックします。
![rws search description3](https://user-images.githubusercontent.com/63091391/108630309-5c30e200-74a7-11eb-9e7e-431ab1b53139.png)
4. 検索結果が表示されるので、追加したい商品の右にある[追加]ボタンをクリックします。
![rws search description4](https://user-images.githubusercontent.com/63091391/108630308-5c30e200-74a7-11eb-84f5-3fb7f4d57329.png)
5. モノリストに追加したい商品が追加されました。
![rws search description5](https://user-images.githubusercontent.com/63091391/108630302-5804c480-74a7-11eb-8fd9-e976f4455682.png)

* GitHub Issue, Slackを用いた擬似チーム開発

# 使用技術
## バックエンド
* 言語：Ruby 2.7.1
* フレームワーク：Rails 6.0.3
### テスト
フレームワーク：RSpec(+ Capybara, Factorybot, selenium-webdriver)
## フロントエンド
* 言語：HTML/CSS, Sass, JavaScript(一部jQuery)
* フレームワーク：Bootstrap4
## データベース
MySQL 8.0
## バージョン管理
Git, GitHub
## 開発環境
* 仮想化：Docker, Docker Compose
* 静的解析：Rubocop
## CI/CD
CircleCI
## インフラ
AWS(ECR, ECS, ALB, RDS, S3, Route53, ACM) 
### サーバー
* Webサーバー：Nginx  
* アプリケーションサーバー：Puma
### 構成図
![monoge infrastracture map2](https://user-images.githubusercontent.com/63091391/108628289-6e0d8780-749d-11eb-8251-41ecd1a64911.png)

# 改善点
* Amazon Product APIが導入できなかった点
* レスポンシブ対応が不完全である点
* SPA化されていない点
