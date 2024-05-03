/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes;

import uim.models;
@safe:

public { 
	import uim.models.classes.attributes.attribute;
	import uim.models.classes.attributes.factory;
	import uim.models.classes.attributes.registry; 
}

public { 
	// import uim.models.classes.attributes.lookups;
	// import uim.models.classes.attributes.codes;
}

public { 
	// import uim.models.classes.attributes.arrays;
	// import uim.models.classes.attributes.booleans;
	// import uim.models.classes.attributes.bytes;
	// import uim.models.classes.attributes.chars;
	// import uim.models.classes.attributes.dates;
	// import uim.models.classes.attributes.datetimes;
	// import uim.models.classes.attributes.decimals;
	// import uim.models.classes.attributes.doubles;
	// import uim.models.classes.attributes.elements;
	// import uim.models.classes.attributes.entities;
	// import uim.models.classes.attributes.integers;
	// import uim.models.classes.attributes.strings;
	// import uim.models.classes.attributes.ulongs;
	// import uim.models.classes.attributes.uuids;
}


void testAttribute(IAttribute attribute) {
  assert(attribute);
}

/* static this() {
  AttributeRegistry
    // Booleans
    .register(BooleanAttribute)
    // Bytes
    .register(BinaryAttribute)
    .register(ByteAttribute)
    // Chars
    .register(CharAttribute)
    // Chars -> Strings
    .register(AddressLineAttribute)
    .register(AttributeNameAttribute)
    .register(CityNameAttribute)
    .register(ColorNameAttribute)
    .register(CompanyNameAttribute)
    .register(CountryAttribute)
    .register(CountyAttribute)
    .register(LanguageTagAttribute)
    .register(LastNameAttribute)
    .register(LinkAttribute)
    .register(ListAttribute)
    .register(StringAttribute)
    .register(UrlAttribute)
    // Dates
    .register(DateAttribute)
    // DateTimes
    .register(BirthDateAttribute)
    .register(DatetimeAttribute)
    .register(TimeAttribute);
    // Decimals
}*/ 

/* version(test_uim_models) { unittest {
    writeln(AttributeRegistry["boolean"].name);
    writeln(AttributeRegistry["byte"].name);
    writeln(AttributeRegistry["binary"].name);

    writeln(AttributeRegistry.paths);
  }
} */
