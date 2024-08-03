# frozen_string_literal: true

Rails.application.routes.draw do
  resources :courses, only: [:index, :create]

  root "courses#index"
end
