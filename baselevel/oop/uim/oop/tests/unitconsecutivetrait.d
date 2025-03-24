/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.tests.unitconsecutivetrait;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

mixin template TUnitConsecutive() {
    /* 
    static iterable withConsecutive(Json[string] firstCallArguments, Json[string] ...consecutiveCallsArguments) {
        allConsecutiveCallsArguments = [firstCallArguments, ...consecutiveCallsArguments];

        numberOfArguments = count(firstCallArguments);
        argumentList = null;
        for (argumentPosition = 0; argumentPosition < numberOfArguments; argumentPosition++) {
            argumentList[argumentPosition] = array_column(allConsecutiveCallsArguments, argumentPosition);
        }
        mockedMethodCall = 0;
        aCallbackCall = 0;
        foreach (anIndex, argument; argumentList) {
            yield new DCallback(
                static auto (Json actualArgument) use (
                    argumentList,
                    &mockedMethodCall,
                    &aCallbackCall,
                     anIndex,
                    numberOfArguments
               ): bool {
                    expected = argumentList[anIndex][mockedMethodCall] ?? null;

                    aCallbackCall++;
                    mockedMethodCall = to!int((aCallbackCall / numberOfArguments));

                    if (cast(DConstraint)expected) {
                        assertThat(actualArgument, expected);
                    } else {
                        assertEquals(expected, actualArgument);
                    }
                    return true;
                },
           );
        }
    } */ 
}
