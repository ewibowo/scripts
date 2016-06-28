
// JavaScript function to shutdown the server
var shut = function() { 
  db = db.getSiblingDB('admin')
  db.shutdownServer();
  print("Server has been shutdown");
}; 
