module uim.orm.classes.entity;

import uim.orm;

@safe:

/**
 * An entity represents a single result row from a repository. It exposes the
 * methods for retrieving and storing properties associated in this row.
 */
class DORMEntity { // }: IORMEntity, IInvalidProperty {
    mixin TEntity();

    /**
     * Initializes the internal properties of this entity out of the
     * keys in an array. The following list of options can be used:
     *
     * - useSetters: whether use internal setters for properties or not
     * - markClean: whether to mark all properties as clean after setting them
     * - markNew: whether this instance has not yet been persisted
     * - guard: whether to prevent inaccessible properties from being set (default: false)
     * - source: A string representing the alias of the repository this entity came from
     *
     * ### Example:
     *
     * ```
     * myentity = new DORMEntity(["id": 1, "name": "Andrew"])
     * ```
     */
    this(Json[string] properties = [], Json[string] options = null) {
        auto updatedOptions = options.merge([
            "useSetters": true.toJson,
            "markClean": false.toJson,
            "markNew": Json(null),
            "guard": false.toJson,
            "source": Json(null),
        ]);

        if (!options.isEmpty("source")) {
            setSource(options.get("source"));
        }
        if (!options.isNull("markNew")) {
            setNew(options.get("markNew"]);
        }
        if (!properties.isEmpty) {
            //Remember the original field names here.
            setOriginalField(properties.keys);

            if (options.hasKey("markClean") && !options.hasKey("useSetters")) {
               _fields = properties;
                return;
            }
            
            set(properties, [
                "setter": options.get("useSetters"),
                "guard": options.get("guard"),
            ]);
        }
        if (options.hasKey("markClean"]) {
            this.clean();
        }
    }
}
