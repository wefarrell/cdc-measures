class AddTablefuncExtension < ActiveRecord::Migration[5.1]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS tablefunc;'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS tablefunc;'
  end
end

