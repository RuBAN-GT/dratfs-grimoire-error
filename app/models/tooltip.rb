class Tooltip < ApplicationRecord
  validates :slug,
    :presence => true,
    :uniqueness => {
      :scope => :replacement
    }, 
    :length => {
      :maximum => 250
    }
  validates :body, :presence => true, :length => {
    :maximum => 250
  }
end
