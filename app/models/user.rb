class User < ApplicationRecord
  has_secure_password

  before_validation :normalize_attributes

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create

  scope :recent_first, -> { order(Arel.sql("last_activity_at DESC NULLS LAST, id DESC")) }

  private

  def normalize_attributes
    self.name = name.to_s.strip
    self.email = email.to_s.strip.downcase
  end
end
