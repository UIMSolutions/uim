/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.exceptions.missingdatasourceconfig;

import uim.datasources;

@safe:
// Exception class to be thrown when a datasource configuration is not found
class DDSOMissingDatasourceConfigException : DDatasourcesException {
	mixin(ExceptionThis!("DSOMissingDatasourceConfig"));

    override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		this
			.messageTemplate("The datasource configuration '%s' was not found.");

		return true;
	}
}
mixin(ExceptionCalls!("DSOMissingDatasourceConfig"));
