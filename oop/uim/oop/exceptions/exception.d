/*********************************************************************************************************
	Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.exceptions.exception;

import uim.oop;

@safe:
class UimException : IException {
  this() { }
  this(string aMessage) { this().message(aMessage); }
  this(string[] someAttributes) { this().attributes(someAttributes); }
  this(string aMessage, string[] someAttributes) { this().message(aMessage).attributes(someAttributes); }

  void initialize(Json configSettings = Json(null)) {
    this
      .message("");
      
    messageTemplate("default", "");
  }

  // Exception message
  mixin(OProperty!("string", "name"));

  // Exception message
  mixin(OProperty!("string", "className"));
  
  mixin(OProperty!("string", "registerPath"));

  // Exception message
  mixin(OProperty!("string", "message"));

  // #region messageTemplate
    protected STRINGAA _templates; 

    string messageTemplate(string templateName = "default") {
      return _templates.get(templateName, null);
    };

    void messageTemplate(string templateName, string templateText) {
      _templates[templateName] = templateText;
    };
  // #endregion messageTemplate

  // #region messageTemplates
    STRINGAA messageTemplates() {
      return _templates;
    }

    void messageTemplates(STRINGAA templates) {
      _templates = templates;
    }
  // #endregion messageTemplates

    // Exception message
    mixin(OProperty!("string[]", "attributes"));
  }

/*import uim.mvc;
@safe:
/**
 * Base class that all UIM Exceptions extend.
 *
 * @method int getCode() Gets the Exception code.
 */
//class UimException : IException /* : RuntimeException */ {
    /**
     * Array of attributes that are passed in from the constructor, and
     * made available in the view when a development error is displayed.
     */
    /* protected array _attributes = null;
 */
    // --- protected string _messageTemplate = "";

    // Array of headers to be passed to {@link uim.cake.Http\Response::withHeader()}
    //protected STRINGAA _responseHeaders;

    // --- protected int _defaultCode = 0;

    /**
     * Constructor.
     *
     * Allows you to create exceptions that are treated as framework errors and disabled
     * when // debugmode is off.
     *
     * @param array|string myMessage Either the string of the error message, or an array of attributes
     *   that are made available in the view, and sprintf()"d into Exception::_messageTemplate
     * @param int|null $code The error code
     * @param \Throwable|null $previous the previous exception.
     */
    /* this(myMessage = "", Nullable!int $code = null, ?Throwable $previous = null) {
      if (is_array(myMessage)) {
        _attributes = myMessage;
        myMessage = vsprintf(_messageTemplate, myMessage);
      }
      super.this(myMessage, $code ?? _defaultCode, $previous);
    } */

    // Get the passed in attributes
    /* array attributes() {
      return _attributes;
    } */

    /**
     * Get/set the response header to be used
     *
     * See also {@link uim.cake.Http\Response::withHeader()}
     *
     * @param array|string|null $header A single header string or an associative
     *   array of "header name":"header value"
     * @param string|null myValue The header value.
     * @return array|null
     * @deprecated 4.2.0 Use `HttpException::setHeaders()` instead. Response headers
     *   should be set for HttpException only.
     * /
    function responseHeader($header = null, myValue = null): ?array {
      if ($header.isNull) {
          return _responseHeaders;
      }

      deprecationWarning(
          "Setting HTTP response headers from Exception directly is deprecated~ " ~
          "If your exceptions extend Exception, they must now extend HttpException~ " ~
          "You should only set HTTP headers on HttpException instances via the `setHeaders()` method."
      );
      if (is_array($header)) {
          return _responseHeaders = $header;
      }

      return _responseHeaders = [$header: myValue];
    } */
