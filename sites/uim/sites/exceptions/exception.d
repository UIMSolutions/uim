module uim.sites.uim.sites.exceptions.exception;

import uim.sites;

@safe:

// Base Sites exception.
class DSitesException : UimException {
  mixin(ExceptionThis!("Sites"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-sites");

    return true;
  }
}
mixin(ExceptionCalls!("Sites"));
