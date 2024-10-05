/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.exceptions.exception;

import uim.oop;

@safe:
class UIMException : Exception {
  this() {
    this.initialize;
    super(message, __FILE__, cast(size_t) __LINE__, null);
  }

  this(
    string msg,
    string file = __FILE__,
    size_t line = cast(size_t) __LINE__,
    Throwable nextInChain = null
  ) {
    super(msg, file, line, nextInChain);
    this.initialize;
  }

  bool initialize(Json[string] initData = null) {
    attributes.set(initData);
    messageTemplate("default", "");
    return true;
  }

  mixin(TProperty!("string", "name"));
  mixin(TProperty!("string", "message"));
  mixin(TProperty!("string", "registerPath"));

  /**
     * Array of attributes that are passed in from the constructor, and
     * made available in the view when a development error is displayed.
     */
  mixin(TProperty!("Json[string]", "attributes"));

  // Default exception code
  protected int _defaultCode = 0;

  protected STRINGAA _stringContents;

  // #region messageTemplate
  // Template string that has attributes format() into it.
  protected string _messageTemplate = "";
  string messageTemplate(string templateName = "default") {
    return (templateName in _stringContents) ? templateName : null;
  };

  void messageTemplate(string templateText) {
    _stringContents["default"] = templateText;
  };

  void messageTemplate(string templateName, string templateText) {
    _stringContents[templateName] = templateText;
  };
  // #endregion messageTemplate

  // #region messageTemplates
  STRINGAA messageTemplates() {
    return _stringContents;
  }

  void messageTemplates(string[string] templates) {
    _stringContents = templates;
  }
  // #endregion messageTemplates
}

/**
 * Base class that all UIM Exceptions extend.
 *
 * @method int getCode() Gets the Exception code.
 */
//class UIMException : IException /* : RuntimeException */ {
/**
     * Array of attributes that are passed in from the constructor, and
     * made available in the view when a development error is displayed.
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
     * /
this( /* string[] * / string myMessage = "", int errorCode = null, Throwable previousException = null) {
  if (myMessage.isArray) {
    _attributes = myMessage;
    myMessage = vsprintf(_messageTemplate, myMessage);
  }
  super(myMessage, errorCode ?  ? _defaultCode, previousException);
}
*/
