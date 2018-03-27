Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :room_details, only: [:index, :update] do
    collection do
      put :update_bulk
    end
  end
end
