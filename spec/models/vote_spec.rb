require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :voteable }
  it { should belong_to :user }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:vote) }
  it { should validate_uniqueness_of(:user_id).scoped_to([:voteable_id, :voteable_type]) }
  it { should allow_value(1, -1).for(:vote) }
end
