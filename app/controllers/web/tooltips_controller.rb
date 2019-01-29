class Web::TooltipsController < Web::ApplicationController
  before_action :set_tooltip, :except => %w(index create)
  before_action :authenticate_user!

  def index
    @tooltips = Tooltip.all.order(:slug => :asc)

    respond_to do |format|
      format.json {
        render :json => @tooltips
      }
    end
  end

  def show
    respond_to do |format|
      format.json {
        render :json => @tooltip
      }
    end
  end

  def create
    @tooltip = Tooltip.new(tooltip_params)

    @tooltip.save

    respond_to do |format|
      format.json do
        render :json => @tooltip, :meta => {
          :status => (@tooltip.errors.any? ? 'Fail' : 'Success'),
          :errors => @tooltip.errors.messages
        }
      end
    end
  end

  def update
    @tooltip.update tooltip_params

    respond_to do |format|
      format.json do
        render :json => @tooltip, :meta => {
          :status => (@tooltip.errors.any? ? 'Fail' : 'Success'),
          :errors => @tooltip.errors.messages
        }
      end
    end
  end

  def destroy
    @tooltip.destroy

    respond_to do |format|
      format.json do
        render :json => @tooltip, :meta => {
          :status => (@tooltip.persisted? ? 'Fail' : 'Success'),
          :errors => []
        }
      end
    end
  end

  protected

    def set_tooltip
      @tooltip = Tooltip.find(params[:id])

      raise ActionController::RoutingError.new('Not Found') if @tooltip.nil?
    end

    def tooltip_params
      params.require(:tooltip).permit(:slug, :body, :replacement)
    end
end
