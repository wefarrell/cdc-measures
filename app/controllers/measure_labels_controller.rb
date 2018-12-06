class MeasureLabelsController < ApplicationController
  def index
    @measure_labels = CityMeasure.columns.map(&:name).without('unique_id').map{|measure|
      {label: measure.titleize, value: measure}
    }
  end
end
