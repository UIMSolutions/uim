/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.classes.entities.entity;

import uim.datasources;

@safe:
/**
 * An entity represents a single result row from a repository. It exposes the
 * methods for retrieving and storing properties associated in this row.
 */
class DDatasourceEntity { // TODO }: JsonsourceEntity { //}, IInvalidProperty {
    mixin TConfigurable; 
    mixin TEntity; 

    // Holds all fields and their values for this entity.
    protected Json[string] _fields;

    // Holds all fields that have been changed and their original values for this entity.
    protected Json[string] _original;

    // List of field names that should not be included in Json or Array representations of this Entity.
    protected string[] _hidden;

    // Indicates whether this entity is yet to be persisted.
    // Entities default to assuming they are new. You can use Table.persisted()
    // to set the new flag on an entity based on records in the database.
    protected bool _new = true;

    /*
     * List of computed or virtual fields that should be included in Json or array
     * representations of this Entity. If a field is present in both _hidden and _virtual
     * the field will not be in the array/Json versions of the entity. */
    protected string[] _virtual = null;

    // Holds a list of the fields that were modified or added after this object was originally created.
    protected bool[string] _changed;

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
     *  entity = new DEntity(["id": 1, "name": "Andrew"])
     * ```
     *
     * @param Json[string] properties hash of properties to set in this entity
     * @param Json[string] options list of options to use when creating this entity
     * /
    /* this(Json[string] properties = null, Json[string] optionData = null) {
        auto updatedOptions = options.update[
            "useSetters": true.toJson,
            "markClean": false.toJson,
            "markNew": null,
            "guard": false.toJson,
            "source": null,
        ];

        if (!(options["source"].isEmpty) {
            setSource(options["source"]);
        }

        if (options["markNew"] != null) {
            setNew(options["markNew"]);
        }

        if (!(properties.isEmpty && options["markClean"] && !options["useSetters"]) {
            _fields = properties;

            return;
        }

        if (!properties.isEmpty) {
            set(properties, [
                "setter": options["useSetters"],
                "guard": options["guard"],
            ]);
        }

        if (options["markClean"]) {
            this.clean();
        }
    } */
}
