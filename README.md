Aiiiiin
===
# 目的
ストレスフリーなやること通知サービスを提供する

# 前提
| ソフトウェア     | バージョン    | 備考         |
|:---------------|:-------------|:------------|
| OS X           |10.10        |             |
| ruby      　　　|2.1.5         |             |
| redis     　　　|2.8.17         |             |

# 構成
+ [アプリケーション](#1)
+ [ランディングページ](#2)
+ [デプロイ](#3)

# 詳細
## <a name="1">アプリケーション</a>
### セットアップ

```bash
$ hazel aiiiiiin --bundle
$ cd aiiiiii
```

### Gemfile編集
```
$ bundle
$ guard init
$
```

## <a name="2">ランディングページ</a>

### セットアップ

```bash
$ bundle exec foreman start
```

_http://localhost:9292/_で動作を確認する。

### ランディングページ作成
Bootstrap適用

_views/layout.erb_

```
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
```

_public/stylesheets/main.css_  
_views/layout.erb_  
_views/welcome.erb_

### A/BテストフレームワークSplit適用

_Gemfile_

```ruby
gem "split",  github: "andrew/split"
```

_config.ru_

```ruby
require 'split/dashboard'

# Split::Dashboard.use Rack::Auth::Basic do |username, password|
#   username == 'admin' && password == 'password'
# end

run Rack::URLMap.new \
  "/"       => Aiiiiiin.new,
  "/split" => Split::Dashboard.new
```

_config/initializers/split.rb_

```ruby
require 'split'

Split.configure do |config|
end
```

## <a name="3">デプロイ</a>


# 参照
+ [Bootply](http://www.bootply.com/)
+ [Split](https://github.com/andrew/split)
+ [davatron5000/FitVids.js](https://github.com/davatron5000/FitVids.js)
+ [Hazel](http://c7.github.io/hazel/)
+ [Start Bootstrap](http://startbootstrap.com/template-overviews/landing-page/)
