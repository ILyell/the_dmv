require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    @facility_2 = Facility.new({
      name: 'Ashland DMV Office', 
      address: '600 Tolman Creek Rd Ashland OR 97520', 
      phone: '541-776-6092' 
      })
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility_1).to be_an_instance_of(Facility)
      expect(@facility_1.name).to eq('Albany DMV Office')
      expect(@facility_1.address).to eq('2242 Santiam Hwy SE Albany OR 97321')
      expect(@facility_1.phone).to eq('541-967-2014')
      expect(@facility_1.services).to eq([])
    end

    it 'can hold avalible services' do
      expect(@facility_1.services).to eq([])
      expect(@facility_2.services).to eq([])

    end
    
    it "Can hold registered vehicles" do 
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_2.registered_vehicles).to eq([])
    end

    it 'Can hold collected fees' do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
      bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
      camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
      
      expect(@facility_1.collected_fees).to eq(0)
      @facility_1.add_service('Vehicle Registration')
      @facility_1.register_vehicle(cruz)
      expect(@facility_1.collected_fees).to eq(100)
      @facility_1.register_vehicle(bolt)
      expect(@facility_1.collected_fees).to eq(300)
      @facility_1.register_vehicle(camaro)
      expect(@facility_1.collected_fees).to eq(325)
    end
  end
  
  describe '#add service' do
    it 'can add available services' do
      expect(@facility_1.services).to eq([])
      @facility_1.add_service('New Drivers License')
      @facility_1.add_service('Renew Drivers License')
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end
  
  describe '#register_vehicle' do
    it 'can register a vehicle, if it has the service avalible.' do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
      bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
      camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
      
      expect(cruz.registration_date).to eq(nil) 
      expect(bolt.registration_date).to eq(nil)
      
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_2.registered_vehicles).to eq([])
      
      @facility_1.add_service('Vehicle Registration')
      @facility_1.register_vehicle(cruz)
      expect(@facility_1.registered_vehicles).to eq([cruz])
      expect(cruz.registration_date).to be_a(Integer)
      @facility_1.register_vehicle(bolt)
      expect(@facility_1.registered_vehicles).to eq([cruz, bolt])
      expect(bolt.registration_date).to eq(Date.today.year)
      expect(@facility_2.register_vehicle(camaro)).to eq(false)
      expect(camaro.registration_date).to eq(nil)
    end
  end
  
  describe '#administer_written_test' do
    it 'Can administer_written_test to 16+ and with a permit' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      registrant_2 = Registrant.new('Penny', 15)
      registrant_3 = Registrant.new('Timmy', 16, true)
      registrant_4 = Registrant.new('Sarah', 19)
      
      expect(registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      expect(@facility_1.administer_written_test(registrant_1)).to eq(false)
      expect(@facility_2.administer_written_test(registrant_1)).to eq(false)
      expect(@facility_1.administer_written_test(registrant_2)).to eq(false)
      expect(@facility_2.administer_written_test(registrant_2)).to eq(false)
      @facility_1.add_service('Written Test')
      expect(@facility_1.services).to eq(['Written Test'])
      expect(@facility_2.services).to eq([])
      expect(@facility_1.administer_written_test(registrant_1)).to eq(true)
      expect(registrant_1.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
      expect(@facility_1.administer_written_test(registrant_2)).to eq(false)
      expect(registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      expect(@facility_1.administer_written_test(registrant_3)).to eq(true)
      expect(registrant_3.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
      expect(@facility_1.administer_written_test(registrant_4)).to eq(false)
      expect(registrant_4.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    end
  end
  
  describe '#administer_road_test' do
    it 'can check if service offered' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      
      expect(@facility_1.administer_road_test(registrant_1)).to eq(false)
      expect(@facility_2.administer_road_test(registrant_1)).to eq(false)
      
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Written Test')
      @facility_1.administer_written_test(registrant_1)
        
      expect(@facility_1.administer_road_test(registrant_1)).to eq(true)
      expect(@facility_2.administer_road_test(registrant_1)).to eq(false)
    end
    it 'checks if written test == true' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      registrant_2 = Registrant.new('Timmy', 16, true)
      
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Written Test')
      @facility_1.administer_written_test(registrant_1)
      
      expect(@facility_1.administer_road_test(registrant_1)).to eq(true)
      expect(@facility_1.administer_road_test(registrant_2)).to eq(false)
    end
    it 'sets Registrant @license == true if written == true' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      registrant_2 = Registrant.new('Timmy', 16, true)
      
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Written Test')
      @facility_1.administer_written_test(registrant_1)
      @facility_1.administer_road_test(registrant_1)
      
      expect(@facility_1.administer_road_test(registrant_2)).to eq(false)
      expect(registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false})
      expect(registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    end
  end
  
  describe '#renew_drivers_license' do
    it 'can check if service offered' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      
      expect(@facility_1.renew_drivers_license(registrant_1)).to eq(false)
      expect(@facility_2.renew_drivers_license(registrant_1)).to eq(false)
      
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Written Test')
      @facility_1.add_service('Renew License')

      @facility_1.administer_written_test(registrant_1)
      @facility_1.administer_written_test(registrant_1)
      @facility_1.administer_road_test(registrant_1)
        
      expect(@facility_1.renew_drivers_license(registrant_1)).to eq(true)
      expect(@facility_2.renew_drivers_license(registrant_1)).to eq(false)
    end
    it 'checks if :road_test == true' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      registrant_2 = Registrant.new('Timmy', 16, true)
      
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Written Test')
      @facility_1.add_service('Renew License')
      @facility_1.administer_written_test(registrant_1)
      @facility_1.administer_road_test(registrant_1)
      @facility_1.administer_written_test(registrant_2)

      
      expect(@facility_1.renew_drivers_license(registrant_1)).to eq(true)
      expect(@facility_1.renew_drivers_license(registrant_2)).to eq(false)
    end
    it 'sets Registrant @renewed == true if @license == true' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      registrant_2 = Registrant.new('Timmy', 16, true)
      
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Written Test')
      @facility_1.add_service('Renew License')

      @facility_1.administer_written_test(registrant_1)
      @facility_1.administer_road_test(registrant_1)
      @facility_1.renew_drivers_license(registrant_1)
      @facility_1.administer_written_test(registrant_2)
      
      expect(@facility_1.renew_drivers_license(registrant_1)).to eq(true)
      expect(@facility_1.renew_drivers_license(registrant_2)).to eq(false)
      expect(registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>true})
      expect(registrant_2.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
    end
  end
end
