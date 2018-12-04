class MeasureCorrelationsController < ApplicationController

  def index
    @measure_correlations = MeasureCorrelation.all
  end

end
