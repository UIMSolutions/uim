/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.classes.renderers.consoles.consoleexception;

@safe:
import uim.errors;

/**
 * Plain text exception rendering with a stack trace.
 *
 * Useful in CI or plain text environments.
 *
 * @todo 5.0 Implement uim.errors.IExceptionRenderer. This implementation can"t implement
 *  the concrete interface because the return types are not compatible.
 */
class DConsoleExceptionRenderer {
  /**
    * @var \Throwable
    * /
  private error;

  private DCONConsoleOutput output;

  private bool trace;

  /**
    * Constructor.
    *
    * @param \Throwable error The error to render.
    * @param \Psr\Http\messages.IServerRequest|null request Not used.
    * @param IData aConfig Error handling configuration.
    * /
  this(Throwable error, ?IServerRequest request, IData aConfig) {
    this.error = error;
    this.output = aConfig["stderr"] ?? new DConsoleOutput("php://stderr");
    this.trace = aConfig["trace"] ?? true;
  }

  // Render an exception into a plain text message.
  string render() {
    auto myExceptions = [this.error];
    auto myPrevious = this.error.getPrevious();
    while (myPrevious != null) {
        myExceptions ~= previous;
        myPrevious = myPrevious.getPrevious();
    }
    string[] results;
    foreach (myIndex, myError; myExceptions) {
        results = chain(results, this.renderException(myError, i));
    }

    return results.join("\n");
  }

  /**
    * Render an individual exception
    *
    * @param \Throwable exception The exception to render.
    * @param int index Exception index in the chain
    * /
  protected string[] renderException(Throwable anException, int anIndex) {
    string[] results = [
            "<error>%s[%s] %s</error> in %s on line %s".format(
              anIndex > 0 ? "Caused by " : "",
              get_class(anException),
              anException.getMessage(),
              anException.getFile(),
              anException.getLine()
        );
    ];

    debug = Configure::read("debug");
    if (debug && exception instanceof UIMException) {
        attributes = exception.getAttributes();
        if (attributes) {
            results ~= "";
            results ~= "<info>Exception Attributes</info>";
            results ~= "";
            results ~= var_export(exception.getAttributes(), true);
        }
    }

    if (this.trace) {
        results ~= "";
        results ~= "<info>Stack Trace:</info>";
        results ~= "";
        results ~= exception.getTraceAsString();
        results ~= "";
    }

    return results;
  }

  /**
    * Write output to the output stream
    *
    * @param string output The output to print.
    * /
  void write(string anOutput) {
      this.output.write(anOutput); 
  } */
}
