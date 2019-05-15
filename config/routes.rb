# == Route Map
#
#                    Prefix Verb URI Pattern                                                                              Controller#Action
#                      root GET  /                                                                                        top_pages#index
#                characters GET  /characters(.:format)                                                                    characters#index
#                 character GET  /characters/:id(.:format)                                                                characters#show
#                    forges GET  /forges(.:format)                                                                        forges#index
#                     forge GET  /forges/:id(.:format)                                                                    forges#show
#                    equips GET  /equips(.:format)                                                                        equips#index
#                     equip GET  /equips/:id(.:format)                                                                    equips#show
#                     drops GET  /drops(.:format)                                                                         drops#index
#                      drop GET  /drops/:id(.:format)                                                                     drops#show
#                     items GET  /items(.:format)                                                                         items#index
#                      item GET  /items/:id(.:format)                                                                     items#show
#                    stages GET  /stages(.:format)                                                                        stages#index
#                     stage GET  /stages/:id(.:format)                                                                    stages#show
#        rails_service_blob GET  /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET  /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET  /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT  /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "top_pages#index"
  resources :characters, only: [:index, :show]
  resources :items, only: [:index, :show]
  resources :stages, only: [:index, :show]
end
