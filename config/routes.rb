Rails.application.routes.draw do
   
  #resources :events
  post 'events', to: 'events#create'
  post 'events/clear', to: 'events#clear'
  get 'events', to: 'events#show'
  get 'events/summary', to: 'events#summary'
     
end
