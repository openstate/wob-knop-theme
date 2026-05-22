# -*- encoding : utf-8 -*-
# Uninstall hook code here

def table_exists?(table)
  ActiveRecord::Base.connection.table_exists?(table)
end

def column_exists?(table, column)
  if table_exists?(table)
    ActiveRecord::Base.connection.column_exists?(table, column)
  end
end

if ENV['REMOVE_MIGRATIONS']
  # Remove the telephone_number field from the User model
  if column_exists?(:users, :telephone_number)
    file_path = '../db/migrate/wob_knop_theme_add_telephone_number_to_user'
    require File.expand_path file_path, __FILE__
    WobKnopThemeAddTelephoneNumberToUser.down
  end
end