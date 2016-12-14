shared_examples_for 'API create object' do |object_class|
  let!(:access_token) { FactoryGirl.create(:access_token) }
    
  context 'authorized' do
    it 'creates new object in db with valid query' do
      expect { create_query }.to change(object_class, :count).by(1)
    end
    
    it 'does not creates question in db with invalid question parameters' do
      expect { invalid_query }.not_to change(object_class, :count)
    end
    
    it 'returns 422 status with invalid question parameters' do
      invalid_query
      expect(response.status).to eq 422
    end
  end

end
