module uim.sites.exceptions.exception;

import uim.sites;

@safe:

// Base Sites exception.
class DSitesException : DException {
  mixin(ExceptionThis!("Sites"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-sites");

    return true;
  }
}
mixin(ExceptionCalls!("Sites"));
