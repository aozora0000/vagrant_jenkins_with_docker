# Vagrant Jenkins+Docker CI環境構築編

Vagrantから使えるJenkinsサーバーです。

Github/Bitbucketと連携し、ビルド環境用のDockerイメージを選択・利用出来るようになっています。

またAnsibleで作成されているので、VPSやベアメタルサーバーにも応用出来るかと思われます。

## ホストOS環境
- Ansible 1.8.2 <=
- Vagrant 1.6.5 <=
- Serverspec

## ゲストOS環境
- CentOS 6
- jenkins:jenkinsユーザー HOME: ***/var/lib/jenkins*** ルートからはNOPASSでsu出来ます

## 起動後
```
$ su - jenkins
$ ssh-keygen -t rsa
$ cat ~/.ssh/id_rsa.pub
```

出てきた公開鍵をGithubやBitbucketに設定

```
$ ssh -vT git@github.com
$ ssh -vT bitbucket.org
```

.ssh/configの初期設定
```
Host bitbucket.org
    HostName bitbucket.org
    IdentityFile ~/.ssh/id_rsa
    User git

Host github
    HostName github.com
    IdentityFile ~/.ssh/id_rsa
    User git

```

## Jenkinsについて
色々なJenkinsプラグインを導入しています。

|        plugin名        |             役割              |
|:---------------------:|:---------------------------:|
|       ansicolor       |           ログの色付け            |
|   categorized-view    |         リストビューグループ化         |
| build-monitor-plugin  |      ダッシュボードでビルドの進捗確認       |
|   buildtriggerbadge   |    サイドバーのビルド履歴でトリガーバッジ表示    |
| build-pipeline-plugin |          ビルドパイプライン          |
|        ci-skip        |           ビルドスキップ           |
|       cloverphp       |        PHP カバレッジ表示用         |
| configurationslicing  |           設定の共通化            |
|      credentials      |            認証設定             |
|      disk-usage       |         ディスク使用量を計測          |
|       envinject       |           環境変数の設定           |
|     extra-columns     |          リストビュー拡張           |
|          git          |           GITコマンド           |
|      git-client       |            上に同じ             |
|       gravatar        | ***simple-theme-plugin依存*** |
|        jquery         | ***simple-theme-plugin依存*** |
|        locale         |            言語変更用            |
|      monitoring       |         Jenkinsの監視          |
|   pegdown-formatter   |       MarkDownっぽくコメント       |
|     sidebar-link      |           サイドバー拡張           |
|  simple-theme-plugin  |           デザインを変更           |
|      timestamper      |        コンソール出力に時間を表示        |

### オススメテーマ
#### [Jenkins Atlassian Theme](https://github.com/djonsson/jenkins-atlassian-theme)
- http://master.source.test.do/dist/theme.css
- http://master.source.test.do/dist/theme.js

## .jenkins.ymlについて
*** /usr/local/src/jenkins *** 内のスクリプトでパースしています。

.jenkins.ymlを利用する場合には
- リポジトリ内に***.jenkins.yml***を設置
- ビルド手順→シェルの実行に以下を追加

.jenkins.yml内では環境変数が使えます(textで登録)
- Jenkinsのプロジェクト内環境変数
- Jenkinsのグローバル環境変数

```
yaml-parser .jenkins.yml
sh build.sh
```

### 各パラメータについて

#### 例
```
container: aozora0000/jenkins-ci-php:latest
steps:
    - name: composerインストール
      code: composer install --no-interaction --no-dev --no-progress
    - name: PHPUNIT起動
      code: phpunit
notify:
    - service: idobata
      token: $IDOBATA_TOKEN
    - service: hipchat
      token: $HIPCHAT_TOKEN
      room_id: $HIPCHAT_ROOM_ID
      from: Jenkins
```

#### container
利用するdockerイメージ名を記入

- ***aozora0000/jenkins-ci-base***
- ***aozora0000/jenkins-ci-php***
- ***aozora0000/jenkins-ci-ruby***
- ***aozora0000/jenkins-ci-node***

```
container: jenkins-ci-php:latest
container: jenkins-ci-php:5.3.*
```

#### steps
ビルドに関連するパッケージ等のインストールを実行
```
steps:
    - name: composerインストール
      code: composer install --no-interaction --no-dev --no-progress
    - name: PHPUNIT起動
      code: phpunit
    - code: rm -rf vendor/
```


#### notify
ビルド・テスト後に通知処理
- ***hipchat***
- ***idobata***

```
notify:
    - service: idobata
      token: $IDOBATA_TOKEN
    - service: hipchat
      token: $HIPCHAT_TOKEN
      room_id: $HIPCHAT_ROOM_ID
      from: Jenkins
```

## パーサー・通知スクリプトのアップデート
```
curl -L https://raw.githubusercontent.com/aozora0000/jenkins_scripts/master/update.sh | bash
```
