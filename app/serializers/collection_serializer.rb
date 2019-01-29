class CollectionSerializer < ApplicationSerializer
  attributes :id,
    :real_id,
    :name,
    :full_picture_url,
    :mini_picture_url,
    :link,
    :theme,
    :cards

  def link
    theme_collection_path(I18n.locale, object.theme, object)
  end

  def theme
    object.theme.to_serializer instance_options[:theme] || {}
  end

  def cards
    object.cards.to_serializer instance_options[:cards] || {}
  end
end
