class Card < ApplicationRecord
  belongs_to :collection
  has_and_belongs_to_many :users, :join_table => :user_cards

  mount_uploader :full_picture, FullCardPictureUploader
  mount_uploader :mini_picture, MiniCardPictureUploader

  translates :name, :intro, :description
  globalize_accessors :locales => [:en, :ru], :attributes => [:name, :intro, :description]

  paginates_per 120

  validates :real_id, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :collection, :presence => true

  def self.order_id
    order(:id => :asc)
  end
  def self.order_real_id
    order(:real_id => :asc)
  end
  def self.order_name
    with_translations(I18n.locale).order(:name => :asc)
  end
  def self.filter_content(content)
    content = "%#{content.to_s.downcase}%"

    where 'lower(name) LIKE ? OR lower(intro) LIKE ? OR lower(description) LIKE ?', content, content, content
  end
  def self.filter_name(name)
    where 'lower(name) LIKE ?', "%#{name.to_s.downcase}%"
  end

  def theme
    collection.theme
  end

  def to_param
    real_id
  end
end
