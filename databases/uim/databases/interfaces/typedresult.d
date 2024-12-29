module uim.databases.interfaces.typedresult;

import uim.databases;

@safe:
// Represents an expression that is known to return a specific type
interface ITypedResult {
    // Return the abstract type this expression will return
    // TODO string getReturnType();

    // Set the return type of the expression
    // TODO void setReturnType(string typeName);
}
