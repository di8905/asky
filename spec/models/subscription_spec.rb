require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should have_and_belong_to_many(:users) }
  it { should validate_presence_of(:question_id) }
end
