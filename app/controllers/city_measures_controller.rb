class CityMeasuresController < ApplicationController

  def index
    @city_measures = CityMeasure.all
  end

end
