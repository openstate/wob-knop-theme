# -*- encoding : utf-8 -*-
require_relative '../spec_helper'

describe 'Managing telephone number' do
  let(:user) { FactoryBot.create(:user, :telephone_number => '+31612345678') }

  it 'allows a user to change their telephone number' do
    using_session(login(user)) do
      visit change_telephone_number_path
      fill_in "Telephone number:", with: "0644448888"
      click_button "Save"
      expect(page).to have_content("You have changed your telephone number used on #{AlaveteliConfiguration.site_name}")

      visit change_telephone_number_path
      expect(find_field('Telephone number:').value).to eq('+31644448888')
    end
  end

  it 'allows users to remove telephone number' do
    using_session(login(user)) do
      visit change_telephone_number_path
      fill_in "Telephone number:", with: ""
      click_button "Save"
      expect(page).to have_content("You have removed your telephone number used on #{AlaveteliConfiguration.site_name}")

      visit change_telephone_number_path
      expect(find_field('Telephone number:').value).to eq('')
    end
  end

end