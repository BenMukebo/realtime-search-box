# frozen_string_literal: true

class CreateSearchArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :search_articles do |t|
      t.string :query
      t.string :ip_address
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :search_articles, :query
  end
end
