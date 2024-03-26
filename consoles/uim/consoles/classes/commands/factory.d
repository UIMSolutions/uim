module uim.consoles.classes.commands.factory;

import uim.consoles;

@safe:

// This is a factory for creating Command instances.
class DCommandFactory { // }: ICommandFactory {
  /* 
  protected IContainer _container = null;

  this(IContainer newContainer = null) {
    _container = newContainer;
  }

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  ICommand create(string className) {
    return _container && _container.has(aClassName)
      ? _container.get(aClassName).copy : null;
  } 
  */
}
