require 'spec_helper'

RSpec.describe Dmv do
  before(:each) do

    @or_locations = DmvDataService.new.or_dmv_office_locations
    @ny_locations = DmvDataService.new.ny_dmv_office_locations
    @mo_locations = DmvDataService.new.mo_dmv_office_locations
  
    @dmv = Dmv.new
    @facility_1 = {name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' }
    @facility_2 = {name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' }
    @facility_3 = {name: 'Bend DMV Office', address: '63030 O B Riley Rd Bend OR 97701', phone: '541-388-6322' }
  end

  describe '#initialize' do
    
    it 'Exist' do
      
      expect(@dmv).to be_an_instance_of(Dmv)
      expect(@dmv.facilities).to eq([])
    end
    
    it 'Holds an @facilitys array that starts empty' do

      expect(@dmv.facilities). to eq([])
    end
  end

  describe '#add facilities' do
    
    it 'Can add available facilities' do

      expect(@dmv.facilities).to eq([])
      @dmv.add_facilities([@facility_1, @facility_2, @facility_3])

      expect(@dmv.facilities[0].address).to eq(@facility_1[:address])
      expect(@dmv.facilities[1].address).to eq(@facility_2[:address])
      expect(@dmv.facilities[2].address).to eq(@facility_3[:address])

    end

    it 'Can add facilities from Oregon DMV api' do 
      

      expect(@dmv.facilities).to eq([])
      @dmv.add_facilities(@or_locations)

      expect(@dmv.facilities[1]).to be_a(Facility)
      expect(@dmv.facilities[1].name).to eq('Ashland DMV Office')
      expect(@dmv.facilities[1].address).to eq("600 Tolman Creek Rd Ashland OR 97520")
      expect(@dmv.facilities[1].phone).to eq('541-776-6092')

    end

    it 'Can add facilities from New York dmv api' do

      expect(@dmv.facilities).to eq([])
      @dmv.add_facilities(@ny_locations)

      expect(@dmv.facilities[1]).to be_a(Facility)
      expect(@dmv.facilities[1].name).to eq("Rochester Downtown")
      expect(@dmv.facilities[1].address).to eq("200 E Main Street Ste. 101 Rochester NY 14604")
      expect(@dmv.facilities[1].phone).to eq("585-753-1604")

    end

    it 'Can add facilities from Missiouri dmv api' do
      expect(@dmv.facilities).to eq([])
      @dmv.add_facilities(@mo_locations)
      expect(@dmv.facilities[1]).to be_a(Facility)
      expect(@dmv.facilities[1].name).to eq("Bonne Terre")
      expect(@dmv.facilities[1].address).to eq("30 N Allen St Bonne Terre MO 63628")
      expect(@dmv.facilities[1].phone).to eq("573-358-3584")

    end

  end

  describe '#facilities_offering_service' do
    it 'Can return list of facilities offering a specified Service' do
      @dmv.add_facilities([@facility_1, @facility_2, @facility_3])


      
      @dmv.facilities[1].add_service('Vehicle Registration')
      @dmv.facilities[2].add_service('Renew Drivers License')
      @dmv.facilities[1].add_service('New Drivers License')
      @dmv.facilities[1].add_service('Road Test')
      @dmv.facilities[1].add_service('Written Test')
      @dmv.facilities[2].add_service('Road Test')

      @dmv.facilities[1].add_service('New Drivers License')
      
      

      expect(@dmv.facilities_offering_service('Road Test')).to eq(@dmv.facilities[1..2])
    end
  end

  describe '#format_name' do
    it 'takes a given hash argument and returns a name string' do
      
      expect(@dmv.format_name(@facility_1)).to eq("Albany DMV Office")
      expect(@dmv.format_name(@facility_2)).to eq('Ashland DMV Office')
      expect(@dmv.format_name(@facility_3)).to eq('Bend DMV Office')
    end

    it 'takes a diffrent value from the hash argument' do

      expect(@dmv.format_name(@or_locations[1])).to eq("Ashland DMV Office")
      expect(@dmv.format_name(@ny_locations[1])).to eq("Rochester Downtown")
      expect(@dmv.format_name(@mo_locations[1])).to eq("Bonne Terre")

    end
  end

  describe '#format_address' do
    it 'takes a hash and returns a string' do

      expect(@dmv.format_address(@facility_1)).to eq("2242 Santiam Hwy SE Albany OR 97321")
      expect(@dmv.format_address(@facility_2)).to eq('600 Tolman Creek Rd Ashland OR 97520')
      expect(@dmv.format_address(@facility_3)).to eq('63030 O B Riley Rd Bend OR 97701')

    end

    it 'can take diffrent values from the hash and formate them' do

      expect(@dmv.format_address(@or_locations[1])).to eq("600 Tolman Creek Rd Ashland OR 97520")
      expect(@dmv.format_address(@ny_locations[1])).to eq("200 E Main Street Ste. 101 Rochester NY 14604")
      expect(@dmv.format_address(@mo_locations[1])).to eq("30 N Allen St Bonne Terre MO 63628")
    end
  end

  describe '#format_phone' do
    it 'takes a phone string and formats' do


      expect(@dmv.format_phone(@facility_1)).to eq('541-967-2014')
      expect(@dmv.format_phone(@facility_2)).to eq('541-776-6092')
      expect(@dmv.format_phone(@facility_3)).to eq('541-388-6322')

    end

    it 'can format from a diffrent source' do

      expect(@dmv.format_phone(@or_locations[1])).to eq('541-776-6092')
      expect(@dmv.format_phone(@ny_locations[1])).to eq("585-753-1604")
      expect(@dmv.format_phone(@mo_locations[1])).to eq("573-358-3584")
      
    end
  end
  
  describe '#format_hours' do
    it 'takes hours from a facility hash' do
      
    end
  end
end 
