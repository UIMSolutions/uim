module uim.datasources.interfaces.connection;

import uim.datasources;

@safe:

// This interface defines the methods you can depend on in a connection
interface IConnection {
  // Gets the driver instance.
  // object getDriver(string role = self.ROLE_WRITE);

  // Set a cacher.
  // void setCacher(ICache cacher);

  // Get a cacher.
  // ICache getCacher();

  // Get the configuration name for this connection.
  // string configName();

  //Get the configuration data used to create the connection
  // Json[string] config();
}
