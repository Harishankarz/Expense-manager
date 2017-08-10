  Rails.application.routes.draw do
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
     match "daily_details" => "daily_invoices#daily_details", :as => :daily_details, :via => [:get, :post]
     match "/"=> "expense_manager#dashboard",:via => [:get, :post]
     match "user_month_details" => "users#user_month_details",  :via => [:get, :post]
     match "month_info" => "users#month_info", :via => [:get, :post]

     resources :user_payments
     resources :payment_modes

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
