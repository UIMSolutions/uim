module uim.jsonbase.interfaces.collectionmanager;

import uim.jsonbase;

@safe:
interface IJsonCollectionManager {  
  // Collections
  bool hasCollections(string[] someNames...); 
  bool hasCollections(string[] someNames = null); 
  size_t countCollections(string[] someNames...); 
  size_t countCollections(string[] someNames = null); 
  string[] existingCollections(string[] someNames...); 
  string[] existingCollections(string[] someNames = null); 
  string[] collectionNames(); 
  IJsonCollection[] collections(); 

  // Collection
  bool hasCollection(string aName); 
  IJsonCollection collection(string aName); 

  // Add collections
  bool addCollections(IJsonCollection[] someCollections...); 
  bool addCollections(IJsonCollection[] someCollections); 
  bool addCollections(IJsonCollection[string] someCollections); 

  // Add collection
  bool addCollection(IJsonCollection aCollection); 
  bool addCollection(string aName, IJsonCollection aCollection); 

  // Create Collections
  IJsonCollection[] createCollections(string[] someNames...); 
  IJsonCollection[] createCollections(string[] someNames); 

  IJsonCollection createCollection(string aName); 

  // Delete
  bool deleteCollections(string[] someNames...); 
  bool deleteCollections(string[] someNames);

  bool deleteCollection(string aName); 
}