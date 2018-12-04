class BuildCityMeasuresTableService
  attr_reader :source_table, :destination_table

  def initialize(source_table, destination_table)
    @source_table = source_table
    @destination_table = destination_table
  end

  def measure_columns
    query = 'SELECT DISTINCT short_question_text from cdc_dataset ORDER BY short_question_text'
    connection.execute(query).pluck('short_question_text').map{ |question|
      question.parameterize.underscore
    }
  end

  def crosstab_query
    column_definitions = measure_columns.map{|column| "#{column} FLOAT"}
    <<-SQL
      SELECT * FROM crosstab($$
      SELECT unique_id,
        short_question_text,
        data_value::float
      FROM #{source_table}
      WHERE data_value_type = 'Age-adjusted prevalence'
      ORDER BY 1,2
      $$) AS #{source_table}(unique_id VARCHAR, #{column_definitions.join(',')})
    SQL
  end

  def create_table
    connection.execute("DROP TABLE IF EXISTS #{destination_table}")
    connection.execute("CREATE TABLE #{destination_table} AS (#{crosstab_query});")
  end

  def connection
    ActiveRecord::Base.connection
  end
end