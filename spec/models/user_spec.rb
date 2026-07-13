# -*- encoding : utf-8 -*-
require_relative '../spec_helper'

describe User do

  let(:user) { FactoryBot.build(:user, telephone_number: '0612345678') }

  it 'has a telephone_number attribute' do
    expect{ user.telephone_number }.to_not raise_error
  end

  it 'allows the telephone_number to be set for new users' do
    expect(user.valid?).to be true
    expect(user.telephone_number).not_to be_nil
  end

  it 'allows the telephone_number to be omitted for new users' do
    user_without = FactoryBot.build(:user, telephone_number: nil)
    expect(user_without.valid?).to be true
    expect(user_without.telephone_number).to be_nil
  end

  context 'validating format' do
    def test_error_message(user, expected_message)
      expect(user.valid?).to be false
      errors = user.errors[:telephone_number]
      expect(errors.size).to eql(1)
      expect(errors[0]).to eql(expected_message)
    end

    it 'accepts correct telephone numbers' do
      user = FactoryBot.build(:user, telephone_number: "0612345678")
      expect(user.valid?).to be true
      expect(user.telephone_number).to eql("+31612345678")
    end

    it 'removes whitespace' do
      user = FactoryBot.build(:user, telephone_number: "  0 6 77  03  91 32      ")
      expect(user.valid?).to be true
      expect(user.telephone_number).to eql("+31677039132")
    end

    it 'allows dash as separator' do
      user = FactoryBot.build(:user, telephone_number: '06-12345678')
      expect(user.valid?).to be true
      expect(user.telephone_number).to eql("+31612345678")
    end

    it 'allows to start with +31 followed by a zero' do
      user = FactoryBot.build(:user, telephone_number: '+31 06 12345678')
      expect(user.valid?).to be true
      expect(user.telephone_number).to eql("+31612345678")
    end

    it 'allows to start with +31 not followed by a zero' do
      user = FactoryBot.build(:user, telephone_number: '+31 6 12345678')
      expect(user.valid?).to be true
      expect(user.telephone_number).to eql("+31612345678")
    end

    it 'allows to start with 0031 followed by a zero' do
      user = FactoryBot.build(:user, telephone_number: '0031 06 12345678')
      expect(user.valid?).to be true
      expect(user.telephone_number).to eql("+31612345678")
    end

    it 'allows to start with 0031 not followed by a zero' do
      user = FactoryBot.build(:user, telephone_number: '0031 6 12345678')
      expect(user.valid?).to be true
      expect(user.telephone_number).to eql("+31612345678")
    end

    it 'allows emptying telephone number' do
      user = FactoryBot.build(:user, telephone_number: "")
      expect(user.valid?).to be true
      expect(user.telephone_number).to eql("")
    end

    it 'does not accept 9 digits' do
      user = FactoryBot.build(:user, telephone_number: '061234567')
      test_error_message(user, 'should be a Dutch number consisting of 10 digits')
    end

    it 'does not accept 11 digits' do
      user = FactoryBot.build(:user, telephone_number: '06123456789')
      test_error_message(user, 'should be a Dutch number consisting of 10 digits')
    end

    it 'does not accept incomplete numbers' do
      user = FactoryBot.build(:user, telephone_number: '06123')
      test_error_message(user, 'should be a Dutch number consisting of 10 digits')
    end

    it 'does not allow letters' do
      user = FactoryBot.build(:user, telephone_number: '06L2345678')
      test_error_message(user, 'should only contain digits')
    end

    it 'does not allow symbols' do
      user = FactoryBot.build(:user, telephone_number: '061234567@')
      test_error_message(user, 'should only contain digits')
    end

  end

  context "censor rules" do

    it "creates a rule after saving" do
      user = FactoryBot.build(:user, telephone_number: "0612345678")
      user.save!
      expect(user.censor_rules.size).to eql(1)

      cr = user.censor_rules.first
      expect(cr.text).to eql("\\+[\\s\\-]*3[\\s\\-]*1[\\s\\-]*6[\\s\\-]*1[\\s\\-]*2[\\s\\-]*3[\\s\\-]*4[\\s\\-]*5[\\s\\-]*6[\\s\\-]*7[\\s\\-]*8|0[\\s\\-]*6[\\s\\-]*1[\\s\\-]*2[\\s\\-]*3[\\s\\-]*4[\\s\\-]*5[\\s\\-]*6[\\s\\-]*7[\\s\\-]*8")
    end

    it "creates only one rule for each number" do
      user = FactoryBot.build(:user, telephone_number: "0612345678")
      user.save!
      expect(user.censor_rules.size).to eql(1)

      user.name = SecureRandom.hex(5)
      user.save!
      expect(user.censor_rules.size).to eql(1)

      user.telephone_number = "+31611119999"
      user.save!
      expect(user.censor_rules.size).to eql(2)
    end

    it "censors different represenations of telephone numbers" do
      user = FactoryBot.build(:user, telephone_number: "0612345678")
      user.save!
      cr = user.censor_rules.first

      expect(cr.apply_to_text("Is 0612345678 redacted?")).to eql("Is [removed] redacted?")
      expect(cr.apply_to_text("Is 06 1234 5678 redacted?")).to eql("Is [removed] redacted?")
      expect(cr.apply_to_text("Is 06-1234567-8 redacted?")).to eql("Is [removed] redacted?")
      expect(cr.apply_to_text("Is 06
1234 56-78 redacted?")).to eql("Is [removed] redacted?")

      expect(cr.apply_to_text("Is +31612345678 redacted?")).to eql("Is [removed] redacted?")
      expect(cr.apply_to_text("Is +316 1234 5678 redacted?")).to eql("Is [removed] redacted?")
      expect(cr.apply_to_text("Is +316-1234567-8 redacted?")).to eql("Is [removed] redacted?")
      expect(cr.apply_to_text("Is +316
1234 56-78 redacted?")).to eql("Is [removed] redacted?")

      # Sanity check
      expect(cr.apply_to_text("Is +31687654321 redacted?")).to eql("Is +31687654321 redacted?")
    end
  end

end
