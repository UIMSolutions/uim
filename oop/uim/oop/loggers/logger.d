module uim.oop.loggers.logger;

import uim.oop;

@safe:

class DLogger : UIMObject, ILogger {
    mixin(LoggerThis!(""));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration.updateDefaults([
            "levels": Json.emptyArray,
            "scopes": Json.emptyArray,
            "formatter": StandardLogFormatter.classname.toJson
        ]);

        if (configuration.hasKey("scopes")) {
           configuration.set("scopes", configuration.getArray("scopes"));
        }
        configuration.set("levels", configuration.getArray("levels"));

        if (configuration.hasKey("types") && configuration.get("levels").isEmpty) {
           configuration.get("levels", configuration.get("types").toArray);
        }

        auto formatter = configuration.getString("formatter", StandardLogFormatter.classname);
        if (!isObject(formatter)) {
            if (isArray(formatter)) {
                classname = formatter["classname"];
                options = formatter;
            } else {
                classname = formatter;
                auto options = null;
            }
            formatter = new classname(options);
        }
        _formatter = formatter; 

        return true;
    }

    protected ILogFormatter _formatter;

    // Get the levels this logger is interested in.
    string[] levels() {
        return configuration.getStringArray("levels");
    }

    // Get the scopes this logger is interested in.
    string[] scopes() {
        return configuration.getStringArray("scopes");
    }
}
