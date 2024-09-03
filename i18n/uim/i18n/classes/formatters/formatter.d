module uim.i18n.classes.formatters.formatter;

import uim.i18n;

@safe:

// A formatter that will interpolate variables using the MessageFormatter class
class DI18NFormatter : UIMObject, II18NFormatter {
    this() {
        initialize;
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
    
    // Returns a string with all passed variables interpolated into the original message. 
    string format(string messageLocale, string messageToTranslate, string[] tokenValues) {
        return messageToTranslate;
    }
}
