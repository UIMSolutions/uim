/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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

  void add(DEntity[] newEntities) {
    _items ~= newEntities.dup;
    
  }

  void set(DEntity[] newEntities) {
    _items = newEntities.dup;
    
  }

  bool notEmpty() {
    return (_items.length > 0);
  }

  void sort(string sortBy, string sortDir = "") {
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
    
  }

  void filter(string filterBy, string filterValue) {
    if (this.filterBy && this.filterValue) {
      _items = _items
        .filter!(entity => entity[filterBy].indexOf(this.filterValue) == 0).array;
    }
    
  }

  void opCall(DEntity[] newEntities) {
    this.set(newEntities);
    
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