module uim.jsonbases.interfaces.collection;

import uim.jsonbases;

@safe:
interface IJsonCollection {  
  string name();

  // #region READ
    // #region findMany()
      Json[] findMany(bool allVersions = false);
      Json[] findMany(UUID[] ids, bool allVersions = false);
      Json[] findMany(UUID id, bool allVersions = false);
      Json[] findMany(UUID[] ids, size_t versionNumber);

      Json[] findMany(STRINGAA[] selects, bool allVersions = false);
      Json[] findMany(STRINGAA select, bool allVersions = false);
      Json[] findMany(Json[] selects, bool allVersions = false);
      Json[] findMany(Json select, bool allVersions = false);
    // #endregion findMany() 

    // #region findOne()
      Json findOne(UUID[] ids, bool allVersions = false);
      Json findOne(UUID id, bool allVersions = false);
      Json findOne(UUID[] ids, size_t versionNumber);
      Json findOne(UUID id, size_t versionNumber);

      Json findOne(STRINGAA[] selects, bool allVersions = false);
      Json findOne(STRINGAA select, bool allVersions = false);
      Json findOne(Json[] selects, bool allVersions = false);
      Json findOne(Json select, bool allVersions = false);
    // #endregion findOne()
  // #endregion READ                            

  // #region UPDATE
    // #region updateMany()
      size_t updateMany(STRINGAA select, STRINGAA updateData);
      size_t updateMany(STRINGAA select, Json updateData);
      
      size_t updateMany(Json select, STRINGAA updateData);
      size_t updateMany(Json select, Json updateData);
    // #endregion updateMany()

    // #region updateOne()
      bool updateOne(STRINGAA select, STRINGAA updateData);
      bool updateOne(STRINGAA select, Json updateData);
      bool updateOne(Json select, STRINGAA updateData);
      abstract bool updateOne(Json select, Json updateData);
    // #endregion updateOne()
  // #endregion UPDATE                                                                 
}                                                                                                                                                                                                               