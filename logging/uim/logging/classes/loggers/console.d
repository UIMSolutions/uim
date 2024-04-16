 module uim.logging.classes.loggers.console;

import uim.logging;

@safe:

/**
 * Console logging. Writes logs to console output.
 */
class DConsoleLog { /* }: BaseLog {
    /* configuration.updateDefaults([
        "stream": "php://stderr",
        "levels": null,
        "scopes": ArrayData,
        "outputAs": null,
        "formatter": [
            "className": DefaultFormatter.classname,
            "includeTags": BooleanData(true),
        ],
    ];

    // Output stream
    protected IConsoleOutput _output;

    /**
     * Constructs a new DConsole Logger.
     *
     * Config
     *
     * - `levels` string or array, levels the engine is interested in
     * - `scopes` string or array, scopes the engine is interested in
     * - `stream` the path to save logs on.
     * - `outputAs` integer or ConsoleOutput.[RAW|PLAIN|COLOR]
     * - `dateFormat` PHP date() format.
     *
     * configData - Options for the FileLog, see above.
     * @throws \InvalidArgumentException
     * /
    this(IData[string] configData = null) {
        super(configData);

        configData = configuration;
        if (cast(DConsoleOutput)configuration.get("stream"]) {
           _output = configuration.get("stream"];
        }  else if (isString(configuration.get("stream"])) {
           _output = new DConsoleOutput(configuration.get("stream"]);
        } else {
            throw new DInvalidArgumentException("`stream` not a ConsoleOutput nor string");
        }
        if (isSet(configuration.get("outputAs"])) {
           _output.setOutputAs(configuration.get("outputAs"]);
        }
    }
    
    /**
     * : writing to console.
     * Params:
     * IData level The severity level of log you are making.
     * @param \string messageToLog The message you want to log.
     * @param array context Additional information about the logged message
     * /
    void log(logLevel, string messageToLog, IData context = null) {
        string resultMessage = this.interpolate(messageToLog, context);
       _output.write(this.formatter.format(logLevel, resultMessage, context));
    } */
}
