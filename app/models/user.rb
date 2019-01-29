class User < ApplicationRecord
  devise :rememberable, :trackable, :omniauthable, :omniauth_providers => [:bungie]

  has_and_belongs_to_many :roles, :join_table => :user_roles
  has_and_belongs_to_many :cards, :join_table => :user_cards

  def self.from_omniauth(auth)
    where(:uid => auth.uid).first_or_create do |user|
      user.membership_id = auth.info.membership_id
      user.membership_type = auth.info.membership_type
      user.display_name = auth.info.display_name
    end
  end

  def role?(role)
    !roles.find_by_slug(role.to_s).nil?
  end
  def card_viewed?(card_id)
    !cards.find(card_id).nil?
  end

  def to_param
    display_name
  end

  # Get wrapperr for working with API
  #
  # @return [BungieClient::Wrappers::User]
  def guardian
    return @guardian unless @guardian.nil?

    client = RailsClient.new(
      :ttl => 24.hours,
      :prefix => "guardian.#{uid}."
    )

    @guardian = BungieClient::Wrappers::User.new(
      :client => client,
      :membership_type => membership_type,
      :display_name => display_name,
      :destiny_membership_id => membership_id
    )
  rescue
    nil
  end

  # Get real ids for guardian's opened cards
  #
  # @return [Array]
  def cards_opened_ids
    return @cards_ids unless @cards_ids.nil?

    @cards_ids = guardian.get_grimoire_by_membership&.data&.cardCollection || []

    @cards_ids = @cards_ids.map do |card|
      card.cardId.to_i
    end
  end

  # Get association with opened cards
  def cards_opened
    ids = cards_opened_ids

    if ids.nil?
      Card.none
    else
      Card.where(:real_id => cards_opened_ids)
    end
  end

  # Get association with unopened (closed) cards
  def cards_closed
    ids = cards_opened_ids

    if ids.nil?
      Card.all
    else
      Card.where.not(:real_id => cards_opened_ids)
    end
  end

  def card_opened?(card)
    cards_opened_ids.include? card.real_id.to_i
  end

  def card_readed?(card)
    cards.include? card
  end

  def avatar
    return @avatar unless @avatar.nil?

    @avatar = "https://bungie.net#{guardian.get_bungie_account&.bungieNetUser&.profilePicturePath}"
  end
end
