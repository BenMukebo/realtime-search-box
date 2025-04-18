# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'test article validations' do
    it 'should be valid with title and content' do
      article = Article.new(title: 'Test', content: 'Some content')
      expect(article).to be_valid
    end

    it 'should be invalid without a title' do
      article = Article.new(title: nil, content: 'Some content')
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'should be invalid without content' do
      article = Article.new(title: 'Test', content: nil)
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end
  end

  describe '.search_by_title' do
    it 'returns only articles matching the query (case-insensitive)' do
      a1 = Article.create!(title: 'Ruby on Rails', content: 'The OOP...')
      a2 = Article.create!(title: 'Python', content: 'As programing...')
      expect(Article.search_by_title('ruby')).to include(a1)
      expect(Article.search_by_title('python')).to include(a2)
      expect(Article.search_by_title('rails')).to include(a1)
      expect(Article.search_by_title('java')).to be_empty
    end

    it 'returns empty relation if query is blank' do
      expect(Article.search_by_title(nil)).to eq(Article.none)
      expect(Article.search_by_title('')).to eq(Article.none)
    end
  end

  describe '.recent' do
    it 'returns articles ordered by created_at descending' do
      a1 = Article.create!(title: 'A', content: '...', created_at: 1.day.ago)
      a2 = Article.create!(title: 'B', content: '...', created_at: Time.current)
      expect(Article.recent.first).to eq(a2)
    end
  end

  describe '.search_articles' do
    it 'creates a SearchArticle record' do
      user = User.create!(ip_address: '1.1.1.1')
      expect do
        Article.search_articles('test query', user, '1.1.1.1')
      end.to change { SearchArticle.count }.by(1)
    end

    it 'creates a user if user is nil' do
      expect do
        Article.search_articles('test query', nil, '2.2.2.2')
      end.to change { User.count }.by(1)
    end
  end
end
