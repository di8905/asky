require 'rails_helper'

RSpec.describe SubscriptionsUser, type: :model do
  subject { SubscriptionsUser.new(user_id: 1, subscription_id: 1) }
  it { should belong_to :user }
  it { should belong_to :subscription }
  it { should validate_uniqueness_of(:user_id).scoped_to(:subscription_id) }
end
