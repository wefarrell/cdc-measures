class BuildTableFromCsvService
  attr_reader :file, :table_name

  def initialize(file, table_name)
    @file = file
    @table_name = table_name
  end

  def load_header
    header = File.open(file){|f| f.readline}
    header.split(',').map{|column_name|
      column_name.strip().underscore()
    }
  end

  def create_table
    connection.execute("DROP TABLE IF EXISTS #{table_name}")
    columns = load_header
    table = table_name
    ActiveRecord::Migration.class_eval do
      create_table(table) do |t|
        columns.each do |column|
          t.string column
        end
      end
    end
  end

  def connection
    ActiveRecord::Base.connection
  end
end