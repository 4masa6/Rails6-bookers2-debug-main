class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, presence: true

  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  def follow(other_user)
    following_relationships.create(following_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def self.search(keyword, search_type)
    case search_type
      when '完全一致' then
        where(['name Like ?', "#{keyword}"])
      when '前方一致' then
        where(['name Like ?', "#{keyword}%"])
      when '後方一致' then
        where(['name Like ?', "%#{keyword}"])
      when '部分一致' then
        where(['name Like ?', "%#{keyword}%"])
    end
  end

end
