/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.Exception;

@safe:
import uim.orm;

// Used when a behavior cannot be found.
class MissingBehaviorException : UIMException {
    protected string _messageTemplate = "Behavior class %s could not be found.";
}
