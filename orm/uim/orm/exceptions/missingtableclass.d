module uim.orm.exceptions.missingtableclass;

import uim.orm;

@safe:

// Exception raised when a Table could not be found.
class DMissingTableClassException : DORMException {
	mixin(ExceptionThis!("MissingTableClass"));

	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) {
			return false;
		}

		this
			.messageTemplate("Table class %s could not be found.");

		return true;
	}
}

mixin(ExceptionCalls!("MissingTableClass"));		
