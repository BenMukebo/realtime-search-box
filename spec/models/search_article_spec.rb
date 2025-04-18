# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchArticle, type: :model do
  let(:user) { User.create!(ip_address: '1.2.3.4') }

  describe 'test search article validations' do
    it 'is valid with valid attributes' do
      expect(SearchArticle.new(query: 'Test', user:, ip_address: user.ip_address)).to be_valid
    end

    it 'is invalid without a query' do
      expect(SearchArticle.new(query: nil, user:, ip_address: user.ip_address)).not_to be_valid
    end

    it 'is invalid without a user' do
      expect(SearchArticle.new(query: 'Test', user: nil, ip_address: '1.2.3.4')).not_to be_valid
    end
  end


  describe '.completed_searches_for_user' do
    it 'returns the 10 most recent searches for a user' do
      12.times do |i|
        SearchArticle.create!(query: "Query #{i}", user:, ip_address: user.ip_address, created_at: i.minutes.ago)
      end
      results = SearchArticle.completed_searches_for_user(user.id)
      expect(results.count).to eq(10)
      expect(results.first.query).to eq('Query 0')
      expect(results.last.query).to eq('Query 9')
    end

    it 'returns only the most complete queries for a user' do
      queries = [
        'Hello',
        'Hello world',
        'Hello world how are you?',
        'Another',
        'Another test'
      ]
      queries.each { |q| SearchArticle.create!(query: q, user:, ip_address: user.ip_address) }

      completed = SearchArticle.completed_searches_for_user(user.id).map(&:query)
      expect(completed).to include('Hello world how are you?', 'Another test')
    end
  end
end
