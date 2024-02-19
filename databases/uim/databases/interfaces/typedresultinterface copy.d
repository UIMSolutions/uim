module uim.databases;
/**
 * Represents an expression that is known to return a specific type
 */
interface ITypedResult {
    // Return the abstract type this expression will return
    string getReturnType();

    // Set the return type of the expression
    auto setReturnType(string typeName);
}
