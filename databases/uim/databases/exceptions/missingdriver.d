/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.databases.exceptions.missingdriver;

@safe:
import uim.databases;

// Class MissingDriverException
class MissingDriverException : DDatabaseException {
    // TODO protected _messageTemplate = "Could not find driver `%s` for connection `%s`.";
}
