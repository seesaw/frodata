require 'spec_helper'

describe FrOData::Entity, vcr: {cassette_name: 'edge_entity_specs'} do
  before(:example) do
    FrOData::Service.new('http://services.odata.org/V4/OData/OData.svc', name: 'ODataDemo')
  end

  let(:subject) { FrOData::Entity.new(options) }
  let(:options) { {
      type:         'ODataDemo.Category',
      namespace:    'ODataDemo',
      service_name: 'ODataDemo'
  } }

  it { expect(subject).to respond_to(:name, :type, :namespace, :service_name) }

  it { expect(subject.name).to eq('Category') }
  it { expect(subject.type).to eq('ODataDemo.Category') }
  it { expect(subject.namespace).to eq('ODataDemo') }
  it { expect(subject.service_name).to eq('ODataDemo') }

  describe '#id' do
    let(:subject) { FrOData::Entity.with_properties(properties, options) }
    let(:properties) { {
      "Code" => "Some TEXT"
    } }
    let(:entity_set) {
      FrOData::EntitySet.new(
        container: 'DemoService',
        namespace: 'ODataDemo',
        name: 'Categories',
        type: 'Category',
        service_name: 'ODataDemo')
    }
    let(:options) { {
        type:         'ODataDemo.Category',
        namespace:    'ODataDemo',
        service_name: 'ODataDemo',
        entity_set:   entity_set
    } }

    it "canonical URL is RFC 3986 compliant" do
      expect(subject.id).to eq("Categories('Some%20TEXT')")
    end
  end
end
