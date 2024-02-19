module uim.datasources.interfaces.fixture;

import uim.datasources;

@safe:

// Defines the interface that testing fixtures use.
interface IFixture {
    // Should insert all the records into the test database.*/
   bool insert(IConnection aConnection);

    // Truncates the current fixture.
   bool truncate(IConnection aConnectionToDB);

    // Get the connection name this fixture should be inserted into.
    string connection();

    // Get the table/collection name for this fixture.
    string sourceName();
}
