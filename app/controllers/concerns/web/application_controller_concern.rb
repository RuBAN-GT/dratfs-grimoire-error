module Web::ApplicationControllerConcern
  extend ActiveSupport::Concern

  included do
    layout 'web/layouts/application'

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end

    before_action :default_meta_tags
    before_action :set_editor_type
    before_action :set_translate_type

    helper_method :serializer_options
  end

  def new_session_path(scope)
    new_user_session_path
  end

  def serializer_options(options = {})
    {:cookies => cookies, :user => current_user}.merge options
  end

  protected

    def default_meta_tags
      set_meta_tags :title => I18n.t('templates.grimoire')
    end

    def set_editor_type
      if params[:editor] == 'enable'
        cookies[:editor] = {
          :value => 'enable',
          :expires => 2.weeks.from_now
        }
      elsif params[:editor] == 'disable'
        cookies.delete :editor
      end
    end

    def set_translate_type
      if params[:replacement] == 'off'
        cookies[:replacement] = {
          :value => false,
          :expires => 2.weeks.from_now
        }
      elsif params[:replacement] == 'on'
        cookies.delete :replacement
      end

      if params[:glossary] == 'off'
        cookies[:glossary] = {
          :value => false,
          :expires => 2.weeks.from_now
        }
      elsif params[:glossary] == 'on'
        cookies.delete :glossary
      end
    end
end
