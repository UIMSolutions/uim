module uim.views.exceptions.missingcell;

import uim.views;

@safe:

// Used when a cell class file cannot be found.
class DMissingCellException : DViewException {
	mixin(ExceptionThis!("MissingCell"));

    override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		this
			.messageTemplate("Cell class %s is missing.");

		return true;
	}
}
mixin(ExceptionCalls!("MissingCell"));
