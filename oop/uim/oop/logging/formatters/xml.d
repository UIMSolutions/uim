module uim.oop.logging.formatters.xml;

import uim.oop;

@safe:

static this() {
    LogFormatterRegistry.register(XmlLogFormatter);
}

class DXmlLogFormatter : DLogFormatter {
    mixin(LogFormatterThis!("Xml"));
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    override string format(LogLevels logLevel, string logMessage, Json[string] logData = null) {
        string result = logMessage;
        // TODO
        return result;
    }
}

mixin(LogFormatterCalls!("Xml"));
