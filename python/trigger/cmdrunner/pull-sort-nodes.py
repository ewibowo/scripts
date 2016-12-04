#!/usr/local/bin/python

from pymongo import MongoClient
from pprint import pprint
import json

'''
Usage example:
>>> from pymongo import MongoClient
>>> client = MongoClient('example.com')
>>> db = client.the_database
>>> db.authenticate('user', 'password', source='source_database')

Using the authSource URI:
>>> uri = "mongodb://user:password@example.com/?authSource=source_database"
>>> db = MongoClient(uri).the_database

MongoDB Servers
het001sclopk004.companynet.org = 10.70.0.34/24
het001stropk004.companynet.org = 10.72.0.34/24
The user account for mongodB is the same on all servers -
dB names: nmis, optrend
username:  opUserRW
password: op42flow42
'''

uri1 = 'mongodb://opUserRW:op42flow42@dc4-mongo/?authSource=admin'
con1 = MongoClient(uri1)
db1 = con1.nmis

uri2 = 'mongodb://opUserRW:op42flow42@sc9-mongo/?authSource=admin'
con2 = MongoClient(uri2)
db2 = con2.nmis
get_fields = {
              "_id": 1, "sysName": 1, "uuid": 1, "location": 1, "name": 1,
              "nodeType": 1, "nodeVendor": 1, "sysLocation": 1, "group": 1,
              "host": 1, "nodeModel": 1, "os_info": 1, "deviceType": 1,
              "typeGroup": 1, "customer": 1, "active": 1
              }

all_docs = set()

with open('All-nodes_pulled.json', 'w+') as all_file:
    for doc in db1.nodes.find(projection=get_fields):
        dc4_docs = json.dumps(doc, indent=4, sort_keys=True)
        all_docs.add(dc4_docs)

    for doc in db2.nodes.find(projection=get_fields):
        sc9_docs = json.dumps(doc, indent=4, sort_keys=True)
        all_docs.add(sc9_docs)

    for doc in all_docs:
        all_file.write(doc)
