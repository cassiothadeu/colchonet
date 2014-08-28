Colchonet::Application.routes.draw do
  #Constraint para validar as rotas suportadas
  LOCALES = /en|pt\-BR/
  
  #Escopo utilizado para definir o locale(idioma )da app a partir da url
  # Para segmentos opcionais ()
  scope "(:locale)", locale: LOCALES do
    resources :rooms do
      #/rooms/:room_id/reviews
      #Aninhamento de resources para possibilitar a url
      #Faz a busca no modulo rooms dentro da pasta controller
      resources :reviews, only: [:create, :update], module: :rooms
    end
      
    #Configuramos o controller users_controller para responder as requisicoes
    resources :users
    
    #O motivo é que, para quem está navegando (ou o cliente de
    #uma API), não existe mais de uma con�rmação (ou seja, não faz sentido existir uma
    #ação index) no sistema. Isso é chamado de recurso singleton
    #somente a action show sera criada
    resource :confirmation, only: [:show]
    #Rota para o controller UserSessionsController(user_sessions)
    resource :user_sessions, only: [:create, :new, :destroy]
    
  end
  
  #Configuramos o home_controller na ação :index para ser a raiz da aplicação
  get '/:locale' => 'home#index', locale: LOCALES
  root "home#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
