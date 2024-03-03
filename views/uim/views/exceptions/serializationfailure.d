module uim.views.exceptions.serializationfailure;

import uim.views;

@safe:

// Used when a SerializedView class fails to serialize data.
class DSerializationFailureException : DViewException {
    mixin(ExceptionThis!("SerializationFailure"));

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}
mixin(ExceptionCalls!("SerializationFailure"));

