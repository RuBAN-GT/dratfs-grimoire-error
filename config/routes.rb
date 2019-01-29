Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # web part
  scope :module => :web do
    root 'pages#home'

    resources :tooltips, :only => %w(index create update destroy)
    post :reports, :to => 'reports#create'

    devise_for :users, :path => '/guardians', :controllers => {
      :omniauth_callbacks => 'web/devise/omniauth_callbacks',
      :sessions => 'web/devise/sessions'
    }
    devise_scope :user do
      delete '/guardians/auth/sign_out',
        :to => 'devise/sessions#destroy',
        :as => :destroy_user_session
    end

    scope '/:locale', locale: /#{I18n.available_locales.join('|')}/ do
      root 'themes#index'

      resources :themes, :path => '/data', :only => %w(index show), :param => :real_id do
        resources :collections, :path => '/', :only => %w(update), :param => :real_id do
          resources :cards, :path => '/', :only => %w(index show), :param => :real_id do
            put :read, :to => 'cards#read'
          end
        end
      end

      get 'search', :to => 'pages#search'
      get :about, :to => 'pages#about'
    end
  end
end
