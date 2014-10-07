class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :trackable
  has_many :jobs
  has_many :words

  validates :encrypted_password, presence: true, allow_blank: true

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider   = auth.provider
      user.uid        = auth.uid
      user.first_name = auth.info.first_name
      user.last_name  = auth.info.last_name
      user.email      = auth.info.email
      user.industry   = auth.extra.raw_info.industry
      user.pic_url    = auth.extra.raw_info.pictureUrl
      user.headline   = auth.extra.raw_info.headline
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end
end
