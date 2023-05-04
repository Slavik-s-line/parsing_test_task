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

describe 'parser main test case' do
  it 'should be present notification icon for current user' do
    visit '/'
    sleep(1)  # fix problem with not showing button "Вхід"
    app.login
    expect(page).to have_css('div.mfz-ud-notification:nth-child(2)')
  end

  it 'should redirect to desired page' do
    app.navigate
    expect(page).to have_css('li.active > a:nth-child(1)', text: 'НБУ')
  end

  it 'should find searching data' do
    app.search_data
    expect(app.answer_data).not_to be_empty
  end

  it 'should find searching data' do
    app.save_data
    expect(File.exist?('./answer.json')).to be true
  end
end
