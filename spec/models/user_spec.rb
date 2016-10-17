require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_length_of(:name).is_at_least(3) }
  it { should validate_length_of(:password).is_at_least(6) }
  it { should_not allow_value('de@nis').for(:email) }
  it { should allow_value('denis@pavlov.com').for(:email) }
end
