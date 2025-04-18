# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordSearchJob, type: :job do
  let(:user) { User.create!(ip_address: '9.9.9.9') }

  subject(:perform_job) { described_class.perform_now(query, user_id, ip_address) }

  context 'when there is no previous search' do
    let(:query) { 'First query' }
    let(:user_id) { user.id }
    let(:ip_address) { user.ip_address }

    it 'creates a new SearchArticle record' do
      expect { perform_job }.to change { SearchArticle.count }.by(1)
      expect(SearchArticle.last.query).to eq('First query')
    end
  end

  context 'when last search is a prefix and query is longer' do
    let!(:last_search) { SearchArticle.create!(query: 'Hel', user: user, ip_address: user.ip_address) }
    let(:query) { 'Hello' }
    let(:user_id) { user.id }
    let(:ip_address) { user.ip_address }

    it 'updates the last SearchArticle record' do
      expect { perform_job }.not_to change { SearchArticle.count }
      expect(last_search.reload.query).to eq('Hello')
    end
  end

  context 'when last search is not a prefix of the new query' do
    let!(:last_search) { SearchArticle.create!(query: 'Goodbye', user: user, ip_address: user.ip_address) }
    let(:query) { 'Hello' }
    let(:user_id) { user.id }
    let(:ip_address) { user.ip_address }

    it 'creates a new SearchArticle record' do
      expect { perform_job }.to change { SearchArticle.count }.by(1)
      expect(SearchArticle.last.query).to eq('Hello')
    end
  end

  context 'when user does not exist' do
    let(:query) { 'New user query' }
    let(:user_id) { nil }
    let(:ip_address) { '8.8.8.8' }

    it 'creates a new user and SearchArticle' do
      expect { perform_job }.to change { User.count }.by(1)
      expect(SearchArticle.last.query).to eq('New user query')
      expect(SearchArticle.last.user.ip_address).to eq('8.8.8.8')
    end
  end

  context 'when query is a deletion (shorter than last)' do
    let!(:last_search) { SearchArticle.create!(query: 'Hello world', user: user, ip_address: user.ip_address) }
    let(:query) { 'Hello' }
    let(:user_id) { user.id }
    let(:ip_address) { user.ip_address }

    it 'does not create or update any SearchArticle' do
      expect { perform_job }.not_to change { SearchArticle.count }
      expect(last_search.reload.query).to eq('Hello world')
    end
  end
end
