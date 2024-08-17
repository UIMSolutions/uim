module uim.orm.classes.resultsets.factory;

import uim.orm;

@safe:

/*
/**
 * Factory class for generation ResulSet instances.
 *
 * It is responsible for correctly nesting result keys reported from the query
 * and hydrating entities.
 *
 * @template T of array|\UIM\Datasource\IORMEntity
 */
class DResultsetFactory {
    IResultset createResultset(DSelectQuery resultQuery, Json[string] results) {
        auto collectData = collectData(resultQuery);

        foreach (i, row; results) {
            results[i] = groupResult(row, collectData);
        }
        return new DResultset(results);
    }
    
    // Get repository and it"s associations data for nesting results key and entity hydration.
    protected Json[string] collectData(DSelectQuery myquery) {
        auto myprimaryTable = myquery.getRepository();
        auto mydata = [
            "primaryAlias": myprimaryTable.aliasName(),
            "registryAlias": myprimaryTable.registryKey(),
            "entityClass": myprimaryTable.getEntityClass(),
            "hydrate": myquery.isHydrationEnabled(),
            "autoFields": myquery.isAutoFieldsEnabled(),
            "matchingColumns": Json.emptyArray,
        ];

        auto myassocMap = myquery.getEagerLoader().associationsMap(myprimaryTable);
        mydata.set("matchingAssoc", (new DCollection(myassocMap))
            .match(["matching": true.toJson])
            .indexBy("alias")
            .toJString());

        mydata.set("containAssoc", (new DCollection(array_reverse(myassocMap)))
            .match(["matching": false.toJson])
            .indexBy("nestKey")
            .toJString());

        string[] fieldNames = null;
        myquery.clause("select").each!((keyField) {
            string key =keyField.key.strip("[]");

            if (indexOf(key, "__") <= 0) {
                fieldNames.value[mydata["primaryAlias"]][key] = key;
                continue;
            }
            
            string[] parts = split("__", key, 2);
            fieldNames[parts[0]][key] = parts[1];
        });

        mydata["matchingAssoc"].byKeyValue.each!((nameAssoc) {
            if (!fieldNames.hasKey(nameAssoc.key)) {
                continue;
            }
            mydata.setPath(["matchingColumns", nameAssoc.key], fieldNames[nameAssoc.key]);
            fieldNames.removeKey(nameAssoc.key);
        });
        mydata.set("fields", fieldNames);

        return mydata;
    }
    
    /**
     * Correctly nests results keys including those coming from associations.
     *
     * Hydrate row array into entity if hydration is enabled.
     * Params:
     * Json[string] myrow Array containing columns and values.
     */
    protected /* IORMEntity|array*/ Json[string] groupResult(Json[string] columnsValues, Json[string] tableMetadata) {
        // TODO
        /* 
        auto results = mypresentAliases = null;
        tableMetadata.addData([
            "useSetters": BooleanData(false),
            "markClean": BooleanData(true),
            "markNew": BooleanData(false),
            "guard": BooleanData(false),
        ]);

        foreach (aliasName, someKeys; tableMetadata["matchingColumns"]) {
            mymatching = metadata["matchingAssoc"][aliasName];
            results["_matchingData"][aliasName] = someKeys.combine(
                intersectinternalKey(myrow, someKeys)
           );
            if (tableMetadata["hydrate"]) {
                mytable = mymatching["instance"];
                assert(cast(Table)mytable || cast(DAssociation)mytable);

                options.set("source", mytable.registryKey());
                myentity = new mymatching["entityClass"](results["_matchingData"][aliasName], options);
                assert(cast(IORMEntity)myentity);

                results["_matchingData"][aliasName] = myentity;
            }
        }
        tableMetadata["fields"].byKeyValue
            .each!((tableKeys) {
                results[tableKeys.key] = tableKeys.value.combine(intersectinternalKey(myrow, tableKeys.value));
                mypresentAliases[tableKeys.key] = true;
            });
        // If the default table is not in the results, set
        // it to an empty array so that any contained
        // associations hydrate correctly.
        results.set(tableMetadata["primaryAlias"], results.get(tableMetadata.getString("primaryAlias"));
        mypresentAliases.removeKey(tableMetadata.getString("primaryAlias"));

        foreach (myassoc; tableMetadata["containAssoc"]) {
            auto aliasName = myassoc.get("nestKey");
            
            bool mycanBeJoined = myassoc["canBeJoined"];
            if (mycanBeJoined && tableMetadata.isEMpty(["fields", aliasName])) {
                continue;
            }
            auto myinstance = myassoc.get("instance");
            auto assert(cast(DAssociation)myinstance);

            if (!mycanBeJoined && !myrow.hasKey(aliasName)) {
                results = myinstance.defaultRowValue(results, mycanBeJoined);
                continue;
            }
            if (!mycanBeJoined) {
                results.set(aliasName, myrow.get(aliasName));
            }
            mytarget = myinstance.getTarget();
            options.set("source", mytarget.registryKey());
            mypresentAliasesm.removeKey(yalias);

            if (myassoc["canBeJoined"] && tableMetadata["autoFields"] == true) {
                myhasData = false;
                foreach (myv; results[aliasName]) {
                    if (myv !is null && myv != []) {
                        myhasData = true;
                        break;
                    }
                }
                if (!myhasData) {
                    results.set(aliasName, Json(null));
                }
            }
            if (tableMetadata["hydrate"] && results[aliasName] !is null && myassoc["canBeJoined"]) {
                myentity = new myassoc["entityClass"](results[aliasName], options);
                results[aliasName] = myentity;
            }
            results = myinstance.transformRow(results, aliasName, myassoc["canBeJoined"], myassoc["targetProperty"]);
        }
        foreach (aliasName, mypresent; mypresentAliases) {
            if (!results.hasKey(aliasName)) {
                continue;
            }
            results.setPath([tableMetadata.getString("primaryAlias"), aliasName], results.get(aliasName));
        }
        if (results.hasKey("_matchingData")) {
            results.setPath([tableMetadata.getString("primaryAlias"), "_matchingData"], results.get("_matchingData"));
        }
        options.set("source", tableMetadata.get("registryAlias"));
        if (auto primaryAlias = tableMetadata.getString("primaryAlias")) {
            results = results[primaryAlias];
        }
        if (tableMetadata["hydrate"] && !(cast(IORMEntity)results)) {
            results = new tableMetadata["entityClass"](results, options);
        }
        return results;
        */
        return null; 
    }
}
