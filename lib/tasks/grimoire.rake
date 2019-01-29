namespace :grimoire do
  desc "Parse grimoire to database"
  task :parse => :environment do
    client = BungieClient::Wrappers::Default.new(
      :client => RailsClient.new(
        :api_key => Rails.configuration.x.bungie_api_key,
        :ttl => 1.hour,
        :prefix => 'parser'
      )
    )

    grimoire = client.get_grimoire_definition

    if grimoire.nil? || !grimoire.key?('themeCollection')
      p 'Wrong grimoire'
    else
      p 'Grimoire is loaded. Start parsing...'

      I18n.locale = :en

      grimoire.themeCollection.each do |theme|
        theme_obj = Theme.find_or_initialize_by(:real_id => theme.themeId)
        theme_obj.name = theme.themeName
        theme_obj.save

        if theme_obj.full_picture.file.nil? || theme_obj.mini_picture.file.nil?
          theme_obj.remote_full_picture_url = "https://bungie.net/#{theme.highResolution.image.sheetPath}"

          sleep 0.1

          theme_obj.remote_mini_picture_url = "https://bungie.net/#{theme.highResolution.smallImage.sheetPath}"
          theme_obj.mini_picture.crop(
            theme.highResolution.smallImage.rect.x,
            theme.highResolution.smallImage.rect.y,
            theme.highResolution.smallImage.rect.width,
            theme.highResolution.smallImage.rect.height
          )

          theme_obj.save
        end

        if theme_obj.persisted?
          p "Theme with id: #{theme_obj.real_id} was created."
        else
          raise "Can't add the theme with id #{theme_obj.real_id}: #{theme_obj.errors.messages}"
        end

        theme.pageCollection.each do |collection|
          collection_obj = Collection.find_or_initialize_by(
            :real_id => collection.pageId,
            :theme => theme_obj
          )
          collection_obj.name = collection.pageName
          collection_obj.save

          if collection_obj.full_picture.file.nil? || collection_obj.mini_picture.file.nil?
            collection_obj.remote_full_picture_url = "https://bungie.net/#{collection.highResolution.image.sheetPath}"

            sleep 0.1

            collection_obj.remote_mini_picture_url = "https://bungie.net/#{collection.highResolution.smallImage.sheetPath}"
            collection_obj.mini_picture.crop(
              collection.highResolution.smallImage.rect.x,
              collection.highResolution.smallImage.rect.y,
              collection.highResolution.smallImage.rect.width,
              collection.highResolution.smallImage.rect.height
            )

            collection_obj.save
          end

          if collection_obj.persisted?
            p "Collection with id: #{collection_obj.real_id} was created."
          else
            raise "Can't add the collection with id #{collection_obj.real_id}: #{collection_obj.errors.messages}"
          end

          collection.cardCollection.each do |card|
            card_obj = Card.find_or_initialize_by(
              :real_id => card.cardId,
              :collection => collection_obj
            )
            card_obj.name = card.cardName
            card_obj.intro = card.cardIntro
            card_obj.description = card.cardDescription
            card_obj.save

            if card_obj.full_picture.file.nil? || card_obj.mini_picture.file.nil?
              card_obj.remote_full_picture_url = "https://bungie.net/#{card.highResolution.image.sheetPath}"

              sleep 0.1

              card_obj.remote_mini_picture_url = "https://bungie.net/#{card.highResolution.smallImage.sheetPath}"
              card_obj.mini_picture.crop(
                card.highResolution.smallImage.rect.x,
                card.highResolution.smallImage.rect.y,
                card.highResolution.smallImage.rect.width,
                card.highResolution.smallImage.rect.height
              )

              card_obj.save
            end

            if card_obj.persisted?
              p "Card with id: #{card_obj.real_id} was created."
            else
              raise "Can't add the card with id #{card_obj.real_id}: #{card_obj.errors.messages}"
            end
          end unless collection.cardCollection.nil?
        end unless theme.pageCollection.nil?
      end
    end
  end
end
