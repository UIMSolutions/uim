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
    // TODO protected DCONConsoleOutput _stderr;

    /**
     * Constructor
     *
     * @param array<string, mixed> aConfig Config options for the error handler.
     * /
    this(Json aConfig = null) {
        super();

        configuration.update(aConfig);
        _stderr = _config["stderr"];
    }

    bool initialize() {
        super.initialize;

        aConfig["stderr"] = new DConsoleOutput("D://stderr");
        aConfig["log"] = false;
    }

    /**
     * Handle errors in the console environment. Writes errors to stderr,
     * and logs messages if Configure::read("debug") is false.
     *
     * @param \Throwable exception Exception instance.
     * @return void
     * @throws \Exception When renderer class not found
     * @see https://secure.D.net/manual/en/function.set-exception-handler.D
     * /
    void handleException(Throwable exception) {
        _displayException(exception);
        this.logException(exception);

        exitCode = Command::CODE_ERROR;
        if (exception instanceof ConsoleException) {
            exitCode = exception.getCode();
        }
        _stop(exitCode);
    }

    /**
     * Prints an exception to stderr.
     *
     * @param \Throwable exception The exception to handle
     * /
    protected void _displayException(Throwable exception) {
        errorName = "Exception:";
        if (exception instanceof FatalErrorException) {
            errorName = "Fatal Error:";
        }

        message = sprintf(
            "<error>%s</error> %s\nIn [%s, line %s]\n",
            errorName,
            exception.getMessage(),
            exception.getFile(),
            exception.getLine()
        );
        _stderr.write(message);
    }

    /**
     * Prints an error to stderr.
     *
     * Template method of DERRErrorHandler.
     *
     * @param Json[string] error An array of error data.
     * @param bool shouldDebug Whether the app is in debug mode.
     * /
    protected void _displayError(Json[string] error, bool shouldDebug) {
        message = sprintf(
            "%s\nIn [%s, line %s]",
            error["description"],
            error["file"],
            error["line"]
        );
        message = sprintf(
            "<error>%s Error:</error> %s\n",
            error["error"],
            message
        );
        _stderr.write(message);
    }

    /**
     * Stop the execution and set the exit code for the process.
     *
     * @param int code The exit code.
     * /
    protected void _stop(int code) {
        exit(code);
    } */
}


