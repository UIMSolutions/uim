/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.exceptions.rolledbacktransaction;

import uim.orm;

@safe:

// Used when a transaction was rolled back from a callback event.
class DRolledbackTransactionException : DORMException {
	mixin(ExceptionThis!("RolledbackTransaction"));

	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(configData)) {
			return false;
		}

		this
			.messageTemplate("The afterSave event in '%s' is aborting the transaction before the save process is done.");

		return true;
	}
}
mixin(ExceptionCalls!("RolledbackTransaction"));	