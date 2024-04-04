module uim.networks.exceptions.exception;

import uim.networks;

@safe:

// Base Networks exception.
class DNetworksException : UimException {
  mixin(ExceptionThis!("Networks"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-networks");

    return true;
  }
}
mixin(ExceptionCalls!("Networks"));
