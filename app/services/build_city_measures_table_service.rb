class BuildCityMeasuresTableService
  attr_reader :source_table, :destination_table

  def initialize(source_table, destination_table)
    @source_table = source_table
    @destination_table = destination_table
  end

  def measure_columns
    query = 'SELECT DISTINCT short_question_text from cdc_dataset'
    connection.execute(query).pluck('short_question_text').map{ |question|
      question.parameterize.underscore
    }
  end

  def create_table
    connection.execute("DROP TABLE IF EXISTS #{destination_table}")
    column_definitions = measure_columns.map{|column| "#{column} FLOAT"}
    query = <<-SQL
    CREATE TABLE #{destination_table} AS (
      SELECT * FROM crosstab(
      'SELECT city_name AS rowid, short_question_text, data_value::float
       FROM #{source_table}
       WHERE geographic_level = \'City\'
       ORDER BY rowid, short_question_text'
      )
      AS #{source_table}(city_name VARCHAR, #{column_definitions.join(',')})
    );
    SQL
    connection.execute(query)
  end

  def connection
    ActiveRecord::Base.connection
  end
end