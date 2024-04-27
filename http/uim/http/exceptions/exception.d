module uim.http.exceptions.exception;

import uim.http;

@safe:

/*
 * Parent class for all the HTTP related exceptions in UIM.
 * All HTTP status/error related exceptions should extend this class so
 * catch blocks can be specifically typed.
 *
 * You may also use this as a meaningful bridge to {@link \UIM\Core\Exception\UimException}, e.g.:
 * throw new \UIM\Network\Exception\HttpException("HTTP Version Not Supported", 505);
 */
class DHttpException : UimException {
  mixin(ExceptionThis!("Http"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-http");

    return true;
  }

  protected int _defaultCode = 500;

  // Gets/Sets HTTP response headers.
  mixin(TProperty!("Json[string]", "headers"));

  // Set a single HTTP response header.
  void header(string headerName, Json headerValue = null) {
    this.headers[headerName] = headerValue;
  }

  /* void header(string headerName, string[] aValue = null) {
    this.headers[aHeader] = aValue;
  } */
}
mixin(ExceptionCalls!("Http"));
