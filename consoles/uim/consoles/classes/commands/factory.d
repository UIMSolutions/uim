module uim.consoles.classes.commands.factory;

import uim.consoles;

@safe:

// This is a factory for creating Command instances.
class DCommandFactory { // }: ICommandFactory {
  mixin TConfigurable!();

  this() {
    initialize;
  }

  // Hook method
  bool initialize(IData[string] initData = null) {
    configuration(MemoryConfiguration);
    setConfigurationData(initData);

    return true;
  }
  /* 
  protected IContainer _container = null;

  this(IContainer newContainer = null) {
    _container = newContainer;
  }

    

  ICommand create(string className) {
    return _container && _container.has(aClassName)
      ? _container.get(aClassName).clone : null;
  } 
  */
}
