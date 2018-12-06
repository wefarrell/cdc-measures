class CityMeasuresController < ApplicationController
  CITY_NAME = 'New York'

  def index
    query = <<-SQL
      SELECT DISTINCT city_measures.*
      FROM city_measures
      LEFT JOIN cdc_dataset ON (cdc_dataset.unique_id = city_measures.unique_id)
      WHERE cdc_dataset.city_name = 'New York'
    SQL
    @city_measures = ActiveRecord::Base.connection.execute(query)
  end

end
