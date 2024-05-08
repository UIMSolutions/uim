/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.classes.renderers.texts.textexception;

@safe:
import uim.errors;

// s

/**
 * Plain text exception rendering with a stack trace.
 *
 * Useful in CI or plain text environments.
 *
 * @todo 5.0 Implement uim.errors.IExceptionRenderer. This implementation can"t implement
 *  the concrete interface because the return types are not compatible.
 */
class DTextExceptionRenderer {
    /**
     * @var \Throwable
     * /
    private error;

    /**
     * Constructor.
     *
     * @param \Throwable error The error to render.
     * /
    this(Throwable error) {
        this.error = error;
    }

    /**
     * Render an exception into a plain text message.
     *
     * @return IResponse|string
     * /
    function render() {
        return "%s : %s on line %s of %s\nTrace:\n%s".format(
            this.error.getCode(),
            this.error.getMessage(),
            this.error.getLine(),
            this.error.getFile(),
            this.error.getTraceAsString(),
        );
    }

    // Write output to stdout.
    void write(string outputText) {
        writeln(outputText);
    } */
}
