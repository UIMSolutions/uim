/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.loaders.selectwithpivot;

import uim.orm;

@safe:


/**
 * : the logic for loading an association using a SELECT query and a pivot table
 *
 * @internal
 */
class DSelectWithPivotLoader : DSelectLoader {
    // he name of the junction association
    protected string junctionAssociationName;

    // The property name for the junction association, where its results should be nested at.
    protected string junctionProperty;

    // The junction association instance
    protected DHasManyAssociation junctionAssoc;

    /**
     * Custom conditions for the junction association
     *
     * @var DDBIExpression|\Closure|array|string
     */
    protected junctionConditions;

    /*
    this(Json[string] options = null) {
        super((options);
        this.junctionAssociationName = options["junctionAssociationName"];
        _junctionProperty = options["junctionProperty"];
        this.junctionAssoc = options["junctionAssoc"];
        this.junctionConditions = options["junctionConditions"];
    }

    /**
     * Auxiliary function to construct a new Query object to return all the records
     * in the target table that are associated to those specified in options from
     * the source table.
     *
     * This is used for eager loading records on the target table based on conditions.
     */
    protected DORMQuery _buildQuery(Json[string] options = null) {
        name = this.junctionAssociationName;
        assoc = this.junctionAssoc;
        queryBuilder = false;

        if (!options.isEmpty("queryBuilder"])) {
            queryBuilder = options["queryBuilder"];
            options.remove("queryBuilder"]);
        }

        query = super._buildQuery(options);

        if (queryBuilder) {
            query = queryBuilder(query);
        }

        if (query.isAutoFieldsEnabled() == null) {
            query.enableAutoFields(query.clause("select") is null);
        }

        // Ensure that association conditions are applied
        // and that the required keys are in the selected columns.

        tempName = _aliasName ~ "_CJoin";
        schema = assoc.getSchema();
        joinFields = types = null;

        foreach (schema.typeMap() as f: type) {
            key = tempName ~ "__" ~ f;
            joinFields[key] = "name.f";
            types[key] = type;
        }

        query
            .where(this.junctionConditions)
            .select(joinFields);

        query
            .getEagerLoader()
            .addToJoinsMap(tempName, assoc, false, _junctionProperty);

        assoc.attachTo(query, [
            "aliasPath": assoc.aliasName(),
            "includeFields": false.toJson,
            "propertyPath": _junctionProperty,
        ]);
        query.getTypeMap().addDefaults(types);

        return query;
    }


    protected void _assertFieldsPresent(Query fetchQuery, Json[string] key) {
        // _buildQuery() manually adds in required fields from junction table
    }

    /**
     * Generates a string used as a table field that contains the values upon
     * which the filter should be applied
     */
    protected string[] _linkField(Json[string] options = null) {
        string[] links = null;
        name = this.junctionAssociationName;

        foreach ((array)options["foreignKeys"] as key) {
            links ~=  "%s.%s".format(name, key);
        }

        if (count(links) == 1) {
            return links[0];
        }

        return links;
    }

    /**
     * Builds an array containing the results from fetchQuery indexed by
     * the foreignKeys value corresponding to this association.
     */
    protected Json[string] _buildResultMap(Query fetchQuery, Json[string] options = null) {
        auto resultMap = null;
        auto keys = options.getStringArray("foreignKeys");

        foreach (result; fetchQuery.all()) {
            if (result.isNull(_junctionProperty)) {
                throw new DRuntimeException(format(
                    "'%s' is missing from the belongsToMany results. Results cannot be created.",
                    _junctionProperty
               ));
            }

            auto values = keys.each!(key => result[_junctionProperty][k]);
            resultMap[values.join(";")] ~= result;
        }

        return resultMap;
    }
}
