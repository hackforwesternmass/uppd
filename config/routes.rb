Uppd::Application.routes.draw do

  devise_scope :admin_user do
    resources :pages
    resources :proceedings
    resources :filings
    resources :doc_pages
  end

  root :to => 'application#index', :via => :get
  match 'page/:id' => 'doc_pages#show', :as => :page
  match '/document_tags/by_dom_id_root/:filing_doc_id/:pagenumber' => 'document_tags#by_dom_id_root', :as => :document_tags_by_dom_id_root
  match '/document_tags/create' => 'document_tags#create', :via => :post, :as => :document_tags_create
  match '/document_tags/update' => 'document_tags#update', :via => :post, :as => :document_tags_update
  match '/document_tags/delete' => 'document_tags#delete', :via => :post, :as => :document_tags_delete

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  #root :to => 'public/index.html'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
