/*********************************************************************************************************
	Copyright: © 2015-2025 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.exceptions.missingdatasource;

import uim.datasources;

@safe:
// Used when a datasource cannot be found.
class DDSOMissingDatasourceException : DDatasourcesException {
	mixin(ExceptionThis!("DSOMissingDatasource"));

    override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		this
			.messageTemplate("Datasource class %s could not be found. %s");

		return true;
	}
}
mixin(ExceptionCalls!("DSOMissingDatasource"));
