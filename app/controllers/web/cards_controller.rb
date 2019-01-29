class Web::CardsController < Web::ApplicationController
  before_action :set_themes
  before_action :set_theme
  before_action :set_collection
  before_action :set_card, :only => %w(show read)

  before_action :authenticate_user!, :only => %w(read)

  load_and_authorize_resource

  def index
    @cards = @collection.cards.order_id.page(params[:page])

    respond_to do |format|
      format.html do
        @card  = @cards.first

        redirect_to theme_collection_card_path @theme, @collection, @card
      end
      format.json do
        render :json => {
          :theme => @theme.to_serializer(serializer_options(:except => %w(collections))),
          :collection => @collection.to_serializer(serializer_options(:except => %w(theme cards))),
          :cards => @cards.to_serializer(serializer_options.merge(:except => %w(theme collection))),
          :meta => {
            :current_page => @cards.current_page,
            :next_page => @cards.next_page,
            :prev_page => @cards.prev_page
          }
        }
      end
    end
  end

  def show
    @cards = @collection.cards.order_id.page 1
  end

  def read
    if current_user.card_readed? @card
      current_user.cards.delete @card
    else
      current_user.cards << @card
    end

    respond_to do |format|
      format.html do
        redirect_to theme_collection_card_path @theme, @collection, @card
      end
      format.json do
        render :json => {
          :card => @card.to_serializer(serializer_options.merge(:except => %w(theme collection))),
          :meta => {
            :status => (@card.errors.any? ? 'Fail' : 'Success'),
            :errors => @card.errors.messages
          }
        }
      end
    end
  end

  protected

    def set_themes
      @themes = Theme.all
    end

    def set_theme
      @theme = Theme.find_by_real_id(params[:theme_real_id])

      raise ActionController::RoutingError.new('Not Found') if @theme.nil?
    end
    def set_collection
      @collection = Collection.find_by_real_id(params[:collection_real_id])

      raise ActionController::RoutingError.new('Not Found') if @collection.nil?
    end
    def set_card
      @card = Card.find_by_real_id(params[:real_id] || params[:card_real_id])

      raise ActionController::RoutingError.new('Not Found') if @card.nil?
    end
end
