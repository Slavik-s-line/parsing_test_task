require 'rubygems'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'https://minfin.com.ua/'

class MinfinParser
  include Capybara::DSL
  attr_accessor :answer_data

  def login
    find('.js-toggle-auth').click
    fill_in('Login', :with => 'slaviksline')
    fill_in('Password', :with => '123456789rd')
    find('button.mfm-auth--submit-btn:nth-child(7)').click
  end

  def navigate
    find('div.menu__item:nth-child(1) > a:nth-child(1)').click
    find('.nav > li:nth-child(4) > a:nth-child(1)').click
  end

  def search_data
    self.answer_data = {}
    elems = all('div.sc-1x32wa2-0:nth-child(n) > table:nth-child(1) > tbody:nth-child(2) > tr:nth-child(n)').to_a
    elems.each do |elem|
      currency = elem.find('td:nth-child(2) > a:nth-child(1)').text
      name = elem.find('td:nth-child(3)').text
      rate = elem.find('td:nth-child(4) > div:nth-child(1)').text.split()[0]
      self.answer_data[currency] = {'name': name, 'rate': rate}
    end
  end

  def save_data
    File.open('answer.json','w') do |f|
      f.write(self.answer_data.to_json)
    end
  end

  def main_parser
    # open site
    visit('/')
    # login
    login
    # navigate to desired page
    navigate
    # search needed data
    search_data
    # save data to json file
    save_data
  end
end

# uncoment next lines if you run without rspec
# t = MinfinParser.new
# t.main_parser
