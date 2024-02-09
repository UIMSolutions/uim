/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.scalar;

import uim.models;

@safe:

class DScalarData : DData {
  this() {
    super();
  }

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    isScalar(true);

    return true;
  }

  override bool hasPath(string path, string separator = "/") {
    return false;
  }

  // #region key/keys
    override string[] keys() {
      return null;
    }

    alias hasKeys = DData.hasKeys;
    override bool hasKeys(string[] keys, bool deepSearch = false) {
      return false;
    }

    override bool hasKey(string key, bool deepSearch = false) {
      return false;
    }

    override bool hasKeys(string[]) {
      return false;
    }
  // #endregion key/keys

  // #region data
    // #region data()
      override IData[] data(string[] keys) {
        return null;
      }
      override IData data(string key) {
        return null;
      }
    // #endregion data()

    // #region hasData()
      override bool hasData(IData[string] checkData, bool deepSearch = false) {
        return false;
      }

      override bool hasData(IData[] data, bool deepSearch = false) {
        return false;
      }

      override bool hasData(IData data, bool deepSearch = false) {
        return false;
      }
    // #endregion hasData()
  // #endregion data

  override IData get(string key, IData defaultData) {
    return null;
  }
  override IData opIndex(string key) {
    return null;
  }

  // #region opEquals
    alias opEquals = Object.opEquals;
    override bool opEquals(string equalValue) {
      return (toString == equalValue);
    }

    override bool opEquals(IData equalValue) {
      return (toString == equalValue.toString);
    }
  // #endregion opEquals

  override IData[] values() {
    return null;
  }

  override ulong length() {
    return isNull ? 0 : 1;
  }
}

auto ScalarData() {
  return new DScalarData;
}
