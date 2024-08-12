module uim.oop.logging.loggers.logger;

import uim.oop;

@safe:

class DLogger : UIMObject, ILogger {
    mixin(LoggerThis!(""));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("levels", Json.emptyArray)
            .setDefault("scopes", Json.emptyArray)
            .setDefault("formatter", StandardLogFormatter.classname);

        if (configuration.hasKey("scopes")) {
           configuration.set("scopes", configuration.getArray("scopes"));
        }
        configuration.set("levels", configuration.getArray("levels"));

        if (configuration.hasKey("types") && configuration.get("levels").isEmpty) {
           configuration.set("levels", configuration.get("types").toArray);
        }

        auto formatterClassName = configuration.getString("formatter", StandardLogFormatter.classname);
        _formatter = LogFormatterRegistry.create(formatterClassName);

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
