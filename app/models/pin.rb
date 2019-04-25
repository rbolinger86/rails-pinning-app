class Pin < ActiveRecord::Base
  validates_presence_of :title, :url, :slug, :text
  validates_uniqueness_of :slug
  belongs_to :category
  has_attached_file :image, styles: { medium: "300x300>", thumb: "60x60>" }, default_url: "http://placebear.com/300/300"
  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
  belongs_to :user
  has_many :pinnings, dependent: :destroy
  has_many :users, through: :pinnings
  accepts_nested_attributes_for :pinnings
end
