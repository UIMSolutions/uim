module uim.cake.TestSuite\Fixture;

import uim.cake;

@safe:

// Fixture strategy that truncates all fixture ables at the end of test.
class TruncateFixtureStrategy : IFixtureStrategy {
    protected FixtureHelper helper;

    protected IFixture[] fixtures = [];

    this() {
        this.helper = new FixtureHelper();
    }
 
    void setupTest(string[] fixtureNames) {
        this.fixtures = this.helper.loadFixtures(fixtureNames);
        this.helper.insert(this.fixtures);
    }
 
    void teardownTest() {
        this.helper.truncate(this.fixtures);
    }
}
