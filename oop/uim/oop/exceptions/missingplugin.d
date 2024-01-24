/*********************************************************************************************************
	Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.exceptions.missingplugin;

import uim.oop;
@safe:

// Exception raised when a plugin could not be found
class DMissingPluginException : UimException {
	mixin(ExceptionThis!("MissingPluginException"));

	override bool initialize(IConfigData[string] configData = null) {
		super.initialize(configSettings);
		
		this
			.messageTemplate("Plugin %s could not be found.");
	}
}
mixin(ExceptionCalls!("MissingPluginException"));
