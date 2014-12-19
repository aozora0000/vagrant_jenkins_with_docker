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

|       plugin名       |             役割              |
|:-------------------:|:---------------------------:|
|      ansicolor      |           ログの色付け            |
|  categorized-view   |         リストビューグループ化         |
|       ci-skip       |           ビルドスキップ           |
|      cloverphp      |        PHP カバレッジ表示用         |
|     credentials     |            認証設定             |
|     disk-usage      |         ディスク使用量を計測          |
|      envinject      |           環境変数の設定           |
|    extra-columns    |          リストビュー拡張           |
|         git         |           GITコマンド           |
|     git-client      |            上に同じ             |
|      gravatar       | ***simple-theme-plugin依存*** |
|       jquery        | ***simple-theme-plugin依存*** |
|       locale        |            言語変更用            |
|     monitoring      |         Jenkinsの監視          |
|  pegdown-formatter  |       MarkDownっぽくコメント       |
|    sidebar-link     |           サイドバー拡張           |
| simple-theme-plugin |           デザインを変更           |
|     timestamper     |        コンソール出力に時間を表示        |
|  idobata-notifier   |      IDOBATAにビルド結果を送信       |
|       hipchat       |      HIPCHATにビルド結果を送信       |

### オススメテーマ
#### [Jenkins Atlassian Theme](https://github.com/djonsson/jenkins-atlassian-theme)
- http://master.source.test.do/dist/theme.css
- http://master.source.test.do/dist/theme.js

## .jenkins.ymlについて
*** /usr/local/src/jenkins *** 内のスクリプトでパースしています。

.jenkins.ymlを利用する場合には
- リポジトリ内に***.jenkins.yml***を設置
- ビルド手順→シェルの実行に以下を追加

```
sh /usr/local/src/jenkins/bootstrap.sh
sh /usr/local/src/jenkins/docker.sh
```

### 各パラメータについて

#### 例
```
container: jenkins-ci-base
env:
    - name: Jenkins
script:
    - echo "Hello Jenikins!"
```

#### container
利用するdockerイメージ名を記入

- ***jenkins-ci-base***
- ***jenkins-ci-php***
- ***jenkins-ci-ruby***
- ***jenkins-ci-node***

```
container: jenkins-ci-php
```

#### env (未テスト)
環境変数を入力
```
env:
    - test: 1
    - test2: 2
```
#### install(未テスト)
ビルドに関連するパッケージ等のインストールを実行
```
install:
    - pecl install APC
    - rbenv global 1.9.3
```

#### before_script(未テスト)
ビルド・テストスクリプトの実行前に実行
```
before_script:
    - APP_ENV="development"
```

#### script
ビルド・テストスクリプト
```
script:
    - phpunit --testdox ./tests
```

#### after_script(未テスト)
ビルド・テスト後の実行後に実行
```
script:
    - cat ./log/build_log.txt
```

## Idobata利用時
ビルド処理
```
BRANCH=$(git symbolic-ref HEAD 2>/dev/null)
COMMIT_ID=$(git log -1 --format='%H')
```

success html形式
```
Project ${project} ${BRANCH} build <a href="$url">#${number} ${COMMIT_ID}</a>:<span class="label label-success">SUCCESS</span>
```

failed html形式
```
Project ${project} ${BRANCH} build <a href="$url">#${number} ${COMMIT_ID}</a>:<span class="label label-failure">FAILED</span>
```
