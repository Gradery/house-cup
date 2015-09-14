Rails.application.routes.draw do
  devise_for :staffs
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'page#index'

  get "/api/houses" => 'api#houses'
  get "/api/houses/activities" => 'api#house_points_by_activity'
  get "/api/staff" => 'api#staff'
  get "/api/staff/activities" => 'api#staff_assignment_by_activity'
  get "/api/top_points" => 'api#top_points'

  get "/students" => 'page#students'

  get ':school' => 'page#show'
  get ':school/stylesheet' => 'page#stylesheet'
  get ':school/about' => 'page#about'

  get ':school/score' => 'page#add'
  post ':school/score' => 'page#doadd'

  get ':school/house/:id' => 'page#invite'
  post ':school/house/:id' => 'page#doinvite'

  get ':school/invite' => 'page#create_invite'
  post ':school/invite' => 'page#do_create_invite'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
