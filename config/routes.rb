Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'up' => 'rails/health#show', as: :rails_health_check
  root to: redirect('/index.html')
  namespace :api do
    namespace :v1 do
      resources :employees, only: %i[index show] do
        get :salary_history, on: :member
      end
      post 'employees/:employee_id/salary_changes', to: 'employees#create'
      get 'insights', to: 'insights#index'
    end
  end
end
