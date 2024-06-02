/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.interfaces.fixture;

import uim.datasources;

@safe:

// Defines the interface that testing fixtures use.
interface IFixture {
    // Create the fixture schema/mapping/definition
    bool create(JsonsourceConnection aConnection);

    // Run after all tests executed, should remove the table/collection from the connection.
    bool drop(JsonsourceConnection aConnection);

    // Should insert all the records into the test database.*/
    bool insert(JsonsourceConnection aConnection);

    // Truncates the current fixture.
    bool truncate(JsonsourceConnection aConnectionToDB);

    // Get the connection name this fixture should be inserted into.
    string connection();

    // Get the table/collection name for this fixture.
    string sourceName();
}
