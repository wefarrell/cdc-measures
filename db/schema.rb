# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_04_014242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "tablefunc"

  create_table "cdc_dataset", force: :cascade do |t|
    t.string "year"
    t.string "state_abbr"
    t.string "state_desc"
    t.string "city_name"
    t.string "geographic_level"
    t.string "data_source"
    t.string "category"
    t.string "unique_id"
    t.string "measure"
    t.string "data_value_unit"
    t.string "data_value_type_id"
    t.string "data_value_type"
    t.string "data_value"
    t.string "low_confidence_limit"
    t.string "high_confidence_limit"
    t.string "data_value_footnote_symbol"
    t.string "data_value_footnote"
    t.string "population_count"
    t.string "geo_location"
    t.string "category_id"
    t.string "measure_id"
    t.string "city_fips"
    t.string "tract_fips"
    t.string "short_question_text"
  end

  create_table "city_measures", id: false, force: :cascade do |t|
    t.string "city_name"
    t.float "current_smoking"
    t.float "core_preventive_services_for_older_women"
    t.float "chronic_kidney_disease"
    t.float "health_insurance"
    t.float "physical_inactivity"
    t.float "physical_health"
    t.float "taking_bp_medication"
    t.float "cancer_except_skin"
    t.float "sleep_7_hours"
    t.float "core_preventive_services_for_older_men"
    t.float "dental_visit"
    t.float "high_blood_pressure"
    t.float "copd"
    t.float "stroke"
    t.float "binge_drinking"
    t.float "arthritis"
    t.float "pap_smear_test"
    t.float "cholesterol_screening"
    t.float "coronary_heart_disease"
    t.float "high_cholesterol"
    t.float "current_asthma"
    t.float "mammography"
    t.float "obesity"
    t.float "teeth_loss"
    t.float "colorectal_cancer_screening"
    t.float "annual_checkup"
    t.float "diabetes"
    t.float "mental_health"
  end

  create_table "measure_correlations", id: false, force: :cascade do |t|
    t.string "c2"
    t.string "c1"
    t.float "measure_correlation"
  end

end
