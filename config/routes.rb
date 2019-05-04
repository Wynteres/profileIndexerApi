Rails.application.routes.draw do
  # routes for the api
  namespace :api do
    # versioning api routes
    namespace :v1 do
      resources :profiles, controller: :profile, except: %i[new edit]
    end
  end
end
