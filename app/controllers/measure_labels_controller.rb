class MeasureLabelsController < ApplicationController
  def index
    existing_column_names = CityMeasure.columns.map(&:name).without('unique_id')
    @measure_labels = CityMeasure.columns.map(&:name).without('unique_id').map{|measure|
      {label: measure.titleize, value: measure}
    }
  end
end
