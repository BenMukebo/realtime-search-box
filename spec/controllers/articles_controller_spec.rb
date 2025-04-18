require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'GET #index' do
    let!(:article1) { Article.create!(title: 'Ruby', content: 'Ruby content') }
    let!(:article2) { Article.create!(title: 'Rails', content: 'Rails content') }

    it 'assigns @articles with recent articles if no search' do
      get :index
      expect(assigns(:articles)).to include(article1, article2)
      expect(response).to render_template(:index)
      expect(response).to be_successful
    end

    it 'assigns @articles with search results if query is present' do
      get :index, params: { query: 'Ruby' }
      expect(assigns(:articles)).to include(article1)
      expect(assigns(:articles)).not_to include(article2)
    end

    it 'responds to html format' do
      get :index, params: { query: 'Ruby' }, format: :html
      expect(response).to render_template(:index)
    end

    context 'when query param is not present' do
      before do
        15.times { |i| Article.create!(title: "Article #{i}", content: "Content #{i}") }
      end

      it 'assigns at most 10 articles' do
        get :index
        expect(assigns(:articles).size).to eq(10)
      end
    end
  end
end
