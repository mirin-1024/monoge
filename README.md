# アプリケーション概要
monogeは、ユーザーの持っている「モノ」をリスト上にして管理するサービスです。
また、作成したリストを元にユーザー同士の情報共有およびユーザー同士の交流を図るSNSでもあります。

https://monoge.net （※ ゲストログインをクリックすることで、ゲストアカウントとしてログインできます）

![monoge_toppage](https://user-images.githubusercontent.com/63091391/108628424-30f5c500-749e-11eb-9a23-d30876fce9b0.png)
## 利用方法
**ユーザーはまずリストで管理したい場所を決め、モノを追加**します。
モノをリストへ追加する方法は、自分で情報を入力する方法と検索結果から商品情報を追加する方法の2通りあります。
このリストにモノを1つずつ追加するという過程において、一つ一つのモノが本当に必要かと検討する機会になると考えています。

**随時自分のリストを更新しながら、自分以外のユーザーと投稿機能やコメント機能を使って交流**したり、**自分以外のユーザーのモノリストを見て自らの断捨離やより良い製品選びに生かしていただく**ことを想定しています。

## 制作動機
**技術を用いて断捨離を試みる人やミニマルな生活を実現したい人が便利に使えるサービスを作成したいと考えたためです。**

私は大学卒業後の引越しで感じた面倒臭さから断捨離への志向が強くなり、その後新しく快適な生活環境を整えようとする中で、IoT家電を導入して家事等の生活の自動化を実現しました。この経験から、**自らも技術を用いてサービスを作成し、人の生活を便利にしたい**と考えるようになりました。

また、実際に私がモノ管理サービスを利用しようとしたところ、あまり便利なサービスが見つからなかったことや、世界的にミニマリストへの関心は高まっており、**サービスとしての需要や将来性も十分である**と推測したことも一因です。

画像：Google Trendsより キーワード「minimalist」の人気度の動向
![google trends search](https://user-images.githubusercontent.com/63091391/108628295-749bff00-749d-11eb-9a4b-757e72c9a3e0.png)

# 機能一覧
### ユーザーアカウント管理機能
* ユーザー作成/表示/編集/削除/一覧表示機能
  * 画像アップロード機能
* ログイン/ログアウト機能
* アカウント有効化機能（メーラーを使用）
* パスワード再設定機能（メーラーを使用）
* 管理者機能
* ゲストユーザーでのログイン機能
* フォロー機能（Ajax利用）
### 投稿機能
* 投稿作成/表示/削除/一覧表示機能
  * 画像アップロード機能
* いいね機能（Ajax利用）
* コメント機能（Ajax利用）
### モノ管理リスト機能
* リストの作成/一覧表示/編集/削除機能（Ajax利用）
  * 画像アップロード機能
* 楽天プロダクトを用いた商品検索および検索結果のリスト追加機能
### 検索機能
* ユーザーの検索
* 投稿の検索

# 工夫した点
* 楽天プロダクトAPIを使用し、検索した商品情報をクリックするのみでリストへ追加する機能の実装
1. ログイン後、アカウント名下の[モノリスト]ボタンをクリックします。
<img width="1440" alt="rws-search-1" src="https://user-images.githubusercontent.com/63091391/109059358-842e7880-7727-11eb-8f65-196389e07763.png">
2. あなたのモノリストが表示されるので、新規リスト作成フォームの下部にある[楽天プロダクト商品検索]をクリックします。
<img width="1440" alt="rws-search-2" src="https://user-images.githubusercontent.com/63091391/109059356-8395e200-7727-11eb-9010-fa65e0f7e994.png">
3. 商品検索ページに遷移するので、リストに追加したい商品の名称をフォームに記入し、[検索]ボタンをクリックします。
<img width="1440" alt="rws-search-3" src="https://user-images.githubusercontent.com/63091391/109059355-8395e200-7727-11eb-9b3d-1b9219483379.png">
4. 検索結果が表示されるので、追加したい商品の右にある[追加]ボタンをクリックします。
<img width="1440" alt="rws-search-4" src="https://user-images.githubusercontent.com/63091391/109059352-82fd4b80-7727-11eb-80bd-ae89dfd5a0e1.png">
5. モノリストに追加したい商品が追加されました。
<img width="1440" alt="rws-search-5" src="https://user-images.githubusercontent.com/63091391/109059333-7da00100-7727-11eb-8d72-89728782cdb4.png">

* GitHub Issue, Slackを用いた擬似チーム開発

# 使用技術
## バックエンド
* 言語：Ruby 2.7.1
* フレームワーク：Rails 6.0.3
### テスト
フレームワーク：RSpec(+ Capybara, Factorybot, Webdrivers)
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

【学習期間】  
2020.6〜2020.11：コンピュータサイエンス・プログラミングの基礎学習  
2020.11〜現在：ポートフォリオ「monoge」の開発
