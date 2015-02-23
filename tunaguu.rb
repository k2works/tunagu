class Tunaguu < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  helpers Split::Helper

  set :public_folder => "public", :static => true

  before do
    @vision = 'やることのストレスを無くす'
    @vision_copy = 'やることは登録するだけ'
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
      @youtubu_biz = ab_test('base_youtubu_biz', 'OVRvD-pA1y4')
      @youtubu_std = ab_test('base_youtubu_std', 'j9SNAUHnwEU')
      @youtubu_demo = ab_test('base_youtubu_demo', 'GtsQbvPrrBI')

      @block01_titile = ab_test('base_block01', '登録', '登録する')

      @block01_body_type1 = <<-'MSG'
      やることはサービスに登録して自分の解決したい問題を登録するだけ。
      MSG

      @block01_body = @block01_body_type1

      @block02_titile = ab_test('base_block02', 'TUNAGUU', '通知を受ける')

      @block02_body_type1 = <<-'MSG'
      登録が完了したらあとは問題を解決してくれそうな場所に行くだけ！<br>
      そこに問題を解決してくれる人がいればTUNAGUUが通知してくれます。
      MSG

      @block02_body = @block02_body_type1

      @block03_titile = ab_test('base_block03', 'ハッピー', 'ハッピーになる')

      @block03_body_type1 = <<-'MSG'
      TUNAGUUは日々の問題からあなたを開放しよりハッピーな人生を送るお手伝いをします。
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

  post "/student" do
    finished(@setting+'_youtubu_std')
    @@student = params[:name]
    redirect "/thanks"
  end

  get "/society" do
    erb :society
  end

  post "/society" do
    finished(@setting+'_youtubu_biz')
    @@society = params[:name]
    redirect "/thanks"
  end

  get "/checkin" do
    erb :checkin
  end

  get "/notify" do
    @@society ||= ""
    @society = @@society
    erb :notify
  end

  get "/matching" do
    @chats = chats
    @@society ||= ""
    @society = @@society
    erb :matching
  end

  get "/talk" do
    erb :talk
  end

  get "/talk/teach" do
    chats << [:me, student, "教えてください！！"]
    redirect "/matching"
  end

  get "/talk/friends" do
    chats << [:me, student, "友達になってください"]
    redirect "/matching#btm"
  end

  get "/talk/like" do
    chats << [:me, student, "いいよ！"]
    redirect "/matching#btm"
  end

  get "/talk/sorry" do
    chats << [:me, student, "ごめんなさい"]
    redirect "/matching#btm"
  end

  get "/ura/like" do
    chats << [:you, society, "いいよ！"]
    ""
  end

  get "/ura/sorry" do
    chats << [:you, society, "ごめんなさい"]
    ""
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

  get "/clear" do
    @@chats = []
    @@society = "うえはそ"
    @@student = "学生"
    ""
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

  def chats
    @@chats ||= []
  end

  def student
    @@student ||= "学生"
  end

  def society
    @@society ||= "うえはそ"
  end

end

class Metric < ActiveRecord::Base

end

class Regist < ActiveRecord::Base
  validates_presence_of :email
end
