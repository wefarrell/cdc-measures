class BuildMeasureCorrelationsTableService
  attr_reader :source_table, :destination_table

  def initialize(source_table, destination_table)
    @source_table = source_table
    @destination_table = destination_table
  end

  def create_table
    connection.execute("DROP TABLE IF EXISTS #{destination_table}")
    query = <<-SQL
      CREATE TABLE #{destination_table} AS (
        WITH measure_names AS (SELECT column_name
          FROM information_schema.columns
          WHERE table_name  = '#{source_table}'
          AND column_name != 'city_name'
        )
        SELECT
          t1.column_name AS measure_1,
          t2.column_name AS measure_2,
          measure_correlation(t1.column_name, t2.column_name) AS correlation
        FROM measure_names t1
        CROSS JOIN measure_names t2
      )
      SQL
      connection.execute(query)
  end

  def connection
    ActiveRecord::Base.connection
  end
end