/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.databases.exceptions.missingextension;

@safe:
import uim.databases;

class MissingExtensionException : DDatabaseException {
    // TODO protected _messageTemplate = "Database driver %s cannot be used due to a missing extension or unmet dependency. Requested by connection '%s'";
}
