/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.orm.exceptions.missingentity;

import uim.orm;

@safe:

// Exception raised when an Entity could not be found.
class DMissingEntityException : DORMException {
	mixin(ExceptionThis!("MissingEntity"));

	override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) {
			return false;
		}

		this
			.messageTemplate("Entity class %s could not be found.");

		return true;
	}
}

mixin(ExceptionCalls!("MissingEntity"));
