module uim.orm.exceptions.missingtableclass;

import uim.orm;

@safe:

// Exception raised when a Table could not be found.
class MissingTableClassException : DORMException {
	mixin(ExceptionThis!("MissingTableClass"));

	override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) {
			return false;
		}

		this
			.messageTemplate("Table class %s could not be found.");

		return true;
	}
}

mixin(ExceptionCalls!("MissingTableClass"));		
