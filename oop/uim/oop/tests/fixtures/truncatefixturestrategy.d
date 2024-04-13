module uim.oop.tests.fixtures.truncatefixturestrategy;

import uim.oop;

@safe:

// Fixture strategy that truncates all fixture ables at the end of test.
class DTruncateFixtureStrategy : IFixtureStrategy {
    /* 
    protected DFixtureHelper helper;

    protected IFixture[] fixtures = null;

    this() {
        this.helper = new DFixtureHelper();
    }
 
    void setupTest(string[] fixtureNames) {
        this.fixtures = this.helper.loadFixtures(fixtureNames);
        this.helper.insert(this.fixtures);
    }
 
    void teardownTest() {
        this.helper.truncate(this.fixtures);
    } */ 
}
