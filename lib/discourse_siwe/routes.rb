# frozen_string_literal: true

DiscourseSiwe::Engine.routes.draw do
  get '/auth' => 'auth#index'
  get '/message' => 'auth#message'
end
