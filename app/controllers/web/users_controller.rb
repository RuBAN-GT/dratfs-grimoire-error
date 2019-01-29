class Web::UsersController < Web::ApplicationController
  # before_action :authenticate_user!, :only => %w(edit update)
  before_action :set_user, :only => %w(show)
  # before_action :current_user_only, :only => %w(edit update)

  def index
    @users = User.page
  end

  def show
    @cards = @user.cards_opened.page(params[:page]).per(40)
  end

  protected

    def set_user
      @user = User.find_by_display_name(params[:display_name])

      raise ActionController::RoutingError.new('Not Found') if @user.nil?
    end

    def current_user_only
      raise ActionController::RoutingError.new('Not Found') unless @user.id == current_user.id
    end
end
