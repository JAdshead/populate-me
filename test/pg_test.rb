require 'bacon'
$:.unshift File.expand_path('../../lib', __FILE__)
require 'populate_me/pg'
require 'pg'

DB=


describe 'PopulateMe::PG' do
  # PopulateMe::PG is the PosgreSQL specific extention for 
  # Document.
  #
  # It contains what is specific to a PosgreSQL
  class WaterWave
    include PopulateMe::Pg
    field :name
  end

  it 'Includes Document Module' do 
    WaterWave.to_s.should == "Water Wave"
    WaterWave.new(name: "Jaws").to_s.should == "Jaws"
  end

  # describe 'Database connection and setup' do 


  # end

  # describe 'Basic CRUD' do 


  # end

  # describe 'High Level CRUD' do

  # end


end