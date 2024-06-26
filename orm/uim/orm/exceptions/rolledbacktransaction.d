/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.orm.exceptions.rolledbacktransaction;

import uim.orm;

@safe:

// Used when a transaction was rolled back from a callback event.
class DRolledbackTransactionException : DORMException {
	mixin(ExceptionThis!("RolledbackTransaction"));

	override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) {
			return false;
		}

		this
			.messageTemplate("The afterSave event in '%s' is aborting the transaction before the save process is done.");

		return true;
	}
}
mixin(ExceptionCalls!("RolledbackTransaction"));	