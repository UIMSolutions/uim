/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.exceptions.missingmodel;

@safe:
import uim.datasources;

// Used when a model cannot be found.
class DDSOMissingModelException : DDatasourcesException {
	mixin(ExceptionThis!("DSOMissingModel"));

    override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		this
			.messageTemplate("Model class '%s' of type '%s' could not be found.");

		return true;
	}
}
mixin(ExceptionCalls!("DSOMissingModel"));
