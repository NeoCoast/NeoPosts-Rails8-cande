class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :image

  validates :nickname,
            uniqueness: { case_sensitive: false }

  validates_presence_of :nickname, :email, :first_name, :last_name, :birthday

  validates :email,
            format: { with: /\A[^@\s]+@[^@\s]+\.[a-z]+\z/i,
                      message: 'Email needs to include a "@" and ".com"' },
            if: -> { email.present? }

  validates :nickname, format: { without: /\./, message: 'should not include a period (".")' }

  validates :birthday, comparison: { less_than: Date.current, message: "birthday cannot be in the future" },
                       if: -> { birthday.present? }

  validate :image_file_type, if: -> { image.present? }

  before_save :capitalize_attributes

  private

  def capitalize_attributes
    self.first_name = first_name.capitalize if first_name.present?
    self.last_name = last_name.capitalize if last_name.present?
  end

  def image_file_type
    return unless image.attached?
    return if [ "image/jpeg", "image/png", "image/gif", "image/webp" ].include?(image.content_type)
    image.purge
    errors.add(:image, "wrong type of file")
  end
end
