ActionController::Routing::Routes.draw do |map|

  map.login '/login', :controller => 'sessions', :action => 'new'

  map.resources :sessions

  map.resources :users


   map.root :controller => "recipes"

   map.resources :recipes do |recipes|
      recipes.resources :ingredients, :collection => {:auto_complete_for_ingredient_name => :get } do |ingredients|
        ingredients.resources :amounts, :member => {:set_amount_ing_amnt => :any, :set_amount_ing_group => :any}
      end
   end
   map.resources :ingredients, :collection => {:auto_complete_for_ingredient_name => :get } do |ingredients|
      ingredients.resources :recipes
      ingredients.resources :amounts
   end
   
   map.resources :recipes, :member => {:set_recipe_in_place_name => :any, 
                                       :set_recipe_in_place_author => :any, 
                                       :set_recipe_in_place_directions => :any, 
                                       :set_recipe_in_place_oven_temp => :any},
                           :collection => {:auto_complete_for_ingredient_name => :get,
                                           :set_amount_ing_amnt => :any, :set_amount_ing_group => :any, :change_group => :any}
   map.resources :amounts, :collection => {:auto_complete_for_amount_ing_group => :get, :auto_complete_for_amount_ing_amnt => :any}



  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  #   map.connect ':controller/:action/:id'
  #   map.connect ':controller/:action/:id.:format'
end
