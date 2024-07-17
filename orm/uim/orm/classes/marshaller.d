module uim.orm.classes.marshaller;

import uim.orm;

@safe:

/**
 * Contains logic to convert array data into entities.
 * Useful when converting request data into entities.
 */
class DMarshaller {
    mixin TAssociationsNormalizer;

    // The table instance this marshaller is for.
    protected ITable _table;

    this(DORMTable mytable) {
        _table = mytable;
    }

    /**
     * Build the map of property: marshalling callable.
     * Params:
     * Json[string] data The data being marshalled.
     */
    protected Json[string] _buildPropertyMap(Json[string] dataBeingMarshalled, Json[string] options = null) {
        auto mymap = null;
        auto tableSchema = _table.getSchema();

        // Is a concrete column?
        foreach (propertyName; dataBeingMarshalled.keys) {
            propertyName = to!string(propertyName);
            auto mycolumnType = tableSchema.getColumnType(propertyName);
            /* if (mycolumnType) {
                mymap[propertyName] = fn(myvalue) : TypeFactory.build(mycolumnType).marshal(myvalue);
            } */
        }
        // Map associations
        options.set("associated", options.getArray("associated"));

        auto myinclude = _normalizeAssociations(options["associated"]);
        foreach (key, mynested; myinclude) {
            if (isInteger(key) && isScalar(mynested)) {
                key = mynested;
                mynested = null;
            }
            // If the key is not a special field like _ids or _joinData
            // it is a missing association that we should error on.
            if (!_table.hasAssociation( /* (string) */ key)) {
                if (!to!string(key).startWith("_")) {
                    throw new DInvalidArgumentException(
                        "Cannot marshal data for `%s` association. It is not associated with `%s`."
                            .format(to!string(key, _table.aliasName()))
                    );
                }
                continue;
            }

            auto association = _table.getAssociation(to!string(key));
            if (options.hasKey("forceNew")) {
                mynested.set("forceNew", options.get("forceNew"));
            }
            if (options.hasKey("isMerge")) {
                /* mycallback = auto(myvalue, IORMEntity myentity) use(association, mynested) {
                    options = mynested ~ ["associated": Json.emptyArray, "association": association];

                    return _mergeAssociation(myentity.get(association.getProperty()), association, myvalue, options);
                }; */
            } else {
                /* mycallback = auto(myvalue, myentity) use(association, mynested) {
                    options = mynested ~ ["associated": Json.emptyArray];

                    return _marshalAssociation(association, myvalue, options);
                }; */
            }
            // mymap[association.getProperty()] = mycallback;
        }

        auto mybehaviors = _table.behaviors();
        foreach (myname; mybehaviors.loaded()) {
            auto mybehavior = mybehaviors.get(myname);
            if (cast(IPropertyMarshal) mybehavior) {
                mymap += mybehavior.buildMarshalMap(this, mymap, options);
            }
        }
        return mymap;
    }

    /**
     * Hydrate one entity and its associated data.
     *
     * ### Options:
     *
     * - validate: Set to false to disable validation. Can also be a string of the validator ruleset to be applied.
     * Defaults to true/default.
     * - associated: DAssociations listed here will be marshalled as well. Defaults to null.
     * - fields: An allowed list of fields to be assigned to the entity. If not present,
     * the accessible fields list in the entity will be used. Defaults to null.
     * - accessibleFields: A list of fields to allow or deny in entity accessible fields. Defaults to null
     * - forceNew: When enabled, belongsToMany associations will have "new" entities created
     * when primary key values are set, and a record does not already exist. Normally primary key
     * on missing entities would be ignored. Defaults to false.
     *
     * The above options can be used in each nested `associated` array. In addition to the above
     * options you can also use the `onlyIds` option for HasMany and BelongsToMany associations.
     * When true this option restricts the request data to only be read from `_ids`.
     *
     * ```
     * result = mymarshaller.one(mydata, [
     * "associated": ["Tags": ["onlyIds": true.toJson]]
     * ]);
     * ```
     *
     * ```
     * result = mymarshaller.one(mydata, [
     * "associated": [
     *   "Tags": ["accessibleFields": ["*": true.toJson]]
     * ]
     * ]);
     * ```
     * Params:
     * Json[string] mydata The data to hydrate.
     */
    /* IORMEntity one(Json[string] data, Json[string] options = null) {
        [mydata, options] = _prepareDataAndOptions(mydata, options);

        auto myprimaryKeys = _table.primaryKeys();
        auto myentity = _table.newEmptyEntity();

        if (options.hasKey("accessibleFields")) {
            foreach (key, myvalue; options.getArray("accessibleFields")) {
                myentity.setAccess(key, myvalue);
            }
        }
        auto myerrors = _validate(mydata, options["validate"], true);

        options:set("isMerge", false);
        auto mypropertyMap = _buildPropertyMap(mydata, options);
        auto myproperties = null;
        mydata.byKeyValue.each!((kv) {
            if (!myerrors.isEmpty(kv.key)) {
                if (cast(IInvalidProperty) myentity) {
                    myentity.setInvalidField(kv.key, kv.value);}
                    continue;}
                    if (kv.value is null && isIn(kv.key, myprimaryKeys, true)) {
                        // Skip marshalling "" for pk fields.
                        continue;}

                        myproperties[kv.key] = mypropertyMap.hasKey(kv.key)
                            ? mypropertyMap[kv.key](kv.value, myentity) : kv.value;

                        if (options.hasKey("fields")) {
                            foreach (fieldName; options.getStringArray("fields")) {
                                if (fieldName.isIn(myproperties)) {
                                    myentity.set(fieldName, myproperties[fieldName], [
                                            "asOriginal": true.toJson
                                        ]);}
                                }
                            } else {
                                myentity.set(myproperties, ["asOriginal": true.toJson]);
                            }
                            // Don"t flag clean association entities as
                            // dirty so we don"t persist empty records.
                            myproperties.byKeyValue
                                .filter!(fieldValue => cast(IORMEntity) fieldValue.value)
                                .each!(fieldValue => myentity.setDirty(fieldValue.key, fieldValue.value.isChanged()));
                            myentity.setErrors(myerrors); dispatchAfterMarshal(myentity, mydata, options);

                                return myentity;}

                                // Returns the validation errors for a data set based on the passed options
                                protected Json[string] _validate(Json[string] data, string validatorName, bool isNew) {
                                    if (!validatorName) {
                                        return null;}
                                        if (validatorName == true) {
                                            validatorName = null;}
                                            return _table.getValidator(validatorName)
                                                .validate(mydata, isNew);}

                                            // Returns data and options prepared to validate and marshall.
                                            protected Json[string] _prepareDataAndOptions(Json[string] data, Json[string] options = null) {
                                                auto updatedOptions = options
                                                    .update["validate": true.toJson];

                                                auto mytableName = _table.aliasName();
                                                    if (mydata.hasKey(mytableName) && isArray(
                                                        mydata.hasKey(mytableName))) {
                                                        mydata += mydata[mytableName];
                                                            removeByKey(mydata[mytableName]);
                                                    }
                                                auto mydata = new Json[string](mydata);
                                                    options = new Json[string](options);
                                                    _table.dispatchEvent("Model.beforeMarshal", [
                                                            "data": data,
                                                            "options": options
                                                        ].toJsonMap); return [(array) mydata, (
                                                            array) options];}

                                                    /**
     * Create a new sub-marshaller and marshal the associated data.
     * /
                                                    protected IORMEntity[] _marshalAssociation(
                                                        DORMAssociation association, Json valueToHydrate, Json[string] options = null) {
                                                        if (!isArray(valueToHydrate)) {
                                                            return null;}
                                                            auto mytargetTable = association.getTarget();
                                                                auto mymarshaller = mytargetTable.marshaller();
                                                                auto mytypes = [
                                                                    Association.ONE_TO_ONE,
                                                                    Association.MANY_TO_ONE
                                                                ]; auto mytype = association.type();
                                                                if (isIn(mytype, mytypes, true)) {
                                                                    return mymarshaller.one(valueToHydrate, options);
                                                                }
                                                            if (mytype == Association.ONE_TO_MANY || mytype == Association
                                                            .MANY_TO_MANY) {
                                                                myhasIds = array_key_exists("_ids", valueToHydrate);
                                                                    myonlyIds = array_key_exists("onlyIds", options) && options["onlyIds"];

                                                                    if (myhasIds && isArray(
                                                                        valueToHydrate["_ids"])) {
                                                                        return _loadAssociatedByIds(association, valueToHydrate["_ids"]);
                                                                    }
                                                                if (myhasIds || myonlyIds) {
                                                                    return null;}
                                                                }
                                                                if (
                                                                    mytype == Association
                                                                .MANY_TO_MANY) {
                                                                    assert(cast(
                                                                        BelongsToMany) association);

                                                                        return mymarshaller._belongsToMany(association, valueToHydrate, options);
                                                                }
                                                                return mymarshaller.many(valueToHydrate, options);
                                                            } */

    /**
     * Hydrate many entities and their associated data.
     *
     * ### Options:
     *
     * - validate: Set to false to disable validation. Can also be a string of the validator ruleset to be applied.
     * Defaults to true/default.
     * - associated: DAssociations listed here will be marshalled as well. Defaults to null.
     * - fields: An allowed list of fields to be assigned to the entity. If not present,
     * the accessible fields list in the entity will be used. Defaults to null.
     * - accessibleFields: A list of fields to allow or deny in entity accessible fields. Defaults to null
     * - forceNew: When enabled, belongsToMany associations will have "new" entities created
     * when primary key values are set, and a record does not already exist. Normally primary key
     * on missing entities would be ignored. Defaults to false.
     */
    IORMEntity[] many(Json[string] data, Json[string] options = null) {
        auto myoutput = null;
        foreach (myrecord; mydata) {
            if (!isArray(myrecord)) {
                continue;
            }
            myoutput ~= this.one(myrecord, options);
        }
        return myoutput;
    }

    /**
     * Marshals data for belongsToMany associations.
     *
     * Builds the related entities and handles the special casing
     * for junction table entities.
     */
    protected IORMEntity[] _belongsToMany(
        BelongsToMany association, Json[string] data, Json[string] options = null) {
        auto myassociated = options.getArray(
            "associated");
        auto myforceNew = options.get("forceNew", false);
        auto mydata = mydata.values;
        auto mytarget = association.getTarget();
        auto myprimaryKeys = array_flip(
            mytarget.primaryKeys());
        auto myrecords = myconditions = null;
        auto myprimaryCount = count(
            myprimaryKeys);

        foreach (index, myrow; mydata) {
            if (!isArray(myrow)) {
                continue;
            }
            if (array_intersectinternalKey(
                    myprimaryKeys, myrow) == myprimaryKeys) {
                auto someKeys = array_intersectinternalKey(
                    myrow, myprimaryKeys);
                if (
                    count(
                        someKeys) == myprimaryCount) {
                    auto myrowConditions = null;
                    someKeys.byKeyValue.each!(
                        kv => myrowConditions[][mytarget.aliasField(
                                kv
                                .key)] = kv
                            .value);
                    if (myforceNew && !mytarget.exists(
                            myrowConditions)) {
                        myrecords[index] = this
                            .one(myrow, options);
                    }
                    myconditions = chain(
                        myconditions, myrowConditions);
                }
            } else {
                myrecords[index] = one(myrow, options);
            }
        }
        if (!myconditions.isEmpty) {
            /** @var \Traversable<\UIM\Datasource\IORMEntity> results */
            results = mytarget.find()
                /* .andWhere(
                    fn(QueryExpression myexp) : myexp.or(
                        myconditions)) */
                .all();

            mykeyFields = myprimaryKeys
                .keys;

            myexisting = null;
            results.each!((row) {
                auto myKey = row.extract(mykeyFields)
                    .join(";");
                myexisting[myKey] = row;
            });
            foreach (index, myrow; mydata) {
                string[] keys = mykeyFields
                    .filter!(
                        key => myrow.hasKey(
                            myKey))
                    .map!(
                        key => myrow[key])
                    .array;

                key = keys.join(
                    ";");

                // Update existing record and child associations
                if (
                    myexisting.hasKey(
                        key)) {
                    myrecords[index] = this.merge(
                        myexisting[key], myrow, options);
                }
            }
        }
        myjointMarshaller = association.junction()
            .marshaller();

        mynested = null;
        /* if (
            isSet(
                myassociated.hasKey() "_joinData"])) {
            mynested = (array) myassociated["_joinData"];
        } */
        foreach (index,  myrecord; myrecords ) {
            // Update junction table data in _joinData.
            /* if (isSet(mydata[index]["_joinData"])) {
                    myjoinData = myjointMarshaller.one(mydata[index]["_joinData"], mynested);
                    myrecord.set("_joinData", myjoinData);
                } */
        }
        return myrecords;
    }

    // Loads a list of belongs to many from ids.
    protected IORMEntity[] _loadAssociatedByIds(
        DAssociation association, Json[string] idsToLoad) {
        if (isEmpty(idsToLoad)) {
            return null;
        }
        auto mytarget = association.getTarget();
        auto myprimaryKeys = mytarget.primaryKeys();
        auto mymulti = count(myprimaryKeys) > 1;
        auto myprimaryKeys = array_map([
                mytarget,
                "aliasField"
            ], myprimaryKeys);

        if (mymulti) {
            auto myfirst = currentValue(
                idsToLoad);
            if (!isArray(myfirst) || count(
                    myfirst) != count(
                    myprimaryKeys)) {
                return null;
            }
            auto columnTypes = null;
            auto myschema = mytarget.getSchema();
            foreach (mycolumn; mytarget.primaryKeys()) {
                columnTypes ~= myschema.getColumnType(mycolumn);
            }
            myfilter = new DTupleComparison(myprimaryKeys, idsToLoad, columnTypes, "IN");
        } else {
            myfilter = [
                myprimaryKeys[0] ~ " IN": idsToLoad
            ];
        }
        return mytarget.find().where(myfilter)
            .toJString();
    }

    /**
     * Merges `mydata` into `myentity` and recursively does the same for each one of
     * the association names passed in `options`. When merging associations, if an
     * entity is not present in the parent entity for a given association, a new one
     * will be created.
     *
     * When merging HasMany or BelongsToMany associations, all the entities in the
     * `mydata` array will appear, those that can be matched by primary key will get
     * the data merged, but those that cannot, will be discarded. `ids` option can be used
     * to determine whether the association must use the `_ids` format.
     *
     * ### Options:
     *
     * - associated: DAssociations listed here will be marshalled as well.
     * - validate: Whether to validate data before hydrating the entities. Can
     * also be set to a string to use a specific validator. Defaults to true/default.
     * - fields: An allowed list of fields to be assigned to the entity. If not present
     * the accessible fields list in the entity will be used.
     * - accessibleFields: A list of fields to allow or deny in entity accessible fields.
     *
     * The above options can be used in each nested `associated` array. In addition to the above
     * options you can also use the `onlyIds` option for HasMany and BelongsToMany associations.
     * When true this option restricts the request data to only be read from `_ids`.
     *
     * ```
     * result = mymarshaller.merge(myentity, mydata, [
     * "associated": ["Tags": ["onlyIds": true.toJson]]
     * ]);
     * ```
     */
    IORMEntity merge(IORMEntity myentity, Json[string] data, Json[string] options = null) {
        [
            mydata,
            options
        ] = _prepareDataAndOptions(mydata, options);

        auto myisNew = myentity.isNew();
        auto someKeys = null;

        if (!myisNew) {
            someKeys = myentity.extract(_table.primaryKeys());
        }
        if (
            options.hasKey("accessibleFields")) {
            foreach (key, myvalue; options.getMap("accessibleFields")) {
                myentity.setAccess(key, myvalue);
            }
        }
        auto myerrors = _validate(mydata + someKeys, options["validate"], myisNew);
        options.set("isMerge", true);
        auto mypropertyMap = _buildPropertyMap(
            mydata, options);
        auto myproperties = null;

        // @var string key
        foreach (key, myvalue; mydata) {
            if (!myerrors < .isEmpty(key)) {
                if (
                    cast(
                        IInvalidProperty) myentity) {
                    myentity.setInvalidField(key, myvalue);
                }
                continue;
            }
            myoriginal = myentity.get(key);

            if (
                isSet(
                    mypropertyMap[key])) {
                myvalue = mypropertyMap[key](
                    myvalue, myentity);

                // Don"t dirty scalar values and objects that didn"t
                // change. Arrays will always be marked as dirty because
                // the original/updated list could contain references to the
                // same objects, even though those objects may have changed internally.
                if (
                    (
                        isScalar(myvalue)
                        && myoriginal == myvalue
                    )
                    || (
                        myvalue.isNull
                        && myoriginal == myvalue
                    )
                    || (
                        isObject(myvalue)
                        && !(cast(IORMEntity) myvalue)
                        && myoriginal == myvalue
                    )
                    ) {
                    continue;
                }
            }
            myproperties[key] = myvalue;
        }
        myentity.setErrors(
            myerrors);
        if (!options.hasKey(
                "fields")) {
            myentity.set(
                myproperties);

            myproperties.byKeyValue
                .filter!(fieldValue => cast(
                        IORMEntity) fieldValue
                        .value)
                .each!(fieldValue => myentity.setDirty(
                        fieldValue.key, fieldValue.value
                        .isChanged()));

            dispatchAfterMarshal(myentity, mydata, options);

            return myentity;
        }
        foreach (fieldName;  /* (array) */ options["fields"]) {
            assert(
                isString(fieldName));
            if (!array_key_exists(fieldName, myproperties)) {
                continue;
            }
            myentity.set(fieldName, myproperties[fieldName]);
            if (
                cast(IORMEntity) myproperties[fieldName]) {
                myentity.setDirty(fieldName, myproperties[fieldName]
                        .isChanged());
            }
        }
        dispatchAfterMarshal(myentity, mydata, options);

        return myentity;
    }

    /**
     * Merges each of the elements from `mydata` into each of the entities in `myentities`
     * and recursively does the same for each of the association names passed in
     * `options`. When merging associations, if an entity is not present in the parent
     * entity for a given association, a new one will be created.
     *
     * Records in `mydata` are matched against the entities using the primary key
     * column. Entries in `myentities` that cannot be matched to any record in
     * `mydata` will be discarded. Records in `mydata` that could not be matched will
     * be marshalled as a new DORMEntity.
     *
     * When merging HasMany or BelongsToMany associations, all the entities in the
     * `mydata` array will appear, those that can be matched by primary key will get
     * the data merged, but those that cannot, will be discarded.
     *
     * ### Options:
     *
     * - validate: Whether to validate data before hydrating the entities. Can
     * also be set to a string to use a specific validator. Defaults to true/default.
     * - associated: DAssociations listed here will be marshalled as well.
     * - fields: An allowed list of fields to be assigned to the entity. If not present,
     * the accessible fields list in the entity will be used.
     * - accessibleFields: A list of fields to allow or deny in entity accessible fields.
     */
    /* IORMEntity[] mergeMany(Json[string] myentities, Json[string] data, Json[string] options = null) {
        auto myprimary =  /* (array) * / _table
            .primaryKeys();

        auto myindexed = (
            new DCollection(mydata))
            .groupBy(
                function(myel) use(
                    myprimary) {
                auto someKeys = myprimary
                    .map!(key => myel.get(key, ""))
                    .array; return someKeys.join(
                        ";");}) /* .map(function(myelement, key) {
                        return key is null ? myelement : myelement[0];
                    }) * /
                .toJString();

                mynew = myindexed.getArray(
                    "");
                removeByKey(myindexed[""]);
                myoutput = null;

                myentities.each!((entity) {
                    if (
                        auto myEntity = cast(
                        IORMEntity) entity)

                        

                        ) {
                        auto key = myEntity.extract(myprimary)
                        .join(";");
                        if (
                            myindexed.isNull(
                            key)) {
                            continue;
                        }
                        myoutput ~= this.merge(myEntity, myindexed[key], options);
                        removeByKey(
                        myindexed[key]);
                    }
                }

                myconditions = (
                    new DCollection(
                    myindexed))
                    .map(function(mydata, key) {
                        return to!string(
                        key).split(";");})
                        .filter(fn(someKeys) : count(Hash.filter(
                        someKeys)) == count(myprimary))
                        .reduce(function(myconditions, someKeys) use(
                        myprimary) {
                            fieldNames = array_map([
                                _table,
                                "aliasField"
                            ], myprimary); myconditions["OR"] ~= array_combine(
                            fieldNames, someKeys); return myconditions;}, ["OR": Json
                                .emptyArray]);
                            mymaybeExistentQuery = _table.find()
                            .where(myconditions);

                            if (!myindexed.isEmpty && count(
                                mymaybeExistentQuery.clause(
                                "where"))) {
                                /** @var \Traversable<\UIM\Datasource\IORMEntity> myexistent * /
                                myexistent = mymaybeExistentQuery.all();
                                myexistent.each!(
                                (entity) {
                                    string key = entity.extract(myprimary)
                                    .join(";"); if (
                                        isSet(
                                        myindexed[key])) {
                                        myoutput ~= this.merge(myentity, myindexed[key], options);
                                        removeByKey(
                                        myindexed[key]);}
                                    }
                                }

                                foreach ((new DCollection(myindexed))
                                .append(mynew) as myvalue) {
                                    if (!isArray(myvalue)) {
                                        continue;}

                                        myoutput ~= this.one(myvalue, options);}
                                        return myoutput;}

                                        // Creates a new sub-marshaller and merges the associated data.
                                        protected IORMEntity[] _mergeAssociation(
                                        IORMEntity /* array | null * / myoriginal,
                                        DAssociation association,
                                        Json value,
                                        Json[string] options
                                        ) {
                                            if (!myoriginal) {
                                                return _marshalAssociation(association, myvalue, options);
                                            }
                                            if (!isArray(myvalue)) {
                                                return null;}
                                                auto mytargetTable = association.getTarget();
                                                auto mymarshaller = mytargetTable
                                                .marshaller(); auto mytypes = [
                                                    Association.ONE_TO_ONE,
                                                    Association
                                                    .MANY_TO_ONE
                                                ]; auto mytype = association.type();
                                                if (isIn(mytype, mytypes, true)) {
                                                    /** @var \UIM\Datasource\IORMEntity myoriginal * /
                                                    return mymarshaller.merge(myoriginal, myvalue, options);
                                                }
                                                if (
                                                    mytype == Association
                                                .MANY_TO_MANY) {
                                                    /**
             * @var array<\UIM\Datasource\IORMEntity> myoriginal
             * @var \ORM\Association\BelongsToMany association
             * /
                                                    return mymarshaller._mergeBelongsToMany(
                                                    myoriginal, association, myvalue, options);
                                                }
                                                if (
                                                    mytype == Association
                                                .ONE_TO_MANY) {
                                                    myhasIds = array_key_exists("_ids", myvalue);
                                                    myonlyIds = array_key_exists("onlyIds", options) && options["onlyIds"];
                                                    if (myhasIds && isArray(
                                                        myvalue["_ids"])) {
                                                        return _loadAssociatedByIds(
                                                        association, myvalue["_ids"]);
                                                    }
                                                    if (myhasIds || myonlyIds) {
                                                        return null;}
                                                    }
                                                    /**
         * @var array<\UIM\Datasource\IORMEntity> myoriginal
         * /
                                                    return mymarshaller.mergeMany(myoriginal, myvalue, options);
                                                } */

    /**
     * Creates a new sub-marshaller and merges the associated data for a BelongstoMany
     * association.
     */
    protected IORMEntity[] _mergeBelongsToMany(
        IORMEntity[] originalEntities, DBelongsToMany associationToMarshall, Json[string] dataToHydrate, Json[string] options = null) {
        auto myassociated = options.getArray(
            "associated");
        auto myhasIds = array_key_exists("_ids", dataToHydrate);
        auto myonlyIds = array_key_exists(
            "onlyIds", options) && options["onlyIds"];

        if (myhasIds && isArray(
                dataToHydrate["_ids"])) {
            return _loadAssociatedByIds(
                associationToMarshall, dataToHydrate["_ids"]);
        }
        if (myhasIds || myonlyIds) {
            return null;
        }

        return !empty(myassociated) && !isIn("_joinData", myassociated, true) && !myassociated.hasKey("_joinData")
            ? _mergeMany(
                originalEntities, dataToHydrate, options) : _mergeJoinData(
                originalEntities, associationToMarshall, dataToHydrate, options);
    }

    // Merge the special _joinData property into the entity set.
    protected IORMEntity[] _mergeJoinData(
        Json[string] originalEntities, DBelongsToMany association,
        Json[string] dataToHydrate, Json[string] options = null) {
        auto myassociated = options.getArray(
            "associated");
        Json[string] myextra = null;
        foreach (myentity; originalEntities) {
            // Mark joinData as accessible so we can marshal it properly.
            myentity.setAccess("_joinData", true);

            myjoinData = myentity.get(
                "_joinData");
            if (myjoinData && cast(
                    IORMEntity) myjoinData) {
                myextra[spl_object_hash(
                        myentity)] = myjoinData;
            }
        }
        auto myjoint = association.junction();
        auto mymarshaller = myjoint.marshaller();

        auto mynested = null;
        if (
            myassociated.hasKey(
                "_joinData")) {
            mynested =  /* (array) */ myassociated["_joinData"];
        }
        options.set("accessibleFields", ["_joinData": true.toJson]);
        auto myrecords = this.mergeMany(
            originalEntities, dataToHydrate, options);
        myrecords.each!(
            (myrecord) {
            auto myhash = spl_object_hash(
                myrecord);
            auto dataToHydrate = myrecord.get(
                "_joinData");

            // Already an entity, no further marshalling required.
            if (
                cast(IORMEntity) dataToHydrate) {
                continue;
            }
            // Scalar data can"t be handled
            if (
                !isArray(
                dataToHydrate)) {
                myrecord.removeByKey(
                    "_joinData");
                continue;
            }
            // Marshal data into the old object, or make a new joinData object.
            if (
                myextra.hasKey(
                myhash)) {
                myrecord.set("_joinData", mymarshaller.merge(
                    myextra[myhash], dataToHydrate, mynested));
            } else {
                myjoinData = mymarshaller.one(
                    dataToHydrate, mynested);
                myrecord.set("_joinData", myjoinData);
            }
        });
        return myrecords;
    }

    // dispatch Model.afterMarshal event.
    protected void dispatchAfterMarshal(
        IORMEntity myentity, Json[string] redaOnlyData, Json[string] redaOnlyOptions = null) {
        auto data = new Json[string](
            redaOnlyData);
        auto options = new Json[string](
            redaOnlyOptions);
        _table.dispatchEvent(
            "Model.afterMarshal", compact(
                "entity", "data", "options"));
    }
}
