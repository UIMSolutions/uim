module uim.oop.tests.unitconsecutivetrait;

import uim.oop;

@safe:

mixin template TUnitConsecutive() {
    /**
     * @param Json[string] firstCallArguments The call arguments
     * @param Json[string] ...consecutiveCallsArguments Additional arguments
     */
    // TODO
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
        foreach (argumentList as  anIndex: argument) {
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
                        self.assertThat(actualArgument, expected);
                    } else {
                        self.assertEquals(expected, actualArgument);
                    }
                    return true;
                },
           );
        }
    } */ 
}
