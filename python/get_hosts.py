#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from pymongo import MongoClient
from pprint import pprint
import json

'''
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
get_fields = {"_id": 0, "name": 1, "host": 1}
all_hosts = set()


with open('hosts', 'w') as host_file:
    for host in db1.nodes.find(projection=get_fields):
        dc4_hosts = (host['host'] + '\t\t\t' + host['name'])
        all_hosts.add(dc4_hosts)

    for host in db2.nodes.find(projection=get_fields):
        sc9_hosts = (host['host'] + '\t\t\t' + host['name'])
        all_hosts.add(sc9_hosts)

    for line in all_hosts:
        host_file.write(line + '\n')
#    for doc in all_docs:
#        all_file.write(doc + ',\n')
#        #all_file.write(',\n')
#    all_file.write(']')


#    with open('hosts_file', 'w+') as hosts_file:
#        for doc in all_docs:
#            ip = doc('host')
#            name = doc('name')
#            hosts_file.write(ip + '\t\t\t' + name + '\n')
