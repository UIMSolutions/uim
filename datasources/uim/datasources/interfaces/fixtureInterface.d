/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.interfaces.fixtureInterface;

/**
 * Defines the interface that testing fixtures use.
 */
interface IFixture
{
    /**
     * Create the fixture schema/mapping/definition
     *
     * @param uim.cake.Datasource\IConnection $connection An instance of the connection the fixture should be created on.
     * @return bool True on success, false on failure.
     */
    bool create(IConnection aConnection);

    /**
     * Run after all tests executed, should remove the table/collection from the connection.
     *
     * @param uim.cake.Datasource\IConnection $connection An instance of the connection the fixture should be removed from.
     * @return bool True on success, false on failure.
     */
    bool drop(IConnection aConnection);

    /**
     * Run before each test is executed.
     *
     * Should insert all the records into the test database.
     *
     * @param uim.cake.Datasource\IConnection $connection An instance of the connection
     *   into which the records will be inserted.
     * @return uim.cake.databases.StatementInterface|bool on success or if there are no records to insert,
     *  or false on failure.
     */
    function insert(IConnection aConnection);

    /**
     * Truncates the current fixture.
     * @param uim.cake.Datasource\IConnection $connection A reference to a db instance
     */
    bool truncate(IConnection aConnection);

    // Get the connection name this fixture should be inserted into.
    string connection();

    // Get the table/collection name for this fixture.
    string sourceName();
}
