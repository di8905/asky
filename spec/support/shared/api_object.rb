shared_examples_for 'API object' do |object_attributes|
  let!(:access_token) { FactoryGirl.create(:access_token) }
  let(:object_name) { object.class.to_s.underscore }
  before { send(http_method, path, {format: :json, access_token: access_token.token }.merge(try(:options) || {} )) }
  
  context 'authorized' do
    it 'returns 200 status code' do
      expect(response.status).to eq 200
    end
    
    object_attributes.each do |attr|
      it "has attribite #{attr}" do
        expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{object_name}/#{attr}")
      end
    end
  end
  
  context 'object comments' do
    it 'returns list of object comments' do
      expect(response.body).to have_json_size(3).at_path("#{object_name}/comments")
    end
    
    %w(id body commentable_type commentable_id user_id).each do |attr|
      it "has comment attribute #{attr}" do
        object.comments.each_with_index do |comment, i|
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{object_name}/comments/#{i}/#{attr}")
        end
      end
    end
  end
  
  context 'object attachments' do
    it 'returns list of objects attachments urls' do
      expect(response.body).to have_json_size(1).at_path("#{object_name}/attachments")
    end
    
    it 'returns object attachment names' do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{object_name}/attachments/0/url")
    end
    
    it 'returns question attachment urls' do
      expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("#{object_name}/attachments/0/filename")
    end
  end
  
  if object_attributes.include?('answers')
    context 'object answers' do
      it 'returns list of object answers' do
        expect(response.body).to have_json_size(3).at_path("question/answers")
      end
      
      %w(id created_at updated_at body question_id user_id best).each do |attr|
        it "has answer attribute #{attr}" do
          object.answers.each_with_index do |answer, i|
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{object_name}/answers/#{i}/#{attr}")
          end
        end
      end
    end
  end
end
