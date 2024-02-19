/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.exceptions.pageoutofbounds;

import uim.datasources;

@safe:
// Exception raised when requested page number does not exist.
class PageOutOfBoundsException : DatasourceException {
	mixin(ExceptionThis!("DSOPageOutOfBoundsException"));

    override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
		this
			.messageTemplate("Page number %s could not be found.");

		return true;
	}
}
mixin(ExceptionCalls!("DDSOPageOutOfBoundsException"));