class Aiiiiiin < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :public_folder => "public", :static => true

  before do
    @vision = 'やることのストレスを無くす'
    @vision_copy = 'ストレスフリーなやること通知サービス'
    @thanks = <<-'MSG'
    Thank you!</h2>
    <p class="lead">ご協力ありがとうございます。頂いたご意見を元に更にサービスを改善させて行きたいと思います。</p>
    </div>
    MSG
    @base = 'base'
    @case01 = 'case01'
    @setting = @base
  end

  get "/" do
    case @setting
    when @base
      @ok_base_block01_count = Metric.where(case: @base, block: 'block01', pattern: 'OK').sum(:count)
      @ng_base_block01_count = Metric.where(case: @base, block: 'block01', pattern: 'NG').sum(:count)
      @ok_base_block02_count = Metric.where(case: @base, block: 'block02', pattern: 'OK').sum(:count)
      @ng_base_block02_count = Metric.where(case: @base, block: 'block02', pattern: 'NG').sum(:count)
      @ok_base_block03_count = Metric.where(case: @base, block: 'block03', pattern: 'OK').sum(:count)
      @ng_base_block03_count = Metric.where(case: @base, block: 'block03', pattern: 'NG').sum(:count)

    end

    erb :welcome
  end

  get '/ok/:case/:block' do |arg1,arg2|
    set_ok_metric(arg1,arg2)
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
