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
    sleep(1)
    first('a', text: 'НБУ').click
  end

  def search_nbu_currency_by_column(title)
    if page.first(:xpath, "//thead/tr/th[contains(.,'#{title}')]")
      path = "//tbody/tr/td[(count(//thead/tr/th[contains(.,'#{title}')]/preceding-sibling::*) div (count(//thead/tr[contains(.,'#{title}')])))+1]"
      page.all(:xpath, path)
    end
  end

  def collect_nbu_currency_in_hash
    currency = search_nbu_currency_by_column('Код').map(&:text)
    currency_value = search_nbu_currency_by_column('Курс').map{ |value| value.text.split[0] }
    self.answer_data = Hash[currency.zip(currency_value)]
  end

  def save_nbu_currency_to_file
    File.open('answer.json', 'w') do |f|
      f.write(self.answer_data.to_json)
    end
  end
end

# uncoment next lines if you run without rspec
app = MinfinParser.new
app.visit('/')
app.user_login
app.user_signed_in?
app.navigate_to_nbu_currency_page
app.collect_nbu_currency_in_hash
app.save_nbu_currency_to_file
