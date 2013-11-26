Rails.application.routes.draw do

  namespace :admin do
    get 'export/contacts_export_settings' => 'exporter#contacts_export_settings', :as => :contacts_export_settings
    put 'export/contacts' => 'exporter#export_contacts', :as => :export_contacts
  end

end
