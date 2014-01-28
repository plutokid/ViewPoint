class Location < ActiveRecord::Base
  belongs_to :user #location belongs to creator
  has_many :user_responses, dependent: :destroy
  has_many :users, through: :user_responses #completed users
  has_many :pending_locations, dependent: :destroy
  has_many :users, through: :pending_locations #users that have this location on pending list

  validates :title, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 2000 }
  VALID_LOC_REGEX = /\A[0-9- ,.]+\z/
  validates :gps_location, format: { with: VALID_LOC_REGEX }, presence: true, length: { maximum: 255 }
  validates :hints, presence: true, length: { maximum: 2000 }
  validates :suggestions, presence: true, length: { maximum: 2000 }

  # This method associates the attribute ":image" with a file attachment
  has_attached_file :image,
  :storage => :s3,
  :bucket => 'view_point',
  :s3_credentials => {
      :access_key_id => 'AKIAJOIKQQSEG3OIRUDQ',
      :secret_access_key => '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'
  },
  :styles => {
    preview: '800x800>',
    thumbnail: '400x400>'
  }

  validates_attachment_presence :image unless Rails.env.development?
  validates_attachment_size :image, :less_than => 10.megabytes unless Rails.env.development?

end
