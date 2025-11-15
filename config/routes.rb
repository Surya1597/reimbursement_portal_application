Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  resources :sessions, only: %i[new create destroy] do
    collection do
      get "login", to: "sessions#new"
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"
    end
  end

  resources :employee, only: [] do
    collection do
      get "reimbursement_dashboard", to: "employee#reimbursement_dashboard"
    end
  end

  resources :bill, only: %i[new create update]

  get "admin/bills", to: "user#admin_bills_dashboard", as: :admin_bills_dashboard
  resources :admin_users, controller: "user", path: "admin/users", only: %i[index create update destroy]
end
