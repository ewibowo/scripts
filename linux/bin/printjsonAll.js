
cursor = db.collection.find();
while ( cursor.hasNext() ) {
   printjson( cursor.next() );
}
