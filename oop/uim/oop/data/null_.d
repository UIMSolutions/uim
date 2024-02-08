/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.data.null_;

import uim.oop;

class DNullData : DData {
  this() {
    super();
  }

  unittest {
    assert(NullData(myValue).value == null);
  }

  override Json toJson(string[] selectedKeys = null) {
    return Json(null);
  }

  override string toString() {
    return null;
  }
}

auto NullData() {
  return new DNullData;
}
