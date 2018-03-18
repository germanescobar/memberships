Rails.application.routes.draw do
  root "memberships#index"

  devise_for :users

  resources :organizations do
    put :switch, on: :member
  end

  resources :invitations, only: [:new, :create] do
    post :resend, on: :member
    get :accept, on: :member
  end

  resources :memberships, only: [:index, :destroy] do
    post :toggle_admin, on: :member
  end

  resources :users, only: [] do
    get "activate", to: "users#activate_form", on: :member
    put :activate, on: :member
  end
end
