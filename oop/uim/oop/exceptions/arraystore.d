/*********************************************************************************************************
	Copyright: © 2015 -2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.exceptions.arraystore;

import uim.oop;

@safe:

// Thrown to indicate that an attempt has been made to store the wrong type of object into an array of objects.
class DArrayStoreException : UimException {  
	mixin(ExceptionThis!("ArrayStoreException"));
}
mixin(ExceptionCalls!("ArrayStoreException"));
