module uim.oop.tests.fixtures.truncatefixturestrategy;

import uim.oop;

@safe:

// Fixture strategy that truncates all fixture ables at the end of test.
class DTruncateFixtureStrategy : IFixtureStrategy {
    protected DFixtureHelper _helper;
    // TODO protected IFixture[] _fixtures;

    this() {
        _helper = new DFixtureHelper();
    }
 
    void setupTest(string[] fixtureNames) {
       // TODO  _fixtures = _helper.loadFixtures(fixtureNames);
       // TODO _helper.insert(_fixtures);
    }
 
    void teardownTest() {
       // TODO  _helper.truncate(_fixtures);
    }  
}
