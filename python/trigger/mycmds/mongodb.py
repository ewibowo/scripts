#!/Users/rlaney/.virtualenvs/NetEngineerONE/bin/python

from pymongo import MongoClient

host = 'localhost'
port = 27017
database = 'trigger'
table_name = 'netdevices'

def get_data(self, host, port, database, table_name):
    client = MongoClient(host, port)
    collection = client[database][table_name]
    data = []
    for device in collection.find():
        data.append(device)
    print(data)

def load_data_source(self, **kwargs):
    host = kwargs.get('host')
    port = kwargs.get('port')
    database = kwargs.get('database')
    table_name = kwargs.get('table_name')
    try:
        print( self.get_data(host, port, database, table_name) )
    except Exception as err:
        raise LoaderFailed("Tried %r; and failed: %r" % (database, err))
