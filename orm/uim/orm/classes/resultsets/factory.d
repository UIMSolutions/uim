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
    /**
     
     * Params:
     * \ORM\Query\SelectQuery<T> myquery Query from where results came.
     * @param Json[string] results Results array.
     */
    IResultset createResultset(SelectQuery resultQuery, Json[string] results) {
        auto collectData = collectData(resultQuery);

        foreach (i, row; results) {
            results[i] = groupResult(row, collectData);
        }
        return new DResultset(results);
    }
    
    /**
     * Get repository and it"s associations data for nesting results key and
     * entity hydration.
     * Params:
     * \ORM\Query\SelectQuery myquery The query from where to derive the data.
     */
    protected Json[string] collectData(DSelectQuery myquery) {
        myprimaryTable = myquery.getRepository();
        mydata = [
            "primaryAlias": myprimaryTable.aliasName(),
            "registryAlias": myprimaryTable.registryKey(),
            "entityClass": myprimaryTable.getEntityClass(),
            "hydrate": myquery.isHydrationEnabled(),
            "autoFields": myquery.isAutoFieldsEnabled(),
            "matchingColumns": Json.emptyArray,
        ];

        myassocMap = myquery.getEagerLoader().associationsMap(myprimaryTable);
        mydata["matchingAssoc"] = (new DCollection(myassocMap))
            .match(["matching": true.toJson])
            .indexBy("alias")
            .toJString();

        mydata["containAssoc"] = (new DCollection(array_reverse(myassocMap)))
            .match(["matching": false.toJson])
            .indexBy("nestKey")
            .toJString();

        fieldNames = null;
        myquery.clause("select").each!((keyField) {
            string key = strip(keyField.key, "[]");

            if (indexOf(key, "__") <= 0) {
                fieldNames.value[mydata["primaryAlias"]][key] = key;
                continue;
            }
            
            string[] parts = split("__", key, 2);
            fieldNames[parts[0]][key] = parts[1];
        });

        mydata["matchingAssoc"].byKeyValues.each!((nameAssoc) {
            if (!fieldNames.hasKey(nameAssoc.key)) {
                continue;
            }
            mydata["matchingColumns"][nameAssoc.key] = fieldNames[nameAssoc.key];
            fieldNames.remove(nameAssoc.key);
        });
        mydata["fields"] = fieldNames;

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
            "useSetters": BoolData(false),
            "markClean": BoolData(true),
            "markNew": BoolData(false),
            "guard": BoolData(false),
        ]);

        foreach (aliasName, someKeys; tableMetadata["matchingColumns"]) {
            mymatching = metadata["matchingAssoc"][aliasName];
            results["_matchingData"][aliasName] = array_combine(
                someKeys,
                array_intersect_key(myrow, someKeys)
            );
            if (tableMetadata["hydrate"]) {
                mytable = mymatching["instance"];
                assert(cast(Table)mytable || cast(DAssociation)mytable);

                options["source"] = mytable.registryKey();
                myentity = new mymatching["entityClass"](results["_matchingData"][aliasName], options);
                assert(cast(IORMEntity)myentity);

                results["_matchingData"][aliasName] = myentity;
            }
        }
        tableMetadata["fields"].byKeyValue
            .each!((tableKeys) {
                results[tableKeys.key] = array_combine(tableKeys.value, array_intersect_key(myrow, tableKeys.value));
                mypresentAliases[tableKeys.key] = true;
            });
        // If the default table is not in the results, set
        // it to an empty array so that any contained
        // associations hydrate correctly.
        results[tableMetadata["primaryAlias"]] ??= null;

        unset(mypresentAliases[tableMetadata["primaryAlias"]]);

        foreach (myassoc; tableMetadata["containAssoc"]) {
            aliasName = myassoc["nestKey"];
            
            bool mycanBeJoined = myassoc["canBeJoined"];
            if (mycanBeJoined && tableMetadata["fields"][aliasName].isEmpty)) {
                continue;
            }
            myinstance = myassoc["instance"];
            assert(cast(DAssociation)myinstance);

            if (!mycanBeJoined && !isSet(myrow[aliasName])) {
                results = myinstance.defaultRowValue(results, mycanBeJoined);
                continue;
            }
            if (!mycanBeJoined) {
                results[aliasName] = myrow[aliasName];
            }
            mytarget = myinstance.getTarget();
            options["source"] = mytarget.registryKey();
            mypresentAliasesm.remove(yalias);

            if (myassoc["canBeJoined"] && tableMetadata["autoFields"] != false) {
                myhasData = false;
                foreach (results[aliasName] as myv) {
                    if (myv !isNull && myv != []) {
                        myhasData = true;
                        break;
                    }
                }
                if (!myhasData) {
                    results[aliasName] = null;
                }
            }
            if (tableMetadata["hydrate"] && results[aliasName] !isNull && myassoc["canBeJoined"]) {
                myentity = new myassoc["entityClass"](results[aliasName], options);
                results[aliasName] = myentity;
            }
            results = myinstance.transformRow(results, aliasName, myassoc["canBeJoined"], myassoc["targetProperty"]);
        }
        foreach (mypresentAliases as aliasName: mypresent) {
            if (!isSet(results[aliasName])) {
                continue;
            }
            results[tableMetadata["primaryAlias"]][aliasName] = results[aliasName];
        }
        if (isSet(results["_matchingData"])) {
            results[tableMetadata["primaryAlias"]]["_matchingData"] = results["_matchingData"];
        }
        options["source"] = tableMetadata["registryAlias"];
        if (isSet(results[tableMetadata["primaryAlias"]])) {
            results = results[tableMetadata["primaryAlias"]];
        }
        if (tableMetadata["hydrate"] && !(cast(IORMEntity)results)) {
            results = new tableMetadata["entityClass"](results, options);
        }
        return results;
        */
        return null; 
    }
}
