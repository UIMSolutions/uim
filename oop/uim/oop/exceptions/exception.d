/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.exceptions.exception;

import uim.oop;

@safe:
class DException : IException {
  this(
    string message,
    string file = __FILE__,
    ulong line = cast(ulong) __LINE__,
    Throwable nextInChain = null
  ) pure nothrow @nogc {
    super(message, file, line, nextInChain);
    // TODO 
  }

  bool initialize(Json[string] initData = null) {

    this
      .message("");

    messageTemplate("default", "");
    return true;
  }

  mixin(TProperty!("string", "name"));
  mixin(TProperty!("string", "registerPath"));
  mixin(TProperty!("string", "message"));

  /**
     * Array of attributes that are passed in from the constructor, and
     * made available in the view when a development error is displayed.
     */
  // Exception message
  mixin(TProperty!("Json[string]", "attributes"));

  // Template string that has attributes sprintf()'ed into it.
  protected string _messageTemplate = "";

  // Default exception code
  protected int _defaultCode = 0;

  // #region messageTemplate
  protected STRINGAA _stringContents;

  string messageTemplate(string templateName = "default") {
    return _stringContents.get(templateName, null);
  };

  void messageTemplate(string templateName, string templateText) {
    _stringContents[templateName] = templateText;
  };
  // #endregion messageTemplate

  // #region messageTemplates
  STRINGAA messageTemplates() {
    return _stringContents;
  }

  void messageTemplates(STRINGAA templates) {
    _stringContents = templates;
  }
  // #endregion messageTemplates
}

/*import uim.mvc;
@safe:
/**
 * Base class that all UIM Exceptions extend.
 *
 * @method int getCode() Gets the Exception code.
 */
//class DException : IException /* : RuntimeException */ {
/**
     * Array of attributes that are passed in from the constructor, and
     * made available in the view when a development error is displayed.
     */
// TODO protected Json[string] _attributes = null;
 */
// --- protected string _messageTemplate = "";

// Array of headers to be passed to {@link uim.Http\Response.withHeader()}
//protected STRINGAA _responseHeaders;

// --- protected int _defaultCode = 0;

/**
     * Constructor.
     *
     * Allows you to create exceptions that are treated as framework errors and disabled
     * when // debugmode is off.
     *
     * @param array|string myMessage Either the string of the error message, or an array of attributes
     *  that are made available in the view, and sprintf()"d into Exception._messageTemplate
     * @param \Throwable|null previous the previous exception.
     */
/* this(myMessage = "", int errorCode = null, Throwable previousException = null) {
      if (myMessage.isArray) {
        _attributes = myMessage;
        myMessage = vsprintf(_messageTemplate, myMessage);
      }
      super(myMessage, errorCode ?? _defaultCode, previous);
    } */

// Get the passed in attributes
/* Json[string] attributes() {
      return _attributes;
    } */
