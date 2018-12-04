class LoadDatasetToDbService
  attr_reader :file, :table_name, :columns

  def initialize(file, table_name, headers)
    @file = file
    @table_name = table_name
    @columns = headers
  end

  def load_dataset_to_db
    query = <<-SQL
      COPY #{table_name}(#{columns.join(',')}) 
      FROM \'#{file.path}\' DELIMITER ',' CSV HEADER;
    SQL
    ActiveRecord::Base.connection.execute(query)
  end
end