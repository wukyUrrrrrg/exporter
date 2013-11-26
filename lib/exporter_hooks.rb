class ExporterHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_configurations_menu do
    %(<tr>
    <td><%= link_to t('users_export'), admin_contacts_export_settings_path %> </td>
    <td><%= t('users_export') %></td>
    </tr>)
  end
end
