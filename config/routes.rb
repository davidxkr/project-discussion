require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: {format: :json}, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      post '/sessions' => 'sessions#create', as: :signin
      delete '/sessions' => 'sessions#destroy', as: :signout
    end
  end
end