module uim.genetics.exceptions.exception;

import uim.Genetics;

@safe:

class DGeneticsException : UimException {
  mixin(ExceptionThis!("Genetics"));

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    this
      .messageTemplate("Error in libary uim-genetics");

    return true;
  }
}
mixin(ExceptionCalls!("Genetics"));
