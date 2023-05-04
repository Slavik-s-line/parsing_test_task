require 'rspec'
require 'capybara'
require 'capybara/dsl'
require './main'

Capybara.default_driver = :selenium
Capybara.app_host = 'https://minfin.com.ua/'
RSpec.configure do |config|
  config.include Capybara::DSL
  config.raise_errors_for_deprecations!
end

app = MinfinParser.new

describe 'log in and search NBU currency data' do
  context 'user should sign in and see button "Вихід"' do
    it 'should return true' do
      visit('/')
      app.user_login
      expect(app.user_signed_in?).to be true
    end
  end

  context 'should redirect to NBU currency page' do
    it 'page has title "Курс валют НБУ"' do
      app.navigate_to_nbu_currency_page
      expect(page).to have_content('Курс валют НБУ')
    end
  end

  context 'should find tables with NBU currency' do
    it 'table must have 4 columns' do
      header_columns = app.search_tables_with_nbu_currency[0].all('th')
      expect(header_columns.size).to equal(4)
    end
  end

  context 'should find NBU currency data' do
    it 'must have "USD" key' do
      app.search_nbu_currency
      expect(app.answer_data.has_key?('USD')).to be true
    end
  end

  context 'should save NBU currency data in json file' do
    it 'json file present in root folder' do
      app.save_nbu_currency_to_file
      expect(File.exist?('./answer.json')).to be true
    end
  end
end
