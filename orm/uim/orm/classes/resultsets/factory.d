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
 * @template T of array|\UIM\Datasource\IEntity
 */
class DResultsetFactory {
    /**
     * Constructor
     * Params:
     * \ORM\Query\SelectQuery<T> myquery Query from where results came.
     * @param array results Results array.
     * /
    Resultset<array|\UIM\Datasource\IEntity> createResultset(SelectQuery myquery, array results) {
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
     * /
    // TODO protected array collectData(SelectQuery myquery) {
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
            .match(["matching": BooleanData(true)])
            .indexBy("alias")
            .toArray();

        mydata["containAssoc"] = (new DCollection(array_reverse(myassocMap)))
            .match(["matching": BooleanData(false)])
            .indexBy("nestKey")
            .toArray();

        myfields = null;
        myquery.clause("select").each!((keyField) {
            string key = strip(keyField.key, "[]");

            if (indexOf(key, "__") <= 0) {
                myfields.value[mydata["primaryAlias"]][key] = key;
                continue;
            }
            
            string[] parts = split("__", key, 2);
            myfields[parts[0]][key] = parts[1];
        });

        foreach (mydata["matchingAssoc"] as myalias: myassoc) {
            if (!myfields.isSet(myalias)) {
                continue;
            }
            mydata["matchingColumns"][myalias] = myfields[myalias];
            unset(myfields[myalias]);
        }
        mydata["fields"] = myfields;

        return mydata;
    }
    
    /**
     * Correctly nests results keys including those coming from associations.
     *
     * Hydrate row array into entity if hydration is enabled.
     * Params:
     * array myrow Array containing columns and values.
     * @param array data Array containing table and query metadata
     * /
    protected IEntity|array groupResult(array myrow, Json[string] metadata) {
        results = mypresentAliases = null;
        metadata.addData([
            "useSetters": BoolData(false),
            "markClean": BoolData(true),
            "markNew": BoolData(false),
            "guard": BoolData(false),
        ]);

        foreach (myalias, someKeys; mydata["matchingColumns"]) {
            mymatching = metadata["matchingAssoc"][myalias];
            results["_matchingData"][myalias] = array_combine(
                someKeys,
                array_intersect_key(myrow, someKeys)
            );
            if (mydata["hydrate"]) {
                mytable = mymatching["instance"];
                assert(cast(Table)mytable || cast(DAssociation)mytable);

                options["source"] = mytable.registryKey();
                myentity = new mymatching["entityClass"](results["_matchingData"][myalias], options);
                assert(cast(IEntity)myentity);

                results["_matchingData"][myalias] = myentity;
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
            myalias = myassoc["nestKey"];
            
            bool mycanBeJoined = myassoc["canBeJoined"];
            if (mycanBeJoined && empty(mydata["fields"][myalias])) {
                continue;
            }
            myinstance = myassoc["instance"];
            assert(cast(DAssociation)myinstance);

            if (!mycanBeJoined && !isSet(myrow[myalias])) {
                results = myinstance.defaultRowValue(results, mycanBeJoined);
                continue;
            }
            if (!mycanBeJoined) {
                results[myalias] = myrow[myalias];
            }
            mytarget = myinstance.getTarget();
            options["source"] = mytarget.registryKey();
            mypresentAliasesm.remove(yalias);

            if (myassoc["canBeJoined"] && mydata["autoFields"] != false) {
                myhasData = false;
                foreach (results[myalias] as myv) {
                    if (myv !isNull && myv != []) {
                        myhasData = true;
                        break;
                    }
                }
                if (!myhasData) {
                    results[myalias] = null;
                }
            }
            if (mydata["hydrate"] && results[myalias] !isNull && myassoc["canBeJoined"]) {
                myentity = new myassoc["entityClass"](results[myalias], options);
                results[myalias] = myentity;
            }
            results = myinstance.transformRow(results, myalias, myassoc["canBeJoined"], myassoc["targetProperty"]);
        }
        foreach (mypresentAliases as myalias: mypresent) {
            if (!isSet(results[myalias])) {
                continue;
            }
            results[mydata["primaryAlias"]][myalias] = results[myalias];
        }
        if (isSet(results["_matchingData"])) {
            results[mydata["primaryAlias"]]["_matchingData"] = results["_matchingData"];
        }
        options["source"] = mydata["registryAlias"];
        if (isSet(results[mydata["primaryAlias"]])) {
            results = results[mydata["primaryAlias"]];
        }
        if (mydata["hydrate"] && !(cast(IEntity)results)) {
            results = new mydata["entityClass"](results, options);
        }
        return results;
    } */
}
