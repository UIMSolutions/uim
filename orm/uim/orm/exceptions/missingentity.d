/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.exceptions.missingentity;
import uim.orm;

@safe:

// Exception raised when an Entity could not be found.
class DMissingEntityException : DORMException {
	mixin(ExceptionThis!("MissingEntity"));

	override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) {
			return false;
		}

		this
			.messageTemplate("Entity class %s could not be found.");

		return true;
	}
}

mixin(ExceptionCalls!("MissingEntity"));
