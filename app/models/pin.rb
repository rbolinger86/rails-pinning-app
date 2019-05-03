class Pin < ActiveRecord::Base
  validates_presence_of :title, :url, :slug, :text
  validates_uniqueness_of :slug
  belongs_to :category
  has_one_attached :image
  belongs_to :user
  has_many :pinnings, dependent: :destroy
  has_many :users, through: :pinnings
  accepts_nested_attributes_for :pinnings
  after_commit :add_default_image, on: [:create, :update]
end

def add_default_image
  if self.image.blank?
    self.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.jpg")), filename: 'default.jpg' , content_type: "image/jpg")
  end
end
