module uim.databases.interfaces.constraints;

import uim.databases;

@safe:

// Defines the interface for a fixture that needs to manage constraints.
interface IConstraints {
  // Build and execute SQL queries necessary to create the constraints for the fixture
  bool createConstraints(IConnection aConnection);

  // Build and execute SQL queries necessary to drop the constraints for the fixture
  bool dropConstraints(IConnection aConnection);
}
