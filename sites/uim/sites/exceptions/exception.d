module uim.sites.uim.sites.exceptions.exception;

import uim.sites;

@safe:

// Base Sites exception.
class DSitesException : UimException {
  mixin(ExceptionThis!("Sites"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-sites");

    return true;
  }
}
mixin(ExceptionCalls!("Sites"));
