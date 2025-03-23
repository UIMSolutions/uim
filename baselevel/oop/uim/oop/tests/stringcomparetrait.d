/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.tests.stringcomparetrait;

import uim.oop;

@safe:

version (test_uim_oop) {
    import std.stdio;
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

/**
 * Compare a string to the contents of a file
 *
 * Implementing objects are expected to modify the ` _compareBasePath` property
 * before use.
 */
mixin template TStringCompare() {
    /**
     * The base path for output comparisons
     *
     * Must be initialized before use
     */
    protected string _compareBasePath;

    /**
     * Update comparisons to match test changes
     * Initialized with the env variable UPDATE_TEST_COMPARISON_FILES
     */
    protected bool _updateComparisons;

    /**
     * Compare the result to the contents of the file
     * Params:
     * string aPath partial path to test comparison file
     */
    void assertSameAsFile(string partialPath, string testResult) {
        // TODO
        /* 
        if (!filehasKey(partialPath)) {
            partialPath = _compareBasePath ~ partialPath;
        }
       _updateComparisons ??= enviroment("UPDATE_TEST_COMPARISON_FILES") ?: false;

        if (_updateComparisons) {
            file_put_contents(somePath, result);
        }
        expected = file_get_contents(somePath);
        this.assertTextEquals(expected, result, "Content does not match file " ~ somePath);
        */
    } 
}
