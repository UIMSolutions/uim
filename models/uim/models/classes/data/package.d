/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data;

import uim.models;
@safe:

public { 
	import uim.models.classes.data.data;
	import uim.models.classes.data.map;
}

// Packages
public { 
	import uim.models.classes.data.arrays;
	import uim.models.classes.data.datetimes;
	import uim.models.classes.data.elements;
	import uim.models.classes.data.lookups;
	import uim.models.classes.data.maps;
	import uim.models.classes.data.scalars;
	import uim.models.classes.data.uuids;
}

// Modules
public { 
	import uim.models.classes.data.entity;
	import uim.models.classes.data.null_;
	import uim.models.classes.data.json;
}

template DataThis(string name, string datatype = null) { // Name for future releases
  const char[] DataThis = `  
    this() { super(); }
    this(DAttribute theAttribute) { this().attribute(theAttribute); }
    this(string theValue) { this().set(theValue); }
    this(Json theValue) { this().set(theValue); }
    this(DAttribute theAttribute, string theValue) { this(theAttribute).set(theValue); }
    this(DAttribute theAttribute, Json theValue) { this(theAttribute).set(theValue); }`~
    (datatype ? 
    ` this(`~datatype~` theValue) { this().set(theValue); }
      this(DAttribute theAttribute, `~datatype~` theValue) { this(theAttribute).set(theValue); }`
      : "");
}

template DataCalls(string name, string datatype = null) {
  const char[] DataCalls = `  
    auto `~name~`() { return new D`~name~`; }
    auto `~name~`(DAttribute theAttribute) { return new D`~name~`(theAttribute); }
    auto `~name~`(string theValue) { return new D`~name~`(theValue); }
    auto `~name~`(Json theValue) { return new D`~name~`(theValue); }
    auto `~name~`(DAttribute theAttribute, string theValue) { return new D`~name~`(theAttribute, theValue); }
    auto `~name~`(DAttribute theAttribute, Json theValue) { return new D`~name~`(theAttribute, theValue); }
  `~
  (datatype ? 
  ` auto `~name~`(`~datatype~` theValue) { return new D`~name~`(theValue); }
    auto `~name~`(DAttribute theAttribute, `~datatype~` theValue) { return new D`~name~`(theAttribute, theValue); }`
    : "");
}

/* template DataProperty!(string name) {
  const char[] EntityCalls = `
    auto `~name~`() { return this.values[`~name~`]; } 
    void `~name~`(string newValue) { this.values[`~name~`].set(newValue);  } 
    void `~name~`(Json newValue) { this.values[`~name~`].set(newValue);   } 
  `;
} */
