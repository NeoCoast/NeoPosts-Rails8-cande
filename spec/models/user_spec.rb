# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    described_class.create!(email: 'buffy@gmail.com', nickname: 'Buff', first_name: 'Buffy',
                           last_name: 'Summers', birthday: Date.new(2000, 12, 12), password: 'passsword')
  end
  before do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    user.image.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
  end

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is not valid without a nickname' do
    user.nickname = nil
    expect(user).to_not be_valid
  end

  it 'is not valid without an email' do
    user.email = nil
    expect(user).to_not be_valid
  end

  describe '#image' do
    it 'should have an image attached' do
      expect(user.image).to be_attached
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:nickname) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:birthday) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:nickname).case_insensitive }
  end
end
