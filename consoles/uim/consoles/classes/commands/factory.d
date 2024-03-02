module uim.consoles.classes.commands.factory;

import uim.consoles;

@safe:

// This is a factory for creating Command instances.
class CommandFactory : ICommandFactory {
  protected IContainer _container = null;

  this(IContainer newContainer = null) {
    _container = newContainer;
  }

  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    return true;
  }

  ICommand create(string className) {
    return _container && _container.has(aClassName)
      ? _container.get(aClassName).copy : null;
  }
}
