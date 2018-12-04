task load_cdc_dataset: :environment  do
  DATASET_URL = 'https://data.cdc.gov/api/views/6vp6-wxuq/rows.csv'
  RAW_CSV_TABLE_NAME = 'cdc_dataset'
  CITY_MEASURES_TABLE_NAME = 'city_measures'
  CORRELTATIONS_TABLE_NAME = 'measure_correlations'

  file = SaveRemoteFileToTmpService.new(DATASET_URL).save_remote_file

  raw_table_builder = BuildTableFromCsvService.new(file, RAW_CSV_TABLE_NAME)
  columns = raw_table_builder.load_header
  data_loader = LoadDatasetToDbService.new(file, RAW_CSV_TABLE_NAME, columns)
  city_measures_table_builder = BuildCityMeasuresTableService.new(RAW_CSV_TABLE_NAME, CITY_MEASURES_TABLE_NAME)
  correlations_table_builder = BuildMeasureCorrelationsTableService.new(CITY_MEASURES_TABLE_NAME, CORRELTATIONS_TABLE_NAME)
  ActiveRecord::Base.transaction do
    raw_table_builder.create_table
    data_loader.load_dataset_to_db
    city_measures_table_builder.create_table
    correlations_table_builder.create_table
  end
end