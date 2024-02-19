/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/module uim.orm.Exception;
import uim.orm;

@safe:

// Exception raised when an Entity could not be found.
class MissingEntityException : UIMException {
    protected _messageTemplate = "Entity class %s could not be found.";
}
