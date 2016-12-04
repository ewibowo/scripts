#!/usr/local/bin/zsh

mkdir -p upgrade/docs/data-model
mkdir -p upgrade/docs/installation
mkdir -p upgrade/netbox/circuits
mkdir -p upgrade/netbox/circuits/fixtures
mkdir -p upgrade/netbox/dcim
mkdir -p upgrade/netbox/dcim/fixtures
mkdir -p upgrade/netbox/ipam
mkdir -p upgrade/netbox/ipam/fixtures
mkdir -p upgrade/netbox/netbox
mkdir -p upgrade/netbox/secrets
mkdir -p upgrade/netbox/secrets/fixtures
mkdir -p upgrade/netbox/templates
mkdir -p upgrade/netbox/templates/circuits
mkdir -p upgrade/netbox/templates/dcim
mkdir -p upgrade/netbox/templates/dcim/inc
mkdir -p upgrade/netbox/templates/inc
mkdir -p upgrade/netbox/templates/ipam
mkdir -p upgrade/netbox/templates/ipam/inc
mkdir -p upgrade/netbox/templates/secrets
mkdir -p upgrade/netbox/templates/secrets/inc
mkdir -p upgrade/netbox/templates/tenancy
mkdir -p upgrade/netbox/templates/users
mkdir -p upgrade/netbox/tenancy
mkdir -p upgrade/netbox/tenancy/migrations

cp netbox/docs/data-model/tenancy.md                               upgrade/docs/data-model/tenancy.md                              
cp netbox/docs/installation/netbox.md                              upgrade/docs/installation/netbox.md                             
cp netbox/netbox/circuits/filters.py                               upgrade/netbox/circuits/filters.py                              
cp netbox/netbox/circuits/fixtures/initial_data.json               upgrade/netbox/circuits/fixtures/initial_data.json              
cp netbox/netbox/circuits/tables.py                                upgrade/netbox/circuits/tables.py                               
cp netbox/netbox/circuits/views.py                                 upgrade/netbox/circuits/views.py                                
cp netbox/netbox/dcim/filters.py                                   upgrade/netbox/dcim/filters.py                                  
cp netbox/netbox/dcim/fixtures/initial_data.json                   upgrade/netbox/dcim/fixtures/initial_data.json                  
cp netbox/netbox/dcim/tables.py                                    upgrade/netbox/dcim/tables.py                                   
cp netbox/netbox/dcim/views.py                                     upgrade/netbox/dcim/views.py                                    
cp netbox/netbox/ipam/filters.py                                   upgrade/netbox/ipam/filters.py                                  
cp netbox/netbox/ipam/fixtures/initial_data.json                   upgrade/netbox/ipam/fixtures/initial_data.json                  
cp netbox/netbox/ipam/forms.py                                     upgrade/netbox/ipam/forms.py                                    
cp netbox/netbox/ipam/tables.py                                    upgrade/netbox/ipam/tables.py                                   
cp netbox/netbox/ipam/views.py                                     upgrade/netbox/ipam/views.py                                    
cp netbox/netbox/netbox/settings.py                                upgrade/netbox/netbox/settings.py                               
cp netbox/netbox/secrets/filters.py                                upgrade/netbox/secrets/filters.py                               
cp netbox/netbox/secrets/fixtures/initial_data.json                upgrade/netbox/secrets/fixtures/initial_data.json               
cp netbox/netbox/templates/500.html                                upgrade/netbox/templates/500.html                               
cp netbox/netbox/templates/_base.html                              upgrade/netbox/templates/_base.html                             
cp netbox/netbox/templates/circuits/circuit.html                   upgrade/netbox/templates/circuits/circuit.html                  
cp netbox/netbox/templates/circuits/circuit_list.html              upgrade/netbox/templates/circuits/circuit_list.html             
cp netbox/netbox/templates/circuits/circuittype_list.html          upgrade/netbox/templates/circuits/circuittype_list.html         
cp netbox/netbox/templates/circuits/provider.html                  upgrade/netbox/templates/circuits/provider.html                 
cp netbox/netbox/templates/circuits/provider_list.html             upgrade/netbox/templates/circuits/provider_list.html            
cp netbox/netbox/templates/dcim/console_connections_list.html      upgrade/netbox/templates/dcim/console_connections_list.html     
cp netbox/netbox/templates/dcim/device.html                        upgrade/netbox/templates/dcim/device.html                       
cp netbox/netbox/templates/dcim/device_inventory.html              upgrade/netbox/templates/dcim/device_inventory.html             
cp netbox/netbox/templates/dcim/device_list.html                   upgrade/netbox/templates/dcim/device_list.html                  
cp netbox/netbox/templates/dcim/devicerole_list.html               upgrade/netbox/templates/dcim/devicerole_list.html              
cp netbox/netbox/templates/dcim/devicetype.html                    upgrade/netbox/templates/dcim/devicetype.html                   
cp netbox/netbox/templates/dcim/devicetype_list.html               upgrade/netbox/templates/dcim/devicetype_list.html              
cp netbox/netbox/templates/dcim/inc/_device_header.html            upgrade/netbox/templates/dcim/inc/_device_header.html           
cp netbox/netbox/templates/dcim/inc/_interface.html                upgrade/netbox/templates/dcim/inc/_interface.html               
cp netbox/netbox/templates/dcim/interface_connections_list.html    upgrade/netbox/templates/dcim/interface_connections_list.html   
cp netbox/netbox/templates/dcim/manufacturer_list.html             upgrade/netbox/templates/dcim/manufacturer_list.html            
cp netbox/netbox/templates/dcim/platform_list.html                 upgrade/netbox/templates/dcim/platform_list.html                
cp netbox/netbox/templates/dcim/power_connections_list.html        upgrade/netbox/templates/dcim/power_connections_list.html       
cp netbox/netbox/templates/dcim/rack.html                          upgrade/netbox/templates/dcim/rack.html                         
cp netbox/netbox/templates/dcim/rack_list.html                     upgrade/netbox/templates/dcim/rack_list.html                    
cp netbox/netbox/templates/dcim/rackgroup_list.html                upgrade/netbox/templates/dcim/rackgroup_list.html               
cp netbox/netbox/templates/dcim/site.html                          upgrade/netbox/templates/dcim/site.html                         
cp netbox/netbox/templates/dcim/site_list.html                     upgrade/netbox/templates/dcim/site_list.html                    
cp netbox/netbox/templates/home.html                               upgrade/netbox/templates/home.html                              
cp netbox/netbox/templates/import_success.html                     upgrade/netbox/templates/import_success.html                    
cp netbox/netbox/templates/inc/export_button.html                  upgrade/netbox/templates/inc/export_button.html                 
cp netbox/netbox/templates/inc/filter_panel.html                   upgrade/netbox/templates/inc/filter_panel.html                  
cp netbox/netbox/templates/inc/search_panel.html                   upgrade/netbox/templates/inc/search_panel.html                  
cp netbox/netbox/templates/ipam/aggregate.html                     upgrade/netbox/templates/ipam/aggregate.html                    
cp netbox/netbox/templates/ipam/aggregate_list.html                upgrade/netbox/templates/ipam/aggregate_list.html               
cp netbox/netbox/templates/ipam/inc/prefix_header.html             upgrade/netbox/templates/ipam/inc/prefix_header.html            
cp netbox/netbox/templates/ipam/ipaddress.html                     upgrade/netbox/templates/ipam/ipaddress.html                    
cp netbox/netbox/templates/ipam/ipaddress_list.html                upgrade/netbox/templates/ipam/ipaddress_list.html               
cp netbox/netbox/templates/ipam/prefix.html                        upgrade/netbox/templates/ipam/prefix.html                       
cp netbox/netbox/templates/ipam/prefix_list.html                   upgrade/netbox/templates/ipam/prefix_list.html                  
cp netbox/netbox/templates/ipam/rir_list.html                      upgrade/netbox/templates/ipam/rir_list.html                     
cp netbox/netbox/templates/ipam/role_list.html                     upgrade/netbox/templates/ipam/role_list.html                    
cp netbox/netbox/templates/ipam/vlan.html                          upgrade/netbox/templates/ipam/vlan.html                         
cp netbox/netbox/templates/ipam/vlan_list.html                     upgrade/netbox/templates/ipam/vlan_list.html                    
cp netbox/netbox/templates/ipam/vlangroup_list.html                upgrade/netbox/templates/ipam/vlangroup_list.html               
cp netbox/netbox/templates/ipam/vrf.html                           upgrade/netbox/templates/ipam/vrf.html                          
cp netbox/netbox/templates/ipam/vrf_list.html                      upgrade/netbox/templates/ipam/vrf_list.html                     
cp netbox/netbox/templates/secrets/inc/private_key_modal.html      upgrade/netbox/templates/secrets/inc/private_key_modal.html     
cp netbox/netbox/templates/secrets/secret.html                     upgrade/netbox/templates/secrets/secret.html                    
cp netbox/netbox/templates/secrets/secret_list.html                upgrade/netbox/templates/secrets/secret_list.html               
cp netbox/netbox/templates/secrets/secretrole_list.html            upgrade/netbox/templates/secrets/secretrole_list.html           
cp netbox/netbox/templates/tenancy/tenant.html                     upgrade/netbox/templates/tenancy/tenant.html                    
cp netbox/netbox/templates/tenancy/tenant_list.html                upgrade/netbox/templates/tenancy/tenant_list.html               
cp netbox/netbox/templates/tenancy/tenantgroup_list.html           upgrade/netbox/templates/tenancy/tenantgroup_list.html          
cp netbox/netbox/templates/users/userkey.html                      upgrade/netbox/templates/users/userkey.html                     
cp netbox/netbox/tenancy/filters.py                                upgrade/netbox/tenancy/filters.py                               
cp netbox/netbox/tenancy/forms.py                                  upgrade/netbox/tenancy/forms.py                                 
cp netbox/netbox/tenancy/migrations/0002_tenant_group_optional.py  upgrade/netbox/tenancy/migrations/0002_tenant_group_optional.py 
cp netbox/netbox/tenancy/models.py                                 upgrade/netbox/tenancy/models.py                                
cp netbox/netbox/tenancy/tables.py                                 upgrade/netbox/tenancy/tables.py                                
cp netbox/netbox/tenancy/views.py                                  upgrade/netbox/tenancy/views.py                                 
cp netbox/netbox/circuits/fixtures/initial_data.json               upgrade/netbox/circuits/fixtures/initial_data.json
cp netbox/netbox/dcim/fixtures/initial_data.json                   upgrade/netbox/dcim/fixtures/initial_data.json
cp netbox/netbox/ipam/fixtures/initial_data.json                   upgrade/netbox/ipam/fixtures/initial_data.json
cp netbox/netbox/secrets/fixtures/initial_data.json                upgrade/netbox/secrets/fixtures/initial_data.json
cp netbox/netbox/templates/inc/search_panel.html                   upgrade/netbox/templates/inc/search_panel.html

################################################################################
#
