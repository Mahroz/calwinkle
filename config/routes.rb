Rails.application.routes.draw do
  resources :groups
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
  resources :groups, exept: :show

  get '/:username/groups/:groupname' => 'groups#show', as: :show_group


  get '/:username/:eventname' => 'events#show', as: :show_event
  post '/new/preview' => 'events#preview', as: :event_preview
  get '/events/:id/calendar/:name' => 'events#calendar', as: :calendar
end
