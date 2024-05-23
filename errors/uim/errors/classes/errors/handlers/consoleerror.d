/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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

        configuration.update(aConfig);
        _stderr = _config["stderr"];
    }

    bool initialize() {
        // TODO super.initialize;

        aConfig["stderr"] = new DConsoleOutput("D://stderr");
        aConfig["log"] = false;
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
        errorName = "Exception:";
        if (cast(DFatalErrorException)exception) {
            errorName = "Fatal Error:";
        }

        message = "<error>%s</error> %s\nIn [%s, line %s]\n"
            .format(errorName, exception.getMessage(), exception.getFile(), exception.getLine());
        _stderr.write(message);
    }

    /**
     * Prints an error to stderr.
     *
     * Template method of DERRErrorHandler.
     */
    protected void _displayError(Json[string] errorData, bool shouldDebug) {
        string message = "%s\nIn [%s, line %s]"
            .format(errorData["description"], errorData["file"], errorData["line"]);

        string message = "<error>%s Error:</error> %s\n"
            .format(errorData["error"], message);

        _stderr.write(message);
    }

    // Stop the execution and set the exit code for the process.
    protected void _stop(int exitCode) {
        exit(exitCode);
    }
}


