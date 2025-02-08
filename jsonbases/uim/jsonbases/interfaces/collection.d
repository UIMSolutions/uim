/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.interfaces.collection;

import uim.jsonbases;

@safe:
interface IJsonCollection : INamed {  
  // #region READ
    // #region findMany()
      Json[] findMany(bool allVersions = false);
      Json[] findMany(UUID[] ids, bool allVersions = false);
      Json[] findMany(UUID id, bool allVersions = false);
      Json[] findMany(UUID[] ids, size_t versionNumber);

      Json[] findMany(string[string][] selects, bool allVersions = false);
      Json[] findMany(string[string] select, bool allVersions = false);
      Json[] findMany(Json[] selects, bool allVersions = false);
      Json[] findMany(Json select, bool allVersions = false);
    // #endregion findMany() 

    // #region findOne()
      Json findOne(UUID[] ids, bool allVersions = false);
      Json findOne(UUID id, bool allVersions = false);
      Json findOne(UUID[] ids, size_t versionNumber);
      Json findOne(UUID id, size_t versionNumber);

      Json findOne(string[string][] selects, bool allVersions = false);
      Json findOne(string[string] select, bool allVersions = false);
      Json findOne(Json[] selects, bool allVersions = false);
      Json findOne(Json select, bool allVersions = false);
    // #endregion findOne()
  // #endregion READ                            

  // #region UPDATE
    // #region updateMany()
      size_t updateMany(string[string] select, string[string] updateData);
      size_t updateMany(string[string] select, Json updateData);
      
      size_t updateMany(Json select, string[string] updateData);
      size_t updateMany(Json select, Json updateData);
    // #endregion updateMany()

    // #region updateOne()
      bool updateOne(string[string] select, string[string] updateData);
      bool updateOne(string[string] select, Json updateData);
      bool updateOne(Json select, string[string] updateData);
      abstract bool updateOne(Json select, Json updateData);
    // #endregion updateOne()
  // #endregion UPDATE                                                                 
}                                                                                                                                                                                                               