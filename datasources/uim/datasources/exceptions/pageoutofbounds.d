/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.exceptions.pageoutofbounds;

import uim.datasources;

@safe:
// Exception raised when requested page number does not exist.
class DPageOutOfBoundsException : DDatasourcesException {
	mixin(ExceptionThis!("PageOutOfBounds"));

    override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		this
			.messageTemplate("Page number %s could not be found.");

		return true;
	}
}
mixin(ExceptionCalls!("PageOutOfBounds"));