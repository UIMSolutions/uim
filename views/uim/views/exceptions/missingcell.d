module uim.views.exceptions.missingcell;

import uim.views;

@safe:

// Used when a cell class file cannot be found.
class MissingCellException : DViewException {
	mixin(ExceptionThis!("MissingCellException"));

    override bool initialize(IData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
		this
			.messageTemplate("Cell class %s is missing.");

		return true;
	}
}
mixin(ExceptionCalls!("MissingCellException"));
