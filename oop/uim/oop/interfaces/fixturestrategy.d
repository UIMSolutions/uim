/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.interfaces.fixturestrategy;import uim.oop;@safe:// Base interface for strategies used to manage fixtures for TestCase.interface IFixtureStrategy {    // Called before each test run in each TestCase.    /* void setupTest(string[] fixtureNames);    // Called after each test run in each TestCase.    void teardownTest(); */}