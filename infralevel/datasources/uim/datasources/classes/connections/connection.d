module uim.datasources.classes.connections.connection;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

class DDatasourceConnection : UIMObject, IDatasourceConnection {
  mixin(DatasourceConnectionThis!());

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
