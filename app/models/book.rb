class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search(keyword, search_type)
    case search_type
      when '完全一致' then
        where(['title Like ?', "#{keyword}"])
      when '前方一致' then
        where(['title Like ?', "#{keyword}%"])
      when '後方一致' then
        where(['title Like ?', "%#{keyword}"])
      when '部分一致' then
        where(['title Like ?', "%#{keyword}%"])
    end
  end

end
