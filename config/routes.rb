Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: 'devise/sessions#new'
  devise_for :users
  devise_scope :user do
    authenticated do
      root to: 'events#index', as: :authenticated_root
    end
    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :events, except: [:show]
  get '/:username/:eventname' => 'events#show', as: :show_event
  get '/events/:id/calendar' => 'events#calendar', as: :calendar

  get '/google8bd9dfe9e823ee85', to: redirect('/google8bd9dfe9e823ee85.html')
end
