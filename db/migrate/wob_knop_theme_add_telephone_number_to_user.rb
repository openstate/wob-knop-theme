# -*- encoding : utf-8 -*-
class WobKnopThemeAddTelephoneNumberToUser < ActiveRecord::Migration[8.0]
  def self.up
    add_column :users, :telephone_number, :string
  end

  def self.down
    remove_column :users, :telephone_number
  end
end