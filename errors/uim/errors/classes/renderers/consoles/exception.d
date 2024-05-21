module uim.errors.classes.renderers.consoles.exception;

import uim.errors;

@safe:

/**
 * Plain text exception rendering with a stack trace.
 *
 * Useful in CI or plain text environments.
 */
class DConsoleExceptionRenderer { // }: IExceptionRenderer {
    private Throwable _error;

    private ConsoleOutput _output;

    private bool _trace;

    this(DThrowable errorToRender, IServerRequest serverRequest, Json[string] errorHandlingData) {
        this.error = error;
        this.output = configuration.get("stderr") ?? new DConsoleOutput("D://stderr");
        this.trace = configuration.get("trace") ?? true;
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
    
    // Render an individual exception
    protected Json[string] renderException(Throwable exceptionToRender, Throwable parentException) {
        auto result = [
                "<error>%s[%s] %s</error> in %s on line %s"
                .format(
                    parent ? "Caused by " : "",
                    exceptionToRender.classname,
                    exceptionToRender.getMessage(),
                    exceptionToRender.getFile(),
                    exceptionToRender.getLine()
                ),
        ];

        debug = configuration.get("debug");
        if (debug && cast(UimException)exceptionToRender) {
            attributes = exceptionToRender.getAttributes();
            if (attributes) {
                result ~= "";
                result ~= "<info>Exception Attributes</info>";
                result ~= "";
                result ~= var_export_(exceptionToRender.getAttributes(), true);
            }
        }
        if (this.trace) {
            stacktrace = Debugger.getUniqueFrames(exceptionToRender, parentException);
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
     */
    // TODO void write(IResponse aoutput) {
    void write(string outputText) {
        _output.write(outputText);
    } */
}
