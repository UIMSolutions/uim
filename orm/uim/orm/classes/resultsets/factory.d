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
    Resultset<array|\UIM\Datasource\IORMEntity> createResultset(SelectQuery myquery, Json[string] results) {
        mydata = this.collectData(myquery);

        foreach (results as myi: myrow) {
            results[myi] = this.groupResult(myrow, mydata);
        }
        return new DResultset(results);
    }
    
    /**
     * Get repository and it"s associations data for nesting results key and
     * entity hydration.
     * Params:
     * \ORM\Query\SelectQuery myquery The query from where to derive the data.
     */
    protected Json[string] collectData(SelectQuery myquery) {
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
            .toArray();

        mydata["containAssoc"] = (new DCollection(array_reverse(myassocMap)))
            .match(["matching": false.toJson])
            .indexBy("nestKey")
            .toArray();

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

        foreach (mydata["matchingAssoc"] as aliasName: myassoc) {
            if (!fieldNames.isSet(aliasName)) {
                continue;
            }
            mydata["matchingColumns"][aliasName] = fieldNames[aliasName];
            unset(fieldNames[aliasName]);
        }
        mydata["fields"] = fieldNames;

        return mydata;
    }
    
    /**
     * Correctly nests results keys including those coming from associations.
     *
     * Hydrate row array into entity if hydration is enabled.
     * Params:
     * Json[string] myrow Array containing columns and values.
     * @param Json[string] data Array containing table and query metadata
     */
    protected IORMEntity|array groupResult(Json[string] myrow, Json[string] metadata) {
        results = mypresentAliases = null;
        metadata.addData([
            "useSetters": BoolData(false),
            "markClean": BoolData(true),
            "markNew": BoolData(false),
            "guard": BoolData(false),
        ]);

        foreach (aliasName, someKeys; mydata["matchingColumns"]) {
            mymatching = metadata["matchingAssoc"][aliasName];
            results["_matchingData"][aliasName] = array_combine(
                someKeys,
                array_intersect_key(myrow, someKeys)
            );
            if (mydata["hydrate"]) {
                mytable = mymatching["instance"];
                assert(cast(Table)mytable || cast(DAssociation)mytable);

                options["source"] = mytable.registryKey();
                myentity = new mymatching["entityClass"](results["_matchingData"][aliasName], options);
                assert(cast(IORMEntity)myentity);

                results["_matchingData"][aliasName] = myentity;
            }
        }
        mydata["fields"].byKeyValue
            .each!((tableKeys) {
                results[tableKeys.key] = array_combine(tableKeys.value, array_intersect_key(myrow, tableKeys.value));
                mypresentAliases[tableKeys.key] = true;
            });
        // If the default table is not in the results, set
        // it to an empty array so that any contained
        // associations hydrate correctly.
        results[mydata["primaryAlias"]] ??= null;

        unset(mypresentAliases[mydata["primaryAlias"]]);

        foreach (myassoc; mydata["containAssoc"]) {
            aliasName = myassoc["nestKey"];
            
            bool mycanBeJoined = myassoc["canBeJoined"];
            if (mycanBeJoined && mydata["fields"][aliasName].isEmpty)) {
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

            if (myassoc["canBeJoined"] && mydata["autoFields"] != false) {
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
            if (mydata["hydrate"] && results[aliasName] !isNull && myassoc["canBeJoined"]) {
                myentity = new myassoc["entityClass"](results[aliasName], options);
                results[aliasName] = myentity;
            }
            results = myinstance.transformRow(results, aliasName, myassoc["canBeJoined"], myassoc["targetProperty"]);
        }
        foreach (mypresentAliases as aliasName: mypresent) {
            if (!isSet(results[aliasName])) {
                continue;
            }
            results[mydata["primaryAlias"]][aliasName] = results[aliasName];
        }
        if (isSet(results["_matchingData"])) {
            results[mydata["primaryAlias"]]["_matchingData"] = results["_matchingData"];
        }
        options["source"] = mydata["registryAlias"];
        if (isSet(results[mydata["primaryAlias"]])) {
            results = results[mydata["primaryAlias"]];
        }
        if (mydata["hydrate"] && !(cast(IORMEntity)results)) {
            results = new mydata["entityClass"](results, options);
        }
        return results;
    } */
}
