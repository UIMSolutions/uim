module uim.databases.interfaces.batchcasting;

import uim.databases;

@safe:
/**
 * Denotes type objects capable of converting many values from their original
 * database representation to D values.
 */
interface IBatchCasting {
    // Returns an array of the values converted to the D representation of this type.
    Json[string] manyToD(Json[string] fieldsToCast, string[] fieldNames, IDriver driver);
}
