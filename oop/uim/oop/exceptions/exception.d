/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.exceptions.exception;

import uim.oop;

@safe:
class UimException : IException {
  this() { }
  this(string aMessage) { this().message(aMessage); }
  this(IData[string] newAttributes) { this().attributes(newAttributes); }
  this(string aMessage, IData[string] newAttributes) { this().message(aMessage).attributes(newAttributes); }

     bool initialize(IData[string] initData = null) {
        
    this
      .message("");
      
    messageTemplate("default", "");
    return true;
  }

  mixin(OProperty!("string", "name"));
  mixin(OProperty!("string", "registerPath"));
  mixin(OProperty!("string", "message"));

  // #region messageTemplate
    protected STRINGAA _stringTemplate; 

    string messageTemplate(string templateName = "default") {
      return _stringTemplate.get(templateName, null);
    };

    void messageTemplate(string templateName, string templateText) {
      _stringTemplate[templateName] = templateText;
    };
  // #endregion messageTemplate

  // #region messageTemplates
    STRINGAA messageTemplates() {
      return _stringTemplate;
    }

    void messageTemplates(STRINGAA templates) {
      _stringTemplate = templates;
    }
  // #endregion messageTemplates

    // Exception message
    mixin(OProperty!("IData[string]", "attributes"));
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
    /* // TODO protected array _attributes = null;
 */
    // --- protected string _messageTemplate = "";

    // Array of headers to be passed to {@link uim.Http\Response::withHeader()}
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
     * @param int|null code The error code
     * @param \Throwable|null previous the previous exception.
     */
    /* this(myMessage = "", Nullable!int code = null, ?Throwable previous = null) {
      if ((myMessage.isArray) {
        _attributes = myMessage;
        myMessage = vsprintf(_messageTemplate, myMessage);
      }
      super(myMessage, code ?? _defaultCode, previous);
    } */

    // Get the passed in attributes
    /* array attributes() {
      return _attributes;
    } */

    
