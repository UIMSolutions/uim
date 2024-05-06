module uim.databases.interfaces.batchcasting;

import uim.databases;

@safe:
/**
 * Denotes type objects capable of converting many values from their original
 * database representation to D values.
 */
interface IBatchCasting
{
    /**
     * Returns an array of the values converted to the D representation of
     * this type.
     *
     * @param Json[string] values The original array of values containing the fields to be casted
     * @return Json[string]
     */
    // TODO array manyToD(Json[string] values, string[] fields, IDriver driver);
}
