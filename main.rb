require 'rubygems'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'https://minfin.com.ua/'

class MinfinParser
  include Capybara::DSL
  attr_accessor :answer_data, :username, :password

  def initialize
    self.answer_data = {}
    self.username = 'slaviksline'
    self.password = '123456789rd'
  end

  def user_login
    find('div[title="Гость"]', text: 'ВХІД').click
    fill_in('Login', with: username)
    fill_in('Password', with: password)
    find('button', text: 'ВХІД').click
  end

  def user_signed_in?
    find("a[title=#{username}]").click
    return true if find('a', text: 'Вихід')
  end

  def navigate_to_nbu_currency_page
    click_link('Валюта')
    first('a', text: 'НБУ').click
  end

  def search_tables_with_nbu_currency
    currency_tables = page.all(:xpath,
      "//tr[contains(., 'Код') and contains(., 'Валюта') and contains(., 'Назва') and contains(., 'Курс')]")
  end

  def search_nbu_currency
    self.search_tables_with_nbu_currency.each do |table|
      header_names = table.all('th')
      all_currency_in_table = table.find(:xpath, '../../..').find('tbody').all('tr')
      all_currency_in_table.each do |specific_currency_row|
        specific_currency_columns = specific_currency_row.all('td')
        answer_data[specific_currency_columns[1].text] = {
          header_names[0].text() => specific_currency_columns[0].text,
          header_names[1].text() => specific_currency_columns[1].text, 
          header_names[3].text() => specific_currency_columns[3].text.split[0] 
        }
      end
    end
  end

  def save_nbu_currency_to_file
    File.open('answer.json', 'w') do |f|
      f.write(answer_data.to_json)
    end
  end
end

# uncoment next lines if you run without rspec
app = MinfinParser.new
app.visit('/')
app.user_login
app.user_signed_in?
app.navigate_to_nbu_currency_page
app.search_nbu_currency
app.save_nbu_currency_to_file
