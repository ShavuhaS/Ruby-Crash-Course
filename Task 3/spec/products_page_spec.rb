require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'spec_helper'

RSpec.describe "Products Page Tests:" do
  include Capybara::DSL

  before(:each) do
    visit '/'
    fill_in 'Username', with: 'standard_user'
    fill_in 'Password', with: 'secret_sauce'
    click_button 'Login'
  end

  context "Cart" do
    before(:each) do
      items = all(:css, ".inventory_item")
      @first_n_items = items[...3]
      @first_n_items_names = @first_n_items.map do |item|
        item_name = item.find(:css, '.inventory_item_name')
        item_name.text
      end
    end

    after(:each) do
      visit '/cart.html'
      while page.has_button? 'Remove'
        remove_button = page.first('button', text: 'Remove')
        remove_button.click
      end
      click_button "Continue Shopping"
    end

    it "should display the correct number of items" do
      @first_n_items.each do |item|
        add_cart_button = item.find('button', text: 'Add to cart')
        add_cart_button.click
      end

      expect(page).to have_css('.shopping_cart_badge')
      cart_counter = find(:css, '.shopping_cart_badge')
      expect(cart_counter.text).to eq @first_n_items.size.to_s
    end

    it "should contain the products that have been added" do
      @first_n_items.each do |item|
        add_cart_button = item.find('button', text: 'Add to cart')
        add_cart_button.click
      end

      cart_link = first('.shopping_cart_link')
      cart_link.click
      @first_n_items_names.each do |name|
        expect(page).to have_text name
      end
    end
  end
end