require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'spec_helper'

RSpec.describe "Login Page Tests:" do
  include Capybara::DSL

  before(:each) do
    visit '/'
  end

  context "Login with normal accounts" do
    usernames = ['standard_user', 'visual_user']
    password = 'secret_sauce'
    usernames.each do |username|
      it "should be successful" do
        fill_in 'Username', with: username
        fill_in 'Password', with: password

        click_button 'Login'
        expect(page).to have_text "Products"
      end
    end
  end

  context "Login with locked accounts" do
    usernames = ['locked_out_user', 'error_user']
    password = 'secret_sauce'
    usernames.each do |username|
      it "should not be successful" do
        fill_in 'Username', with: username
        fill_in 'Password', with: password

        click_button 'Login'
        expect(page).to have_css ".error"
      end
    end
  end

  context "Login with wrong password" do
    usernames = ['unknown_user_1', 'unknown_user_2']
    passwords = ['1', '2']
    usernames.zip(passwords) do |username, password|
      it "should not be successful" do
        fill_in 'Username', with: username
        fill_in 'Password', with: password

        click_button 'Login'
        expect(page).to have_css ".error"
      end
    end
  end
end