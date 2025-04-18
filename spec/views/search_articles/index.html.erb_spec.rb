# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'search_articles/index.html.erb', type: :view do
  let(:user) { User.create!(ip_address: '1.2.3.4') }
  let(:search) do
    SearchArticle.create!(query: 'Final search', user:, ip_address: user.ip_address, created_at: 2.minutes.ago)
  end

  before do
    assign(:user, user)
    assign(:user_searches, [search])
    render
  end

  it 'shows the analytics heading' do
    expect(rendered).to have_selector('h1', text: /Search Analytics/i)
    expect(rendered).to have_selector('h2', text: 'Recent Searches')
  end

  it 'shows the user IP address' do
    expect(rendered).to have_selector('span', text: /IP: 1\.2\.3\.4/)
  end

  it 'shows recent searches' do
    expect(rendered).to have_text('Final search')
  end

  it 'shows the "Back to Search" link' do
    expect(rendered).to have_link('Back to Search', href: '/')
  end
end
