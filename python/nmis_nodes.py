#!/usr/local/bin/python

from pprint import pprint
import json


with open('DC4-nodes_pulled.json', 'w+') as dc4_file:
    for doc in db1.nodes.find(projection=get_fields):
        dc4_docs = json.dumps(doc, indent=4, sort_keys=True)
        dc4_file.write(dc4_docs)


with open('SC9-nodes_pulled.json', 'w+') as sc9_file:
    for doc in db2.nodes.find(projection=get_fields):
        sc9_docs = json.dumps(doc, indent=4, sort_keys=True)
        sc9_file.write(sc9_docs)

'active'
'collect'
'customer'
'deviceType'
'group'
'host'
'location'
'model'
'name'
'netType'
'nodeStatus'
'ping'
'roleType'
'serviceLevel'
'typeGroup'


  'bridgeport-vz-gw' => {
    'active' => 'true',
    'advanced_options' => undef,
    'authkey' => '',
    'authpassword' => '',
    'authprotocol' => 'md5',
    'businessService' => undef,
    'calls' => 'false',
    'cbqos' => 'none',
    'collect' => 'true',
    'community' => '0d71d56ae6',
    'customer' => 'Hearst Newspapers',
    'depend' => 'N/A',
    'deviceType' => 'MPLS Router',
    'extra_options' => undef,
    'group' => 'HNP Connecticut Post-Bridgeport',
    'host' => '167.173.204.2',
    'location' => 'Connecticut Post-Bridgeport',
    'max_msg_size' => '',
    'max_repetitions' => '',
    'model' => 'automatic',
    'name' => 'bridgeport-vz-gw',
    'netType' => 'wan',
    'nodeStatus' => 1,
    'notes' => '',
    'pciSite' => '',
    'ping' => 'true',
    'port' => '161',
    'privkey' => '',
    'privpassword' => '',
    'privprotocol' => 'des',
    'rancid' => 'false',
    'remote_connection_name' => '',
    'remote_connection_url' => '',
    'roleType' => 'distribution',
    'serviceLevel' => 'Gold',
    'serviceStatus' => 'Development',
    'service_management' => undef,
    'services' => undef,
    'source' => 'Service Now',
    'threshold' => 'true',
    'timezone' => 0,
    'typeGroup' => 'Network Core Infrastructure',
    'username' => '',
    'uuid' => 'e339dc542b5442402ac31c1c17da1564',
    'version' => 'snmpv2c',
    'webserver' => 'false'
  },
  'bristanetrtr01' => {
    'active' => 'true',
    'calls' => 'false',
    'cbqos' => 'none',
    'collect' => 'true',
    'community' => '0d71d56ae6',
    'customer' => 'Hearst Newspapers',
    'depend' => 'N/A',
    'deviceType' => 'Router',
    'group' => 'HNP Connecticut Post-Bridgeport',
    'host' => '10.220.0.98',
    'location' => 'Connecticut Post-Bridgeport',
    'model' => 'automatic',
    'name' => 'bristanetrtr01',
    'netType' => 'wan',
    'nodeStatus' => 1,
    'ping' => 'true',
    'port' => '161',
    'roleType' => 'access',
    'serviceLevel' => 'Gold',
    'services' => undef,
    'source' => 'Service Now',
    'threshold' => 'true',
    'timezone' => 0,
    'typeGroup' => 'Network Core Infrastructure',
    'uuid' => 'caf82aaf2bcaf5001c40fcd019da1510',
    'version' => 'snmpv2c',
    'webserver' => 'false'
  },
