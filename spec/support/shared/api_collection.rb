shared_examples_for 'API collection' do |attributes|
  let!(:access_token) { FactoryGirl.create(:access_token) }
  let(:collection_name) { collection.first.class.to_s.underscore.pluralize }
  before { send(http_method, path, {format: :json, access_token: access_token.token }.merge(try(:options) || {} )) }
  
  context 'authorized' do
    it 'returns 200 status code' do
      expect(response.status).to eq 200
    end
    
    it 'returns collection appropriate size' do
      expect(response.body).to have_json_size(collection.length).at_path(collection_name)
    end
    
    attributes.each do |attr|
      it "each  element contains attribute #{attr}" do
        collection.each_with_index do |element, i| 
          expect(response.body).to be_json_eql(element.send(attr.to_sym).to_json).at_path("#{collection_name}/#{i}/#{attr}")
        end
      end
    end
  end
end
