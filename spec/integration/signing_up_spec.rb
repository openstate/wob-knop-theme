# -*- encoding : utf-8 -*-
require_relative '../spec_helper'

describe 'Signing up' do
  def valid_message
    "Now check your email!"
  end

  def invalid_message
    "should be a Dutch number consisting of 10 digits"
  end

  def sign_me_up(telephone_number)
    visit signin_path

    within '#signup' do
      fill_in 'Your e-mail', :with => 'test@localhost'
      fill_in 'Your name', :with => 'rspec'
      fill_in 'Password', :with => 'abcdef65432199'
      fill_in 'Confirm password:', :with => 'abcdef65432199'
      fill_in 'Telephone number', :with => telephone_number
      click_button 'Sign up'
    end
  end

  it "allows to sign up without a telephone number" do
    sign_me_up('')

    expect(page).to have_content(valid_message)
    expect(page).not_to have_content(invalid_message)

    visit confirm_url(email_token: PostRedirect.last.email_token)

    visit change_telephone_number_path
    expect(find_field('Telephone number:').value).to eq('')
  end

  # moet een Nederlands telefoonnummer bevatten bestaande uit 10 getallen

  it "allows to sign up with a valid telephone number" do
    sign_me_up('06 1234 5678')

    expect(page).to have_content(valid_message)
    expect(page).not_to have_content(invalid_message)

    visit confirm_url(email_token: PostRedirect.last.email_token)

    visit change_telephone_number_path
    expect(find_field('Telephone number:').value).to eq('+31612345678')
  end

  it "validates the telephone number" do
    sign_me_up('06 1234')

    expect(page).to have_content(invalid_message)
    expect(page).not_to have_content(valid_message)
  end
end
