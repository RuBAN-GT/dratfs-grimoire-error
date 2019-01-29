class Web::CollectionsController < Web::ApplicationController
  before_action :set_collection, :only => %(update)
  before_action :authenticate_user!, :only => %w(update)

  def update
    @collection.update(collection_params)

    respond_to do |format|
      format.json do
        render :json => {
          :collection => @collection.to_serializer({
            :except => %w(theme),
            :cards => {:except => %w(theme collection)}
          }),
          :meta => {
            :status => (@collection.errors.any? ? 'Fail' : 'Success'),
            :errors => @collection.errors.messages
          }
        }
      end
    end
  end

  protected

    def set_theme
      @theme = Theme.find_by_real_id(params[:theme_real_id])

      raise ActionController::RoutingError.new('Not Found') if @theme.nil?
    end

    def set_collection
      @collection = Collection.find_by_real_id(params[:real_id])

      raise ActionController::RoutingError.new('Not Found') if @collection.nil?
    end

    def collection_params
      params.require(:collection).permit(:name, :cards_attributes => [:id, :name, :intro, :description, :replacement, :glossary])
    end
end
