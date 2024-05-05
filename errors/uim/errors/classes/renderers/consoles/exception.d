module uim.errors.classes.renderers.consoles.exception;

import uim.errors;

@safe:

/**
 * Plain text exception rendering with a stack trace.
 *
 * Useful in CI or plain text environments.
 */
class DConsoleExceptionRenderer { // }: IExceptionRenderer {
    /* 
    private Throwable error;

    /**
     * @var \UIM\Console\ConsoleOutput
     * /
    private ConsoleOutput output;

    /**
     * @var bool
     * /
    private bool trace;

    /**
     * Constructor.
     * Params:
     * \Throwable error The error to render.
     * @param \Psr\Http\Message\IServerRequest|null request Not used.
     * @param Json[string] configData Error handling configuration.
     * /
    this(Throwable error, ?IServerRequest serverRequest, Json[string] configData) {
        this.error = error;
        this.output = configData("stderr"] ?? new DConsoleOutput("D://stderr");
        this.trace = configData("trace"] ?? true;
    }
    
    // Render an exception into a plain text message.
    string render() {
        exceptions = [this.error];
        previous = this.error.getPrevious();
        while (!previous.isNull) {
            exceptions ~= previous;
            previous = previous.getPrevious();
        }

        string[] results;
        foreach (anI: error; exceptions) {
            parent = anI > 0 ? exceptions[anI - 1] : null;
            results = chain(result, this.renderException(error, parent));
        }
        return results.join("\n");
    }
    
    /**
     * Render an individual exception
     * Params:
     * \Throwable exception The exception to render.
     * @param ?\Throwable parent The Exception index in the chain
     * /
    // TODO protected Json[string] renderException(Throwable exception, Throwable parent) {
        auto result = [
                "<error>%s[%s] %s</error> in %s on line %s"
                .format(
                    parent ? "Caused by " : "",
                    exception.classname,
                    exception.getMessage(),
                    exception.getFile(),
                    exception.getLine()
                ),
        ];

        debug = Configuration.read("debug");
        if (debug && cast(UimException)exception) {
            attributes = exception.getAttributes();
            if (attributes) {
                result ~= "";
                result ~= "<info>Exception Attributes</info>";
                result ~= "";
                result ~= var_export(exception.getAttributes(), true);
            }
        }
        if (this.trace) {
            stacktrace = Debugger.getUniqueFrames(exception, parent);
            result ~= "";
            result ~= "<info>Stack Trace:</info>";
            result ~= "";
            result ~= Debugger.formatTrace(stacktrace, ["format": "text"]);
            result ~= "";
        }
        return result;
    }
    
    /**
     * Write output to the output stream
     * Params:
     * \Psr\Http\Message\IResponse|string aoutput The output to print.
     * /
    void write(IResponse|string aoutput) {
        if (isString(output)) {
            this.output.write(output);
        }
    } */
}
