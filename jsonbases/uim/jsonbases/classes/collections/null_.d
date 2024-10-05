/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.classes.collections.null_;

import uim.jsonbases;

unittest {
    version (testUimJsonbase) {
        debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }
}

@safe:
class DNullJsonCollection : DJsonCollection {
    mixin(JsonCollectionThis!("Null"));

    // #region FindMany
    alias findMany = DJsonCollection.findMany;
    /// Find all (many) items in a collection. allVersions:false = find last versions, allVersion:true = find all versions
    override Json[] findMany(bool allVersions = false) {
        return null;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            // Results always null / []
            assert(!col.findMany);
            assert(!col.findMany(true));
        }
    }

    /// Find all (many) items in a collection with id. allVersions:false = find last version, allVersion:true = find all versions
    override Json[] findMany(UUID id, bool allVersions = false) {
        return null;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(!col.findMany(randomUUID));
            assert(!col.findMany(randomUUID, true));
            // TODO 
        }
    }

    override Json[] findMany(string[string] select, bool allVersions = false) {
        return null;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(!col.findMany(["name": "aName"]));
            assert(!col.findMany(["name": "aName"], true));
            // TODO 
        }
    }

    override Json[] findMany(Json select, bool allVersions = false) {
        return null;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(!col.findMany(toJson(["name": "aName"])));
            assert(!col.findMany(toJson(["name": "aName"]), true));
            // TODO 
        }
    }
    // #endregion findMany

    // #region findOne
    alias findOne = DJsonCollection.findOne;
    override Json findOne(UUID id, bool allVersions = false) {
        return Json(null);
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.findOne(randomUUID).isEmpty);
            assert(col.findOne(randomUUID, true).isEmpty);
            // TODO 
        }
    }

    override Json findOne(UUID id, size_t versionNumber) {
        return Json(null);
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.findOne(randomUUID, 1).isEmpty);
            // TODO 
        }
    }

    override Json findOne(string[string] select, bool allVersions = false) {
        return Json(null);
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.findOne(["name": "aName"]).isEmpty);
            assert(col.findOne(["name": "aName"], true).isEmpty);
            // TODO 
        }
    }

    override Json findOne(Json select, bool allVersions = false) {
        return Json(null);
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.findOne(toJson(["name": "aName"])).isEmpty);
            assert(col.findOne(toJson(["name": "aName"]), true).isEmpty);
            // TODO 
        }
    }
    // #endregion findOne

    // #region insertOne
    override Json insertOne(Json newData) {
        return findOne(newData);
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.insertOne(toJson(["name": "aName"])).isEmpty);
            // TODO 
        }
    }
    // #endregion insertOne

    // #region updateMany
    override size_t updateMany(Json select, Json updateData) {
        return 0;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.updateMany(toJson(["id": randomUUID.toString]), toJson([
                        "name": "aName"
                    ])) == 0);
            // TODO
        }
    }
    // #endregion updateMany

    // #region updateOne
    override bool updateOne(Json select, Json updateData) {
        return false;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.updateOne(toJson(["id": randomUUID.toString]), toJson([
                        "name": "aName"
                    ])) == 0);
            // TODO
        }
    }
    // #endregion updateOne

    // #region removeMany
    /// Remove items from collections
    alias removeMany = DJsonCollection.removeMany;
    /// Remove items from collectionsby it. allVersions:false - remove lastVersion, allVersion:true / allVersions (complete)
    override size_t removeMany(UUID id, bool allVersions = false) {
        return 0;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.removeMany(randomUUID) == 0);
            assert(col.removeMany(randomUUID, true) == 0);
            // TODO
        }
    }

    override size_t removeMany(string[string] select, bool allVersions = false) {
        return 0;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.removeMany(["name": "aName"]) == 0);
            assert(col.removeMany(["name": "aName"], true) == 0);
            // TODO
        }
    }

    override size_t removeMany(Json select, bool allVersions = false) {
        return 0;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(col.removeMany(toJson(["name": "aName"])) == 0);
            assert(col.removeMany(toJson(["name": "aName"]), true) == 0);
            // TODO
        }
    }
    // #endregion removeMany

    /// Remove one item or one version from collection
    alias removeOne = DJsonCollection.removeOne;
    /// Remove based on id - allVersions:true - remove all, remove lastVersion 
    override bool removeOne(UUID id, bool allVersions = false) {
        return false;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(!col.removeOne(randomUUID));
            assert(!col.removeOne(randomUUID, true));
            // TODO
        }
    }

    override bool removeOne(UUID id, size_t versionNumber) {
        return false;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(!col.removeOne(randomUUID, 1));
            // TODO
        }
    }

    override bool removeOne(string[string] select, bool allVersions = false) {
        return false;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(!col.removeOne(["name": "aName"]));
            assert(!col.removeOne(["name": "aName"], true));
            // TODO
        }
    }

    override bool removeOne(Json select, bool allVersions = false) {
        return false;
    }

    version (test_uim_jsonbase) {
        unittest {

            auto col = NullJsonCollection;
            assert(!col.removeOne(toJson(["name": "aName"])));
            assert(!col.removeOne(toJson(["name": "aName"]), true));
            // TODO
        }
    }
}

mixin(JsonCollectionCalls!("Null"));

unittest {
    version (testUimJsonbase) {
        debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }
}
