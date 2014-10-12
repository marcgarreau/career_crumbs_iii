class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true

  validates :user, presence: true
#  validates :bookmarkable, presence: true, uniqueness: { scoped_to: :user }

  def self.includes?(id, type)
    where(bookmarkable_id: id, bookmarkable_type: type.to_s).any?
  end
end
