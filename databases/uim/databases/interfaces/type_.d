module uim.databases.interfaces.type_;
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
     * IData aValue Value to be converted to a database equivalent.
     * @param \UIM\Database\Driver driver Object from which database preferences and configuration will be extracted.
     */
    IData toDatabase(IData aValue, IDriver driver) ;

    /**
     * Casts given value from a database type to a D equivalent.
     * Params:
     * IData aValue Value to be converted to D equivalent
     * @param \UIM\Database\Driver driver Object from which database preferences and configuration will be extracted
     */
    IData ToD(IData aValue, IDriver driver);

    /**
     * Get the binding type to use in a PDO statement.
     * Params:
     * IData aValue The value being bound.
     * @param \UIM\Database\Driver driver Object from which database preferences and configuration will be extracted.
     */
    int toStatement(IData aValue, IDriver driver);

    /**
     * Marshals flat data into D objects.
     *
     * Most useful for converting request data into D objects,
     * that make sense for the rest of the ORM/Database layers.
     * Params:
     * IData aValue The value to convert.
     */
    IData marshal(IData aValue);

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
    IData newId() ;
}
