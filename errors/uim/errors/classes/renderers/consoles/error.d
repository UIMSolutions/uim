module uim.errors.classes.renderers.consoles.error;

import uim.errors;

@safe:

/*
 * Plain text error rendering with a stack trace.
 * Writes to STDERR via a UIM\Console\ConsoleOutput instance for console environments
 */
class DConsoleErrorRenderer { // }: IErrorRenderer {
    protected bool _trace = false;

    protected IConsoleOutput _output;

    this(Json[string] initData = null) {
        initialize(initData);
        // `stderr` - The ConsoleOutput instance to use. Defaults to `D://stderr`
        // `trace` - Whether or not stacktraces should be output.       _output = configuration.get("stderr", new DConsoleOutput("D://stderr"));
       _trace = configuration.getBool("trace", false);
    }
 
    void write(string outputText) {
       _output.write(outputText);
    }
    
    string render(UimError error, bool shouldDebug) {
        string trace = "";
        if (this.trace) {
            trace = "\n<info>Stack Trace:</info>\n\n" ~ error.getTraceAsString();
        }
        return "<error>%s: %s . %s</error> on line %s of %s%s"
            .format(
                error.getLabel(),
                error.code(),
                error.getMessage(),
                error.getLine() ?? "",
                error.getFile() ?? "",
                trace
           );
    }
}
