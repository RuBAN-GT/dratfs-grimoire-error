module ApplicationHelper
  # Get target assets for controller & actions
  def target_assets
    output = []

    controller = params[:controller].split('/').last

    if File.exist?("#{Rails.root}/app/assets/stylesheets/web/specific/#{controller}.css.sass")
      output << stylesheet_link_tag("web/specific/#{controller}")
    end
    if File.exist?("#{Rails.root}/app/assets/stylesheets/web/specific/#{controller}/#{params[:action]}.css.sass")
      output << stylesheet_link_tag("web/specific/#{controller}/#{params[:action]}")
    end

    if File.exist?("#{Rails.root}/app/assets/javascripts/web/specific/#{controller}.js.coffee")
      output << javascript_include_tag("web/specific/#{controller}", 'data-turbolinks-eval' => 'always')
    end
    if File.exist?("#{Rails.root}/app/assets/javascripts/web/specific/#{controller}/#{params[:action]}.js.coffee")
      output << javascript_include_tag("web/specific/#{controller}/#{params[:action]}")
    end

    output.join("\n").html_safe
  end

  # Get icon
  def icon(name)
    content_tag :i, nil, :class => "icon #{name}"
  end

  # Get classes with controller names
  def target_classes
    controller = params[:controller].split('/').last

    "section_#{controller} section_#{controller}_#{params[:action]}"
  end

  # Get all flash messages
  def flash_all
    messages = []

    flash.each do |type, text|
      message = content_tag :div, :class => "message #{type}" do
        content_tag(:i, nil, :class => 'icon close') +
        content_tag(:div, text, :class => :content)
      end

      messages << message
    end

    content_tag :div, messages.join("\n").html_safe, :class => 'ui flash container'
  end
end
