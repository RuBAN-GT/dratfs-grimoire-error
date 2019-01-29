class Theme < ApplicationRecord
  has_many :collections, :dependent => :nullify

  accepts_nested_attributes_for :collections

  mount_uploader :full_picture, FullCardPictureUploader
  mount_uploader :mini_picture, MiniCardPictureUploader

  translates :name
  globalize_accessors :locales => [:en, :ru], :attributes => [:name]

  validates :real_id, :presence => true, :uniqueness => true
  validates :name, :presence => true

  def self.default_scope
    order(:real_id => :asc)
  end

  def to_param
    real_id
  end
end
