module uim.consoles.exceptions.missinghelper;

import uim.consoles;

@safe:

// Used when a Helper cannot be found.
class MissingHelperException : ConsoleException {
	mixin(ExceptionThis!("MissingHelperException"));
	
	override void initialize(Json configSettings = Json(null)) {
		super.initialize(configSettings);

		this
			.messageTemplate("Helper class '%s' could not be found.");
	}
}
