module uim.datasources.interfaces.fixture;

import uim.datasources;

@safe:

// Defines the interface that testing fixtures use.
interface IFixture {
    // Create the fixture schema/mapping/definition
    bool create(IConnection aConnection);

    // Run after all tests executed, should remove the table/collection from the connection.
    bool drop(IConnection aConnection);

    // Should insert all the records into the test database.*/
    bool insert(IConnection aConnection);

    // Truncates the current fixture.
    bool truncate(IConnection aConnectionToDB);

    // Get the connection name this fixture should be inserted into.
    string connection();

    // Get the table/collection name for this fixture.
    string sourceName();
}
