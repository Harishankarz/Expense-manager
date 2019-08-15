  Rails.application.routes.draw do

    devise_for :users,
      controllers: { registrations: "registrations" }

    devise_scope :user do
      # Routes specified for Capybara poltergiest web driver
      get "/users/password", to: "devise/passwords#new"

      get "/signin", to: "devise/sessions#new"
      get "/unauthorized", to: "devise/sessions#new"
      get "/signup", to: "registrations#new"
      delete "/signout", to: "devise/sessions#destroy"
      get "/signout", to: "devise/sessions#destroy"
    end

    resources :custom_expense_types
     root "daily_invoices#index"
     resources :users
     resources :expenses do
       collection do
         post :imports
       end
     end
     resources :meals_expenses, controller: "meals_expenses", type: "MealsExpense" do
       collection do
         get :export
       end
     end
     resources :fruits_expenses, controller: "expenses", type: "FruitsExpense"
     resources :snaks_expenses, controller: "expenses", type: "SnaksExpense"
     resources :daily_invoices

     match "previous_record" => "daily_invoices#previous_record", :as => :previous_record, :via => [:get]
     match "user_details" => "users#user_details", :as => :user_details, :via => [:get, :post]
     match "meals_details" => "users#meals_details", :as => :meals_details, :via => [:get, :post]
     match "daily_details" => "daily_invoices#daily_details", :as => :daily_details, :via => [:get, :post]
     match "/"=> "expense_manager#dashboard",:via => [:get, :post]
     match "user_month_details" => "users#user_month_details",  :via => [:get, :post]
     match "month_info" => "users#month_info", :via => [:get, :post]

     resources :user_payments
     resources :payment_modes

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
