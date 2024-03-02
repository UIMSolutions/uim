module uim.orm;

import uim.orm;

@safe:

/**
 * An entity represents a single result row from a repository. It exposes the
 * methods for retrieving and storing properties associated in this row.
 */
class Entity : IEntity, IInvalidProperty {
    mixin EntityTemplate();

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
     * myentity = new Entity(["id": 1, "name": "Andrew"])
     * ```
     * Params:
     * IData[string] myproperties hash of properties to set in this entity
     * @param IData[string] options list of options to use when creating this entity
     */
    this(array myproperties = [], IData[string] optionData = null) {
        options += [
            "useSetters": true,
            "markClean": false,
            "markNew": null,
            "guard": false,
            "source": null,
        ];

        if (!options["source"].isEmpty) {
            this.setSource(options["source"]);
        }
        if (!options["markNew"].isNull) {
            this.setNew(options["markNew"]);
        }
        if (!empty(myproperties)) {
            //Remember the original field names here.
            this.setOriginalField(myproperties.keys);

            if (options["markClean"] && !options["useSetters"]) {
               _fields = myproperties;

                return;
            }
            this.set(myproperties, [
                "setter": options["useSetters"],
                "guard": options["guard"],
            ]);
        }
        if (options["markClean"]) {
            this.clean();
        }
    }
}
