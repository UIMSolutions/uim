/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.tests.fixtures.truncatestrategys;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

// Fixture strategy that truncates all fixture ables at the end of test.
class DTruncateStrategy : IFixtureStrategy {
    /* 
    protected DFixtureHelper _helper;

    protected IFixture _fixtures;

    this() {
        _helper = new DFixtureHelper();
    }
 
    void setupTest(string[] fixtureNames) {
        if (fixtureNames.isEmpty) {
            return;
        }
        _fixtures = _helper.loadFixtures(fixtureNames);
        _helper.insert(_fixtures);
    }
 
    void teardownTest() {
        _helper.truncate(_fixtures);
    } */ 
}
