module uim.cake.tests.fixtures.fixturestrategyinterfaces;

import uim.cake;

@safe:

// Base interface for strategies used to manage fixtures for TestCase.
interface IFixtureStrategy {
    // Called before each test run in each TestCase.
    void setupTest(string[] fixtureNames);

    // Called after each test run in each TestCase.
    void teardownTest();
}
