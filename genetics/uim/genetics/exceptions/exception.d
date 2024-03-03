module uim.genetics.exceptions.exception;

import uim.genetics;

@safe:

class DGeneticsException : UimException {
  mixin(ExceptionThis!("Genetics"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-genetics");

    return true;
  }
}
mixin(ExceptionCalls!("Genetics"));
