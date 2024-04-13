module uim.oop.tests.fixtures.transactionstrategy;

import uim.oop;

@safe:

/*
/**
 * Fixture strategy that wraps fixtures in a transaction that is rolled back
 * after each test.
 *
 * Any test that calls Connection.rollback(true) will break this strategy.
 */
class DTransactionStrategy : IFixtureStrategy {
    /* 
        mixin TConfigurable!();

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    
    protected DFixtureHelper helper;

    protected IFixture[] fixtures;

    this() {
        this.helper = new DFixtureHelper();
    }
 
    auto setupTest(string[] fixtureNames) {
        if (isEmpty(fixtureNames)) {
            return;
        }
        this.fixtures = this.helper.loadFixtures(fixtureNames);

        this.helper.runPerConnection(void (aConnection) {
            if (cast(DConnection)aConnection) {
                assert(
                    aConnection.inTransaction() == false,
                    "Cannot start transaction strategy inside a transaction. " .
                    "Ensure you have closed all open transactions."
                );
                aConnection.enableSavePoints();
                if (!aConnection.isSavePointsEnabled()) {
                    throw new DatabaseException(
                        "Could not enable save points for the `{aConnection.configName()}` connection. " .
                            "Your database needs to support savepoints in order to use " .
                            "TransactionStrategy."
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
