class Web::PagesController < Web::ApplicationController
  def home
    redirect_to "/#{I18n.locale || I18n.default_locale}"
  end

  def about
  end

  def search
    @results = Card.
      filter_name(params[:q]).
      order_name.
      page(params[:page]).per(15)

    respond_to do |format|
      format.json {
        render :json => @results,
          :fields => [
            :id,
            :real_id,
            :name,
            :mini_picture_url,
            :link,
            :theme,
            :collection,
            :opened
          ],
          :meta => {
            :limit_value => @results.limit_value,
            :current_page => @results.current_page,
            :total_pages => @results.total_pages,
            :prev_page => @results.prev_page,
            :next_page => @results.next_page
          },
          :cookies => cookies,
          :user => current_user,
          :theme => {:except => %w(collections)},
          :collection => {:except => %w(theme cards)}
      }
    end
  end
end
