#!/bin/sh

mongo
use nmis
db.auth("opUserRW","op42flow42");
db.getCollectionNames()
db.endpoints.count()
