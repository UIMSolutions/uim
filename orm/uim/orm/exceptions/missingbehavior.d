/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.exceptions.missingbehavior;

import uim.orm;
@safe:

// Used when a behavior cannot be found.
class DMissingBehaviorException : DORMException {
	mixin(ExceptionThis!("MissingBehavior"));

	override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) {
			return false;
		}

		this
			.messageTemplate("Behavior class %s could not be found.");

		return true;
	}
}
mixin(ExceptionCalls!("MissingBehavior"));
