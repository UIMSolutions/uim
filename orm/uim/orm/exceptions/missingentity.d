/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.exceptions.missingentity;

import uim.orm;

@safe:

// Exception raised when an Entity could not be found.
class DMissingEntityException : DORMException {
	mixin(ExceptionThis!("MissingEntity"));

	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) {
			return false;
		}

		this
			.messageTemplate("Entity class %s could not be found.");

		return true;
	}
}

mixin(ExceptionCalls!("MissingEntity"));
