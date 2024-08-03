# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { create(:course) }

  it 'is valid' do
    expect(course).to be_valid
  end

  it 'is invalid without a name' do
    course.name = nil
    expect(course).not_to be_valid
  end

  it 'is invalid with a duplicate name' do
    duplicate_course = build(:course, name: course.name)
    expect(duplicate_course).not_to be_valid
  end

  it 'can have many tutors' do
    create_list(:tutor, 3, course:)
    expect(course.tutors.count).to eq(3)
  end
end
