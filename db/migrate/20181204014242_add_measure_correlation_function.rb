class AddMeasureCorrelationFunction < ActiveRecord::Migration[5.1]
  def up
    execute(<<-SQL
      CREATE OR REPLACE FUNCTION measure_correlation(measure_1 varchar, measure_2 varchar)
      RETURNS float AS $$
      DECLARE
        sum float;
      BEGIN
        EXECUTE format('SELECT corr(%s, %s) FROM city_measures', measure_1, measure_2)
          INTO sum;
        RETURN sum;
      END;
      $$ LANGUAGE plpgsql;
      SQL
    )
  end

  def down
    execut('DROP FUNCTION IF EXISTS measure_correlation')
  end
end
