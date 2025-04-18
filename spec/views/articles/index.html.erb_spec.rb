require 'rails_helper'

RSpec.describe 'articles/index.html.erb', type: :view do
  before do
    assign(:articles, [
      Article.new(title: 'Ruby', content: 'Ruby content', created_at: Time.current),
      Article.new(title: 'Rails', content: 'Rails content', created_at: Time.current)
    ])
    render
  end

  it 'shows the welcome heading' do
    expect(rendered).to have_selector('p', text: "Explore our collection of articles with real-time search and colorful insights.")
  end

  it 'shows the search bar' do
    expect(rendered).to have_selector('input[type="text"][name="query"]')
  end

  it 'shows the trending categories' do
    expect(rendered).to have_text('Search categories:')
    expect(rendered).to have_text('Health & Wellness')
    expect(rendered).to have_text('Artificial Intelligence')
  end

  it 'renders the list of articles' do
    expect(rendered).to match(/Ruby/)
    expect(rendered).to match(/Rails/)
  end

  it 'shows the "Google Search" button' do
    expect(rendered).to have_selector('button', text: 'Google Search')
  end
end
