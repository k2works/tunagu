class Tunaguu < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  helpers Split::Helper

  set :public_folder => "public", :static => true

  before do
    @vision = 'やることのストレスを無くす'
    @vision_copy = 'ストレスフリーなやること通知サービス'
    @thanks = <<-'MSG'
    Thank you!</h2>
    <p class="lead">ご協力ありがとうございます。サービス開始時にはご登録いただいたメールアドレスにご連絡させていただきます。</p>
    </div>
    MSG
    @base = 'base'
    @case01 = 'case01'
    @setting = @base
  end

  get "/" do
    @ok_base_block01_count = Metric.where(case: @setting, block: 'block01', pattern: 'OK').sum(:count)
    @ng_base_block01_count = Metric.where(case: @setting, block: 'block01', pattern: 'NG').sum(:count)
    @ok_base_block02_count = Metric.where(case: @setting, block: 'block02', pattern: 'OK').sum(:count)
    @ng_base_block02_count = Metric.where(case: @setting, block: 'block02', pattern: 'NG').sum(:count)
    @ok_base_block03_count = Metric.where(case: @setting, block: 'block03', pattern: 'OK').sum(:count)
    @ng_base_block03_count = Metric.where(case: @setting, block: 'block03', pattern: 'NG').sum(:count)

    case @setting
    when @base
      @youtubu = ab_test('base_youtubu', 'cpifXF_yI1M', 'cpifXF_yI1M', 'cpifXF_yI1M')

      @block01_titile = ab_test('base_block01', '登録', '登録する', 'やっていみる')

      @block01_body_type1 = <<-'MSG'
      友達にあった時借りた物を返す必要はありませんか？仕事で取引先の人にあった時に確認したいことや
      渡しておきたい資料はありませんか？<br>
      そんな時はAiiiiiinに相手の名前と会った時にやることを登録してきましょう。
      MSG

      @block01_body = @block01_body_type1

      @block02_titile = ab_test('base_block02', 'Aiiiiiin', 'Aiiiiiinする', '知らせを受ける')

      @block02_body_type1 = <<-'MSG'
      やることを登録すれば後はなにもする必要はありません。その人に会った時にAiiiiiinがあなたに通知してくれるのです。
      もうメモ帳に忘れないようにメモする必要も何かやることはなかったか心配する必要はありません。<br>
      Aiiiiiinがあなたの代わりに誰に合った時何をするのかを教えてくれるのです！やるべきことを登楼したら後は忘れてしまいましょう！
      大丈夫、その時になったらAiiiiiinが教えてくれます。
      MSG

      @block02_body = @block02_body_type1

      @block03_titile = ab_test('base_block03', 'ハッピー', 'ハッピーになる', 'いいようになる')

      @block03_body_type1 = <<-'MSG'
      面倒なことはAiiiiiinに任せてより本質的なことに集中しましょう。<br>
      Aiiiiiinは日常の煩わしさからあなたを開放しよりハッピーな人生を送るお手伝いをします。
      MSG

      @block03_body = @block03_body_type1
    end

    erb :welcome
  end

  post "/regist" do
    regist = Regist.new
    regist[:email] = params[:email]
    regist.save
    finished(@setting+'_youtubu')
    erb :thanks
  end

  get "/student" do
    erb :student
  end

  get "/society" do
    erb :society
  end

  get "/checkin" do
    erb :checkin
  end

  get "/notify" do
    erb :notify
  end

  get "/matching" do
    erb :matching
  end

  get "/talk/:id" do
    erb :talk
  end


  get '/ok/:case/:block' do |arg1,arg2|
    set_ok_metric(arg1,arg2)

    case arg2
    when 'block01'
      finished(@setting+'_block01')
    when 'block02'
      finished(@setting+'_block02')
    when 'block03'
      finished(@setting+'_block03')
    end

    redirect '/'
  end

  get "/ng/:case/:block" do |arg1,arg2|
    set_ng_metric(arg1,arg2)
    redirect '/'
  end

  get "/thanks" do
    erb :thanks
  end

  def set_ok_metric(metric_type,block)
    metric = Metric.where(case: metric_type,block: block, pattern: 'OK')
    if metric.empty?
      metric = Metric.new
      set_metric(metric,metric_type,block,'OK')
      metric.save
    else
      metric[0][:count] += 1
      metric[0].save
    end

  end

  def set_ng_metric(metric_type,block)
    metric = Metric.where(case: metric_type,block: block, pattern: 'NG')
    if metric.empty?
      metric = Metric.new
      set_metric(metric,metric_type,block,'NG')
      metric.save
    else
      metric[0][:count] += 1
      metric[0].save
    end

  end

  def set_metric(metric,metric_type,block,pattern)
    metric[:case] = metric_type
    metric[:block] = block
    metric[:pattern] = pattern
    metric[:count] = 1
  end
end

class Metric < ActiveRecord::Base

end

class Regist < ActiveRecord::Base
  validates_presence_of :email
end
