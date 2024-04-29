module uim.datasources.classes.connections.connection;

import uim.datasources;

@safe:

class DDatasourceConnection : JsonsourceConnection {
  mixin TConfigurable;

  this() {
    initialize;
  }
  
  // Hook method
  bool initialize(Json[string] initData = null) {

    configuration(MemoryConfiguration);
    configuration.data(initData);

    return true;
  }

  const string ROLE_WRITE = "write";

  const string ROLE_READ = "read";

  // Get the configuration name for this connection.
  string configName() {
    return null;
  }
  // Enable/disable query logging
  void enableQueryLogging(bool shouldEnable = true) {
  }

  // Disable query logging
  void disableQueryLogging() {
  }

  // Check if query logging is enabled.
  bool isQueryLoggingEnabled() {
    return false;
  }
}
