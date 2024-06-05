module uim.oop.tests.fixtures.transactionfixturestrategys;

import uim.oop;

@safe:

/*
/**
 * Fixture strategy that wraps fixtures in a transaction that is rolled back
 * after each test.
 *
 * Any test that calls Connection.rollback(true) will break this strategy.
 */
class DTransactionFixtureStrategy : IFixtureStrategy {
    /* 
    protected DFixtureHelper helper;

    protected IFixture[] fixtures;

    this() {
        this.helper = new DFixtureHelper();
    }
    
    void setupTest(string[] fixtureNames) {
        this.fixtures = this.helper.loadFixtures(fixtureNames);

        this.helper.runPerConnection(void (aConnection) {
            if (cast(DConnection)aConnection) {
                assert(
                    !aConnection.inTransaction(),
                    "Cannot start transaction strategy inside a transaction. This is most likely a bug."
               );
                aConnection.enableSavePoints();
                if (!aConnection.isSavePointsEnabled()) {
                    throw new DatabaseException(
                        "Could not enable save points for the `{aConnection.configName()}` connection. " .
                            "Your database needs to support savepoints in order to use " .
                            "TransactionFixtureStrategy."
                   );
                }
                aConnection.begin();
                aConnection.createSavePoint("__fixtures__");
            }
        }, this.fixtures);

        this.helper.insert(this.fixtures);
    }
 
    void teardownTest() {
        this.helper.runPerConnection(void (Connection aConnection) {
            if (aConnection.inTransaction()) {
                aConnection.rollback(true);
            }
        }, this.fixtures);
    } */ 
}
