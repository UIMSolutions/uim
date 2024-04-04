module uim.networks.exceptions.socket;

import uim.oop;

@safe:

/**
 * Exception class for Socket. This exception will be thrown from Socket, Email, HttpSocket
 * SmtpTransport, MailTransport and HttpResponse when it encounters an error.
 */
class DSocketException : DNetworksException {
  mixin(ExceptionThis!("Socket"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error from Socket, Email, HttpSocket, SmtpTransport, MailTransport or HttpResponse");

    return true;
  }
}
mixin(ExceptionCalls!("Socket"));
