class CardSerializer < ApplicationSerializer
  attributes :id,
    :real_id,
    :original_name,
    :name,
    :original_intro,
    :intro,
    :original_description,
    :description,
    :full_picture_url,
    :mini_picture_url,
    :link,
    :replacement,
    :glossary,
    :readed,
    :opened,
    :theme,
    :collection,
    :untranslated_name,
    :untranslated_intro,
    :untranslated_description

  def link
    theme_collection_card_path(I18n.locale, object.theme, object.collection, object)
  end

  def original_name
    object.name
  end

  def name
    return object.name if I18n.locale == :en

    if translate_state.replacement? && object.replacement
      TranslateState.replacement object.name
    else
      object.name
    end
  end

  def untranslated_name
    object.name_en
  end

  def original_intro
    object.intro
  end

  def intro
    return '' if object.intro.nil?
    return object.intro if I18n.locale == :en

    intro = object.intro

    intro = TranslateState.replacement intro if translate_state.replacement? && object.replacement

    intro = TranslateState.glossary intro if translate_state.glossary? && object.glossary

    intro
  end

  def untranslated_intro
    object.intro_en
  end

  def original_description
    object.description
  end

  def description
    return '' if object.description.nil?
    return object.description if I18n.locale == :en

    description = object.description

    description = TranslateState.replacement description if translate_state.replacement? && object.replacement

    description = TranslateState.glossary description if translate_state.glossary? && object.glossary

    description
  end

  def untranslated_description
    object.description_en
  end

  def readed
    user.nil? ? false : user.card_readed?(object)
  end

  def opened
    user.nil? ? true : user.card_opened?(object)
  end

  def theme
    object.theme.to_serializer instance_options[:theme] || {}
  end

  def collection
    object.collection.to_serializer instance_options[:collection] || {}
  end

  protected

    def user
      instance_options[:user] || nil
    end

    def translate_state
      return @translate_state unless @translate_state.nil?

      @translate_state = TranslateState.new(instance_options[:cookies] || {})
    end
end
