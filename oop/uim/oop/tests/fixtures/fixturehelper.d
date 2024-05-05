module uim.oop.tests.fixtures.fixturehelper;

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
            if (fixtureName.has(".")) {
                [type, somePathName] = split(".", fixtureName, 2);
                string[] somePath = somePathName.split("/");
                string name = array_pop(somePath);
                string additionalPath = somePath.join("\\");

                string baseNamespace = "";
                switch(type) {
                    case "core":
                        baseNamespace = "uim";
                        break;
                    case "app":
                        baseNamespace = Configuration.read("App.namespace");
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
                /** @var class-string<\UIM\Datasource\IFixture>  className * /
                string className = array_filter(nameSegments).join("\\");
            } else {
                /** @var class-string<\UIM\Datasource\IFixture>  className * /
                 className = fixtureName;
            }
            if (isSet(fixtures[className])) {
                throw new DUnexpectedValueException("Found duplicate fixture `%s`.".format(fixtureName));
            }
            if (!class_exists(className)) {
                throw new DUnexpectedValueException("Could not find fixture `%s`.".format(fixtureName));
            }
            if (!cachedFixtures.isSet(className)) {
                cachedFixtures[className] = new className();
            }
            fixtures[className] = cachedFixtures[className];
        });
        
        return fixtures;
    }
    
    /**
     * Runs the callback once per connection.
     *
     * The callback signature:
     * ```
     * auto callback(IConnection aConnection, array fixtures)
     * ```
     * Params:
     * \Closure aCallback Callback run per connection
     * @param array<\UIM\Datasource\IFixture> fixtures Test fixtures
     * /
    void runPerConnection(Closure aCallback, array fixtures) {
        auto anGroups = null;
        fixtures
            .each!(fixture => anGroups[fixture.connection()] ~= fixture);

        anGroups.byKeyValue
            .each!(nameFixtures => aCallback(ConnectionManager.get(nameFixtures.key), nameFixtures.value));
    }
    
    /**
     * Inserts fixture data.
     * Params:
     * array<\UIM\Datasource\IFixture> fixtures Test fixtures
     * /
    void insert(Json[string] fixtures) {
        this.runPerConnection(void (IConnection aConnection, array  anGroupFixtures) {
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
    }
    
    /**
     * Inserts all fixtures for a connection and provides friendly errors for bad data.
     * Params:
     * \UIM\Datasource\IConnection aConnection Fixture connection
     * @param array<\UIM\Datasource\IFixture> fixtures Connection fixtures
     * /
    protected void insertConnection(IConnection aConnection, array fixtures) {
        fixtures.each!((fixture) {
            try {
                fixture.insert(aConnection);
            } catch (PDOException exception) {
                string message = "Unable to insert rows for table `%s`."
                        ~ " Fixture records might have invalid data or unknown constraints.\n%s"
                        .format(fixture.sourceName(), exception.getMessage() );
                throw new UimException(message);
            }
        });
    }
    
    /**
     * Truncates fixture tables.
     * /
    void truncate(IFixture[] testFixtures) {
        this.runPerConnection(void (IConnection aConnection, array  anGroupFixtures) {
            if (cast(DConnection)aConnection) {
                sortedFixtures = null;
                if (aConnection.getDriver().supports(DriverFeatures.TRUNCATE_WITH_CONSTRAINTS)) {
                    sortedFixtures = this.sortByConstraint(aConnection,  anGroupFixtures);
                }
                if (sortedFixtures !isNull) {
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
    }
    
    /**
     * Truncates all fixtures for a connection and provides friendly errors for bad data.
     * Params:
     * \UIM\Datasource\IConnection aConnection Fixture connection
     * @param array<\UIM\Datasource\IFixture> fixtures Connection fixtures
     * /
    protected void truncateConnection(IConnection aConnection, array fixtures) {
        fixtures.each!((fixture) {
            try {
                fixture.truncate(aConnection);
            } catch (PDOException exception) {
                string message = "Unable to truncate table `%s`."
                        ~ " Fixture records might have invalid data or unknown contraints.\n%s".format(
                    fixture.sourceName(),exception.getMessage());
                throw new UimException(message);
            }
        });
    }
    
    /**
     * Sort fixtures with foreign constraints last if possible, otherwise returns null.
     * Params:
     * \UIM\Database\Connection aConnection Database connection
     * @param array<\UIM\Datasource\IFixture> fixtures Database fixtures
     * /
    // TODO protected array sortByConstraint(Connection aConnection, array fixtures) {
        constrained = null;
        unconstrained = null;
        fixtures.each((fixture) {
            references = this.getForeignReferences(aConnection, fixture);
            if (references) {
                constrained[fixture.sourceName()] = ["references": references, "fixture": fixture];
            } else {
                unconstrained ~= fixture;
            }
        });
        // Check if any fixtures reference another fixture with constrants
        // If they do, then there might be cross-dependencies which we don"t support sorting
        foreach (constrained as ["references": references]) {
            foreach (references as reference) {
                if (isSet(constrained[reference])) {
                    return null;
                }
            }
        }
        return chain(unconstrained, array_column(constrained, "fixture"));
    }
    
    /**
     * Gets array of foreign references for fixtures table.
     * Params:
     * \UIM\Database\Connection aConnection Database connection
     * @param \UIM\Datasource\IFixture fixture Database fixture
     * /
    protected string[] getForeignReferences(Connection aConnection, IFixture fixture) {
        /** @var array<string, \UIM\Database\Schema\TableISchema> schemas * /
        static schemas = null;

        // Get and cache off the schema since TestFixture generates a fake schema based on fields
        aTableName = fixture.sourceName();
        if (!schemas.isSet(aTableName)) {
            schemas[aTableName] = aConnection.getSchemaCollection().describe(aTableName);
        }
        tableSchema = schemas[aTableName];

        references = null;
        foreach (tableSchema.constraints() as constraintName) {
            constraint = tableSchema.getConstraint(constraintName);

            if (constraint && constraint["type"] == TableSchema.CONSTRAINT_FOREIGN) {
                references ~= constraint["references"][0];
            }
        }
        return references;
    } */ 
}
