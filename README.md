CDC Measure Correlations
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).


Requirements
---------------
* Postgres 9+
* Ruby 2.4.4

Getting Started
---------------

```
bundle install
rake db:create db:migrate load_cdc_dataset
```

The [`load_cdc_dataset`](https://github.com/wefarrell/cdc-measures/blob/master/lib/tasks/load_cdc_dataset.rake) task does the following:
1. Pulls the latest CDC dataset
2. Loads it into a table (`cdc_dataset`)
3. Builds a pivot table (`city_measures`) with each row representing a census tract and each column a cdc measurement
4. Builds a table (`measure_correlations`) of correlations for each measurement permutation pair

Start the rails server by running:
```
rails s
```

The application server does not transform the data in any way, and merely passes the correlations table to the frontend for rendering in highcharts. You can find the chart logic [here](https://github.com/wefarrell/cdc-measures/blob/master/app/assets/javascripts/measure_correlations/measure_correlations_chart.js).