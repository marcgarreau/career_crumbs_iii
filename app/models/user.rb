class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable, :trackable

  has_many :jobs
  has_many :words
  has_many :meetups
  has_many :bookmarks

  validates :encrypted_password, presence: true, allow_blank: true

  def password_required?
    super && provider.blank?
  end
end
