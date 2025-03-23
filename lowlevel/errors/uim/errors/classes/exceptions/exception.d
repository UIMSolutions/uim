/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.exceptions.exception;

import uim.errors;

@safe:
class DException : UIMObject, IException {
  mixin(ExceptionThis!());

  override bool initialize(Json[string] options = new Json[string]) {
    _attributes.set(options);
    messageTemplate("default", "");
    return true;
  }

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


  /* Json toJson(string[] showKeys = null, string[] hideKeys = null) {
    Json json = Json.emptyObject;
    json
      .set("name", name)
      .set("classname", this.classname);

    return json;
  } */

  /*  Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    Json[string] info;
    return info
      .set("name", name)
      .set("classname", this.classname);
  } */
}

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
