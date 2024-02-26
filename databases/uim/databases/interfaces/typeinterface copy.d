module uim.databases;
import uim.databases;

@safe:
/**
 * Encapsulates all conversion functions for values coming from a database into D and
 * going from D into a database.
 */
interface IType {
    /**
     * Casts given value from a D type to one acceptable by a database.
     * Params:
     * Json aValue Value to be converted to a database equivalent.
     * @param \UIM\Database\Driver driver Object from which database preferences and configuration will be extracted.
     */
    Json toDatabase(Json aValue, Driver driver) ;

    /**
     * Casts given value from a database type to a D equivalent.
     * Params:
     * Json aValue Value to be converted to D equivalent
     * @param \UIM\Database\Driver driver Object from which database preferences and configuration will be extracted
     */
    Json ToD(Json aValue, Driver driver);

    /**
     * Get the binding type to use in a PDO statement.
     * Params:
     * Json aValue The value being bound.
     * @param \UIM\Database\Driver driver Object from which database preferences and configuration will be extracted.
     */
    int toStatement(Json aValue, Driver driver);

    /**
     * Marshals flat data into D objects.
     *
     * Most useful for converting request data into D objects,
     * that make sense for the rest of the ORM/Database layers.
     * Params:
     * Json aValue The value to convert.
     */
    Json marshal(Json aValue);

    /**
     * Returns the base type name that this class is inheriting.
     *
     * This is useful when extending base type for adding extra functionality,
     * but still want the rest of the framework to use the same assumptions it would
     * do about the base type it inherits from.
     */
    string getBaseType();

    /**
     * Returns type identifier name for this object.
     */
    string name();

    /**
     * Generate a new primary key value for a given type.
     *
     * This method can be used by types to create new primary key values
     * when entities are inserted.
     */
    Json newId() ;
}
