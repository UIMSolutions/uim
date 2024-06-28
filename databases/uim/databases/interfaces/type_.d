module uim.databases.interfaces.type_;
import uim.databases;

@safe:
/**
 * Encapsulates all conversion functions for values coming from a database into UIM and
 * going from UIM into a database.
 */
interface IType {
    // Casts given value from a UIM type to one acceptable by a database.
    Json toDatabase(Json valueToConvert, IDriver driver) ;

    // Casts given value from a database type to a UIM equivalent.
    Json ToD(Json valueToConvert, IDriver driver);

    // Get the binding type to use in a PDO statement.
    int toStatement(Json value, IDriver driver);

    /**
     * Marshals flat data into UIM objects.
     *
     * Most useful for converting request data into UIM objects,
     * that make sense for the rest of the ORM/Database layers.
     */
    Json marshal(Json valueToConvert);

    /**
     * Returns the base type name that this class is inheriting.
     *
     * This is useful when extending base type for adding extra functionality,
     * but still want the rest of the framework to use the same assumptions it would
     * do about the base type it inherits from.
     */
    string getBaseType();

    // Returns type identifier name for this object.
    string name();

    /**
     * Generate a new primary key value for a given type.
     *
     * This method can be used by types to create new primary key values
     * when entities are inserted.
     */
    Json newId() ;
}
