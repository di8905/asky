include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :attachment do
    file { fixture_file_upload "#{Rails.root}/spec/support/testfile.txt", 'text/txt' }
    attachable nil
  end
end
