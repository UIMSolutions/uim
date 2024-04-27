/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.interfaces.invalidproperty;

import uim.datasources;

@safe:

// Describes the methods that any class representing a data storage should comply with.
interface IInvalidProperty {
    // Get a list of invalid fields and their data for errors upon validation/patching
    Json[string] invalidFields();

    // Set fields as invalid and not patchable into the entity.
    void setFieldsInvalid(Json[string] fields, bool canOverwrite = false);

    // Get a single value of an invalid field. Returns null if not set.
    Json invalidField(string fieldName) ;

    // Sets a field as invalid and not patchable into the entity.
    void setInvalidField(string fieldName, Json aValue);
}
