/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.errors.classes.errors.handlers.consoleerror;

@safe:
import uim.errors;

/**
 * Error Handler for uim console. Does simple printing of the
 * exception that occurred and the stack trace of the error.
 */
class DConsoleErrorHandler { // } : DERRErrorHandler {
    // Standard error stream.
    protected DCONConsoleOutput _stderr;

    this(Json[string] aConfig = null) {
        // TODO super();

        configuration.set(aConfig);
        _stderr = _config["stderr"];
    }

    bool initialize() {
        // TODO super.initialize;

        aConfig.set("stderr", new DConsoleOutput("D://stderr"));
        aConfig.set("log", false);
    }

    /**
     * Handle errors in the console environment. Writes errors to stderr,
     * and logs messages if Configure.read("debug") is false.
     */
    void handleException(Throwable exception) {
        _displayException(exception);
        logException(exception);

        exitCode = Command.CODE_ERROR;
        if (cast(ConsoleException)exception) {
            exitCode = exception.code();
        }
        _stop(exitCode);
    }

    // Prints an exception to stderr.
    protected void _displayException(Throwable exception) {
        string errorName = "Exception:";
        if (cast(DFatalErrorException)exception) {
            errorName = "Fatal Error:";
        }

        _stderr.write("<error>%s</error> %s\nIn [%s, line %s]\n"
            .format(errorName, exception.getMessage(), exception.getFile(), exception.getLine()));
    }

    /**
     * Prints an error to stderr.
     *
     * Template method of DERRErrorHandler.
     */
    protected void _displayError(Json[string] errorData, bool shouldDebug) {
        string message = "%s\nIn [%s, line %s]"
            .format(errorData["description"], errorData["file"], errorData["line"]);

        _stderr.write((htmlDoubleTag("error", "%s Error:")~"%s\n")
            .format(errorData["error"], message));
    }

    // Stop the execution and set the exit code for the process.
    protected void _stop(int exitCode) {
        exit(exitCode);
    }
}


