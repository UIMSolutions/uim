/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.tests.fixtures.fixturehelper;(IClosure

import uim.oop;

@safe:

// Helper for managing fixtures.
class DFixtureHelper {
    /* 
    // Finds fixtures from their TestCase names such as "core.Articles".
    IFixture[] loadFixtures(string[] fixtureNames) {
        static cachedFixtures = null;

        fixtures = null;
        fixtureNames.each!((fixtureName) {
            if (fixtureName.contains(".")) {
                [type, somePathName] = split(".", fixtureName, 2);
                string[] somePath = somePathName.split("/");
                string name = somePath.pop();
                string additionalPath = somePath.join("\\");

                string baseNamespace = "";
                switch(type) {
                    case "core": 
                        baseNamespace = "uim";
                        break;
                    case "app": 
                        baseNamespace = configuration.get("App.namespace");
                        break;
                    case "plugin": 
                        [plugin, name] = somePathName.split(".");
                        baseNamespace = plugin.replace("/", "\\");
                        additionalPath = null;
                        break;
                    default: 
                        baseNamespace = null;
                        name = fixtureName;
                        break;
                }

                if (indexOf(name, "/") > 0) {
                    name = name.replace("/", "\\");
                }
                nameSegments = [
                    baseNamespace,
                    "Test\Fixture",
                    additionalPath,
                    name ~ "Fixture",
                ];
                /** @var class-string<\UIM\Datasource\IFixture>  classname * /
                string classname = nameSegments.filterValues.join("\\");
            } else {
                /** @var class-string<\UIM\Datasource\IFixture>  classname * /
                 classname = fixtureName;
            }

            if (fixtures.hasKey(classname)) {
                throw new DUnexpectedValueException("Found duplicate fixture `%s`.".format(fixtureName));
            }
            if (!class_hasKey(classname)) {
                throw new DUnexpectedValueException("Could not find fixture `%s`.".format(fixtureName));
            }
            if (!cachedFixtures.hasKey(classname)) {
                // TODO cachedFixtures[classname] = new classname();
            }
            fixtures[classname] = cachedFixtures[classname];
        });
        
        return fixtures;
    }
    
    /**
     * Runs the callback once per connection.
     *
     * The callback signature:
     * ```
     * auto callback(IConnection aConnection, Json[string] fixtures)
     * ```
     */
    // TODO 
    /* 
    void runPerConnection(DClosure aCallback, IFixture[] fixtures) {
        auto anGroups = null;
        fixtures
            .each!(fixture => anGroups[fixture.connection()).concat( fixture);

        anGroups.byKeyValue
            .each!(nameFixtures => aCallback(ConnectionManager.get(nameFixtures.key), nameFixtures.value));
    } */

    // Inserts fixture data.
    // TODO
    /* void insert(IFixture[] fixtures) {
        runPerConnection(void (IConnection aConnection, Json[string] anGroupFixtures) {
            if (cast(DConnection)aConnection) {
                sortedFixtures = this.sortByConstraint(aConnection,  anGroupFixtures);
                if (sortedFixtures) {
                    this.insertConnection(aConnection, sortedFixtures);
                } else {
                    helper = new DConnectionHelper();
                    helper.runWithoutConstraints(
                        aConnection,
                        fn (Connection aConnection): this.insertConnection(aConnection,  anGroupFixtures)
                   );
                }
            } else {
                this.insertConnection(aConnection,  anGroupFixtures);
            }
        }, fixtures);
    } */

    // Inserts all fixtures for a connection and provides friendly errors for bad data.
    // TODO 
    /* protected void insertConnection(DConnection fixtureConnection, DFixture[] connectionFixtures) {
        // TODO
        /*
        connectionFixtures.each!((fixture) {
            try {
                fixture.insert(fixtureConnection);
            } catch (PDOException exception) {
                string message = "Unable to insert rows for table `%s`."
                        ~ " Fixture records might have invalid data or unknown constraints.\n%s"
                        .format(fixture.sourceName(), exception.message());
                throw new UIMException(message);
            }
        });
    } */

    // Truncates fixture tables.
    // TODO
    /* 
    void truncate(IFixture[] testFixtures) {
        // TODO
        this.runPerConnection(void (IConnection aConnection, Json[string] anGroupFixtures) {
            if (cast(DConnection)aConnection) {
                sortedFixtures = null;
                if (aConnection.getDriver().supports(DriverFeatures.TRUNCATE_WITH_CONSTRAINTS)) {
                    sortedFixtures = this.sortByConstraint(aConnection,  anGroupFixtures);
                }
                if (sortedFixtures !is null) {
                    this.truncateConnection(aConnection, array_reverse(sortedFixtures));
                } else {
                    helper = new DConnectionHelper();
                    helper.runWithoutConstraints(
                        aConnection,
                        fn (Connection aConnection): this.truncateConnection(aConnection,  anGroupFixtures)
                   );
                }
            } else {
                this.truncateConnection(aConnection,  anGroupFixtures);
            }
        }, testFixtures);
    } */

    // Truncates all fixtures for a connection and provides friendly errors for bad data.
    // TODO
    /* protected void truncateConnection(IConnection fixtureConnection, IFixture[] fixtures) {
        fixtures.each!((fixture) {
            try {
                fixture.truncate(fixtureConnection);
            } catch (PDOException exception) {
                string message = "Unable to truncate table `%s`." ~ 
                    " Fixture records might have invalid data or unknown contraints.\n%s"
                    .format(fixture.sourceName(),exception.message());
                throw new UIMException(message);
            }
        });
    } */

    // Sort fixtures with foreign constraints last if possible, otherwise returns null.
    // TODO
    /* protected Json[string] sortByConstraint(Connection aConnection, Json[string] fixtures) {
        auto constrained = null;
        auto unconstrained = null;
        fixtures.each((fixture) {
            references = getForeignReferences(aConnection, fixture);
            if (references) {
                constrained.set(fixture.sourceName(), ["references": references, "fixture": fixture]);
            } else {
                unconstrained ~= fixture;
            }
        });
        // Check if any fixtures reference another fixture with constrants
        // If they do, then there might be cross-dependencies which we don"t support sorting
        // TODO 
        /*
        foreach (["references": references]; constrained) {
            if (references.any!(reference => constrained.hasKey(reference))) { return null; }; 
        }
        * /
        return chain(unconstrained, array_column(constrained, "fixture"));
    } */

    // Gets array of foreign references for fixtures table.
    // TODO 
    /*
    protected string[] getForeignReferences(Connection dbConnection, IFixture fixture) {
        static TableISchema[] schemas = null;

        // Get and cache off the schema since TestFixture generates a fake schema based on fields
        auto aTableName = fixture.sourceName();
        if (!schemas.hasKey(aTableName)) {
            schemas[aTableName] = dbConnection.getSchemaCollection().describe(aTableName);
        }
        tableSchema = schemas[aTableName];

        string[] references;
        // TODO
        /* 
        foreach (tableSchema.constraints() as constraintName) {
            constraint = tableSchema.getConstraint(constraintName);

            if (constraint && constraint["type"] == TableSchema.CONSTRAINT_FOREIGN) {
                references ~= constraint["references"][0];
            }
        } 
        return references;
    } */
}
