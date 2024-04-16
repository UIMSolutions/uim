module uim.datasources.exceptions.missingproperty;

import uim.datasources;

@safe:
// A required property does not exist for an entity.
class DDSOMissingPropertyException : DDatasourcesException {
	mixin(ExceptionThis!("DSOMissingProperty"));

    override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		this
			.messageTemplate("Property `%s` does not exist for the entity `%s`.");

		return true;
	}
}
mixin(ExceptionCalls!("DSOMissingProperty"));
