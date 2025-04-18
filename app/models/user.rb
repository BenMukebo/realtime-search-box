# frozen_string_literal: true

class User < ApplicationRecord
  has_many :search_articles, dependent: :destroy

  validates :ip_address, presence: true, uniqueness: true

  def self.find_or_create_by_ip(ip_address)
    where(ip_address:).first_or_create do |user|
      user.user_name = "User_#{SecureRandom.hex(4)}"
    end
  end
end
