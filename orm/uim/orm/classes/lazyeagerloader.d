module uim.orm.classes.lazyeagerloader;

import uim.orm;

@safe:

/**
 * Contains methods that are capable of injecting eagerly loaded associations into
 * entities or lists of entities by using the same syntax as the EagerLoader.
 *
 * @internal
 */
class DLazyEagerLoader {
    /**
     * Loads the specified associations in the passed entity or list of entities
     * by executing extra queries in the database and merging the results in the
     * appropriate properties.
     *
     * The properties for the associations to be loaded will be overwritten on each entity.
     */
    IORMEntity[] loadInto(IORMEntity[] myentities, Json[string] associationsToLoad, DORMTable sourceTable) {
        auto resultSingle = false;

        if (cast(IORMEntity)myentities) {
            myentities = [myentities];
            resultSingle = true;
        }
        auto query = _getQuery(myentities, associationsToLoad, sourceTable);
        auto myassociations = query.getContain().keys;
        auto myentities = _injectResults(myentities, query, myassociations, sourceTable);

        /** @var \UIM\Datasource\IORMEntity|array<\UIM\Datasource\IORMEntity> */
        return resultSingle ? array_shift(myentities): myentities;
    }
    
    /**
     * Builds a query for loading the passed list of entity objects along with the
     * associations specified in associationsToLoad.
     */
    protected ISelectQuery _getQuery(IORMEntity[] myentities, Json[string] associationsToLoad, DORMTable sourceTable) {
        auto myprimaryKey = sourceTable.primaryKeys();
        auto mymethod = isString(myprimaryKey) ? "get" : "extract";
        auto someKeys = Hash.map(myentities, "{*}", fn (IORMEntity myentity): myentity.{mymethod}(myprimaryKey));

        auto myquery = sourceTable
            .find()
            .select(/* (array) */myprimaryKey)
            .where(function (QueryExpression myexp, SelectQuery myq) use (myprimaryKey, someKeys, sourceTable) {
                if (isArray(myprimaryKey) && count(myprimaryKey) == 1) {
                    myprimaryKey = currentValue(myprimaryKey);
                }
                if (isString(myprimaryKey)) {
                    return myexp.in(sourceTable.aliasField(myprimaryKey), someKeys);
                }
                mytypes = array_intersectinternalKey(myq.getDefaultTypes(), array_flip(myprimaryKey));
                myprimaryKey = array_map([sourceTable, "aliasField"], myprimaryKey);

                return new DTupleComparison(myprimaryKey, someKeys, mytypes, "IN");
            })
            .enableAutoFields()
            .contain(associationsToLoad);

        foreach (myquery.getEagerLoader().attachableAssociations(sourceTable) as myloadable) {
            configData = myloadable.configuration.data;
            configuration.get("includeFields"] = true;
            myloadable.configuration.update(configData);
        }
        return myquery;
    }

    /**
     * Returns a map of property names where the association results should be injected
     * in the top level entities.
     */
    protected string[] _getPropertyMap(DORMTable sourceTable, Json[string] associations) {
        auto propertyMap = null;
        auto mycontainer = sourceTable.associations();
        foreach (myassoc; associations) {
            myassociation = mycontainer.get(myassoc);
            propertyMap[myassoc] = myassociation.getProperty();
        }
        return propertyMap;
    }
    
    // Injects the results of the eager loader query into the original list of entities.
    protected IORMEntity[] _injectResults(
        IORMEntity[] myentities,
        DSelectQuery selectQuery,
        Json[string] myassociations,
        DORMTable sourceTable
   ) {
        auto myinjected = null;
        auto myproperties = _getPropertyMap(sourceTable, myassociations);
        auto myprimaryKey = /* (array) */sourceTable.primaryKeys();
        /** @var array<\UIM\Datasource\IORMEntity> results */
        /* auto results = selectQuery
            .all()
            .indexBy(IORMEntity mye => mye.extract(myprimaryKey).join(";"))
            .toJString();

        myentities.byKeyValue
            .each!((kv) {
            aKey = myobject.extract(myprimaryKey).join(";");
            if (results.isNull(aKey)) {
                myinjected[myKey] = myobject;
                continue;
            }
            myloaded = results[aKey];
            foreach (myassoc; myassociations) {
                myproperty = myproperties[myassoc];
                myobject.set(myproperty, myloaded.get(myproperty), ["useSetters": false.toJson]);
                myobject.setDirty(myproperty, false);
            }
            myinjected[myKey] = myobject;
        });

        return myinjected; */
        return null; 
    }
}
