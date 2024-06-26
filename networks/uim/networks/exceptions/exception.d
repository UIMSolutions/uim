module uim.networks.exceptions.exception;

import uim.networks;

@safe:

// Base Networks exception.
class DNetworksException : DException {
  mixin(ExceptionThis!("Networks"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-networks");

    return true;
  }
}
mixin(ExceptionCalls!("Networks"));
