class Board < ActiveRecord::Base
  belongs_to :user
  has_many :pinnings
  has_many :board_pinners
  has_many :pins, through: :pinnings
  validates_presence_of :name
  accepts_nested_attributes_for :board_pinners
end
