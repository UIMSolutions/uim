module uim.datasources.classes.connections.connection;

import uim.datasources;

@safe:

class DDBConnection : IDataSourceConnection {
  mixin TConfigurable!();

  // Hook method
  bool initialize(IData[string] initData = null) {

    configuration(MemoryConfiguration);
    configuration.data(initData);

    return true;
  }

  const string ROLE_WRITE = "write";

  const string ROLE_READ = "read";

}
