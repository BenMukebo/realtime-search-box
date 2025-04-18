# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'testing user validations' do
    it 'is valid with a unique ip_address' do
      user = User.new(ip_address: '1.2.3.4')
      expect(user).to be_valid
    end

    it 'should be invalid without an ip_address' do
      user = User.new(ip_address: nil)
      expect(user).not_to be_valid
      expect(user.errors[:ip_address]).to include("can't be blank")
    end

    it 'should be invalid with a duplicate ip_address' do
      User.create!(ip_address: '1.2.3.4')
      user2 = User.new(ip_address: '1.2.3.4')
      expect(user2).not_to be_valid
      expect(user2.errors[:ip_address]).to include('has already been taken')
    end
  end

  describe '.find_or_create_by_ip' do
    it 'finds an existing user by ip_address' do
      user = User.create!(ip_address: '5.6.7.8')
      found = User.find_or_create_by_ip('5.6.7.8')
      expect(found).to eq(user)
    end

    it 'creates a new user if ip_address does not exist' do
      expect do
        User.find_or_create_by_ip('9.9.9.9')
      end.to change { User.count }.by(1)
    end
  end
end
