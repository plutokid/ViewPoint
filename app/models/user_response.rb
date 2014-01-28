class UserResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  
  validates :user_id, presence: true
  validates :location_id, presence: true
  validates :comments, presence: true, length: { maximum: 2000 }

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
    thumbnail: '200x200>'
  }

  validates_attachment_presence :image unless Rails.env.development?
  validates_attachment_size :image, :less_than => 10.megabytes unless Rails.env.development?
end
