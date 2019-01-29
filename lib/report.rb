class Report
  attr_reader :url, :context, :ip, :host, :errors

  def initialize(options = {})
    @url     = options[:url] if options[:url].is_a? String
    @context = options[:context] if options[:context].is_a? String
    @ip      = options[:ip] if options[:ip].is_a? String
    @host    = options[:host] if options[:host].is_a? String

    @errors = !@url.nil? && @url.length > 10 && !@host.nil? &&  @host.include?(@url) && !@context.nil? && @context.length > 2 && @context.length < 1000

    key = "reports.#{@ip}"
    if Rails.cache.read key
      @errors = true
    else
      Rails.cache.write key, true, :expires_in => 1.minutes
    end
  end

  def has_errors?
    @errors
  end
end
