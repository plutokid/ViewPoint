class User < ActiveRecord::Base
  has_many :user_responses, dependent: :destroy
  has_many :locations, through: :user_responses #completed locations
  has_many :locations, dependent: :destroy #created locations
  has_many :pending_locations, dependent: :destroy
  has_many :locations, through: :pending_locations #pending locations

	before_create :create_remember_token
  before_save { self.username = username.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence:   true,
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  VALID_LOC_REGEX = /\A[0-9- ,.]+\z/
  validates :gps_location, format: { with: VALID_LOC_REGEX }, presence: true, length: { maximum: 255 }
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def to_param
    username
  end

  def add_to_pending!(location)
    PendingLocation.create!(location_id: location.id)
  end

  def remove_from_pending!(location)
    PendingLocation.find_by(location_id: location.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end