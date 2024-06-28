module uim.databases.interfaces.batchcasting;

import uim.databases;

@safe:
/**
 * Denotes type objects capable of converting many values from their original
 * database representation to UIM values.
 */
interface IBatchCasting {
    // Returns an array of the values converted to the UIM representation of this type.
    Json[string] manyToD(Json[string] fieldsToCast, string[] fieldNames, IDriver driver);
}
