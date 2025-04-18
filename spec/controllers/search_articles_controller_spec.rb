# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchArticlesController, type: :controller do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  let(:user) { User.create!(ip_address: '5.6.7.8') }

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'does not assign @user_searches if current_user is nil' do
      allow(controller).to receive(:current_user).and_return(nil)
      get :index
      expect(assigns(:user_searches)).to be_nil
    end

    it 'assigns @user_searches if current_user is present' do
      allow(controller).to receive(:current_user).and_return(user)
      get :index
      expect(assigns(:user_searches)).to eq(SearchArticle.completed_searches_for_user(user.id))
    end
  end

  describe 'POST #record' do
    it 'enqueues a RecordSearchJob' do
      expect do
        post :record, params: { query: 'Test search' }
      end.to have_enqueued_job(RecordSearchJob)
      expect(response).to have_http_status(:ok)
    end

    it 'does not enqueue job for blank query' do
      expect do
        post :record, params: { query: '' }
      end.not_to have_enqueued_job(RecordSearchJob)
      expect(response).to have_http_status(:ok)
    end
  end
end
