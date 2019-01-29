class Web::ThemesController < Web::ApplicationController
  before_action :set_themes
  before_action :set_theme, :only => %(show)
  before_action :set_entries

  def index
    render :show
  end

  def show
    respond_to do |format|
      format.html
      format.json {
        render :json => @theme, :collections => {:except => %w(theme cards)}
      }
    end
  end

  protected

    def set_themes
      @themes = Theme.all
    end
    def set_theme
      @theme = Theme.find_by_real_id(params[:real_id])

      raise ActionController::RoutingError.new('Not Found') if @theme.nil?
    end
    def set_entries
      @entries = TwitterWrapper.new().get_tweets 4
    end
end
