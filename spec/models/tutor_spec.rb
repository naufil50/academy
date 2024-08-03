# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tutor, type: :model do
  let(:tutor) { create(:tutor) }

  it 'is valid' do
    expect(tutor).to be_valid
  end

  it 'is invalid without a name' do
    tutor.name = nil
    expect(tutor).not_to be_valid
  end

  it 'is invalid without an email' do
    tutor.email = nil
    expect(tutor).not_to be_valid
  end

  it 'is invalid with a non-unique email' do
    duplicate_tutor = build(:tutor, email: tutor.email)
    expect(duplicate_tutor).not_to be_valid
  end
end
