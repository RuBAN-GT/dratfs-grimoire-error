class ThemeSerializer < ApplicationSerializer
  attributes :id,
    :real_id,
    :name,
    :full_picture_url,
    :mini_picture_url,
    :link,
    :collections

  def link
    theme_path(I18n.locale, object)
  end

  def collections
    object.collections.to_serializer(instance_options[:collections] || {})
  end
end
