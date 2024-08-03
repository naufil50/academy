# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Courses API', type: :request do
  let!(:course) { create(:course) }
  let!(:tutors) { create_list(:tutor, 3, course:) }
  let(:course_id) { course.id }

  let(:valid_attributes) do
    {
      course: {
        name: Faker::Name.name,
        description: Faker::Lorem.sentence,
        tutors_attributes: [
          { name: Faker::Name.name, email: Faker::Internet.email },
          { name: Faker::Name.name, email: Faker::Internet.email }
        ]
      }
    }.to_json
  end

  let(:invalid_course_attributes) do
    {
      course: {
        name: ''
      }
    }.to_json
  end

  let(:invalid_tutor_attributes) do
    {
      course: {
        name: 'New Course',
        description: 'A description for the new course',
        tutors_attributes: [
          { name: "", email: Faker::Internet.email },
        ]
      }
    }.to_json
  end

  describe 'GET /courses' do
    before { get '/courses' }

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all courses' do
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it 'includes tutors in the response' do
      json_response = JSON.parse(response.body)
      expect(json_response.first['tutors'].size).to eq(3)
    end
  end

  describe 'POST /courses' do
    context 'with valid parameters' do
      before { post '/courses', params: valid_attributes, headers: { 'Content-Type': 'application/json' } }

      it 'creates a new Course' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the created course with tutors' do
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('name')
        expect(json_response).to have_key('description')
        expect(json_response['tutors'].size).to eq(2)
      end
    end

    context 'with invalid course parameters' do
      before { post '/courses', params: invalid_course_attributes, headers: { 'Content-Type': 'application/json' } }

      it 'does not create a new Course' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank")
      end
    end

    context 'with invalid tutor parameters' do
      before { post '/courses', params: invalid_tutor_attributes, headers: { 'Content-Type': 'application/json' } }

      it 'does not create a new Course' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Tutors name can't be blank")
      end
    end
  end
end
