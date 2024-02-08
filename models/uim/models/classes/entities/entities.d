/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.entities.entities;

import uim.models;

@safe:
class DOOPEntities {
  this() {}

  private DEntity[] _items;

  DEntity[] all() {
    return _items.dup;
  }

  O add(this O)(DEntity[] newEntities) {
    _items ~= newEntities.dup;
    return cast(O)this;
  }

  O set(this O)(DEntity[] newEntities) {
    _items = newEntities.dup;
    return cast(O)this;
  }

  bool notEmpty() {
    return (_items.length > 0);
  }

  O sort(this O)(string sortBy, string sortDir = "") {
    if (this.sortBy) {
      if (this.sortDir.toLower == "up") {
        _items = _items
          .sort!((a, b) => a[sortBy]< b[sortBy]).array;
      }
      else {
        _items = _items
          .sort!((a, b) => a[sortBy] > b[sortBy]).array;
      }
    }
    return cast(O)this;
  }

  O filter(this O)(string filterBy, string filterValue) {
    if (this.filterBy && this.filterValue) {
      _items = _items
        .filter!(entity => entity[filterBy].indexOf(this.filterValue) == 0).array;
    }
    return cast(O)this;
  }

  O opCall(this O)(DEntity[] newEntities) {
    this.set(newEntities);
    return cast(O)this;
  }
}

/* version(test_uim_models) { unittest {
    assert(OOPEntities);
}} */

Json toJson(DEntity[] someEntities) {
  Json result = Json.emptyArray;

  someEntities.each!(e => result ~= e.toJson);
  
  return result;
}