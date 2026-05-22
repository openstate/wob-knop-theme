# -*- encoding : utf-8 -*-
# This file is executed in the Rails evironment by the `rails-post-deploy`
# script

def table_exists?(table)
  ActiveRecord::Base.connection.table_exists?(table)
end

def column_exists?(table, column)
  if table_exists?(table)
    ActiveRecord::Base.connection.column_exists?(table, column)
  end
end

# Add the telephone_number field to the User model
unless column_exists?(:users, :telephone_number)
  file_path = '../db/migrate/wob_knop_theme_add_telephone_number_to_user'
  require File.expand_path file_path, __FILE__
  WobKnopThemeAddTelephoneNumberToUser.up
end