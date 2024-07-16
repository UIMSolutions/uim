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
        auto primaryKeys = sourceTable.primaryKeys();
        auto mymethod = isString(primaryKeys) ? "get" : "extract";
        /// auto someKeys = Hash.map(myentities, "{*}", fn (IORMEntity myentity): myentity.{mymethod}(primaryKeys)); 

        ISelectQuery selectQuery = sourceTable
            .find()
            .select(primaryKeys)
            /* .where(function (QueryExpression myexp, SelectQuery myq) use (primaryKeys, someKeys, sourceTable) {
                if (isArray(primaryKeys) && count(primaryKeys) == 1) {
                    primaryKeys = currentValue(primaryKeys);
                }
                if (isString(primaryKeys)) {
                    return myexp.in(sourceTable.aliasField(primaryKeys), someKeys);
                }
                mytypes = array_intersectinternalKey(myq.getDefaultTypes(), array_flip(primaryKeys));
                primaryKeys = array_map([sourceTable, "aliasField"], primaryKeys);

                return new DTupleComparison(primaryKeys, someKeys, mytypes, "IN");
            }) */
            .enableAutoFields()
            .contain(associationsToLoad);

        /* foreach (myloadable; selectQuery.getEagerLoader().attachableAssociations(sourceTable)) {
            configData = myloadable.configuration.data;
            configuration.get("includeFields", true);
            myloadable.configuration.update(configData);
        } */
        return selectQuery;
    }

    /**
     * Returns a map of property names where the association results should be injected
     * in the top level entities.
     */
    protected string[] _getPropertyMap(DORMTable sourceTable, Json[string] associations) {
        auto propertyMap = null;
        auto mycontainer = sourceTable.associations();
        foreach (myassoc; associations) {
            auto myassociation = mycontainer.get(myassoc);
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
        auto primaryKeys = /* (array) */sourceTable.primaryKeys();
        /** @var array<\UIM\Datasource\IORMEntity> results */
        /* auto results = selectQuery
            .all()
            .indexBy(IORMEntity exception => exception.extract(primaryKeys).join(";"))
            .toJString();

        myentities.byKeyValue
            .each!((kv) {
            aKey = myobject.extract(primaryKeys).join(";");
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
