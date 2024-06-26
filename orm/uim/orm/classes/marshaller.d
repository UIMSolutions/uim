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
     * @param Json[string] options List of options containing the "associated" key.
     */
    protected Json[string] _buildPropertyMap(Json[string] data, Json[string] options) {
        auto mymap = null;
        auto tableSchema = _table.getSchema();

        // Is a concrete column?
        foreach (mydata.keys as myprop) {
            myprop = to!string(myprop);
            mycolumnType = tableSchema.getColumnType(myprop);
            if (mycolumnType) {
                mymap[myprop] = fn(myvalue) : TypeFactory.build(mycolumnType).marshal(myvalue);
            }
        }
        // Map associations
        options.set("associated", options.getArray("associated"));
        myinclude = _normalizeAssociations(options["associated"]);
        foreach (myinclude as aKey : mynested) {
            if (isInteger(aKey) && isScalar(mynested)) {
                aKey = mynested;
                mynested = null;
            }
            // If the key is not a special field like _ids or _joinData
            // it is a missing association that we should error on.
            if (!_table.hasAssociation( /* (string) */ aKey)) {
                if (!to!string(aKey).startWith("_")) {
                    throw new DInvalidArgumentException(
                        "Cannot marshal data for `%s` association. It is not associated with `%s`."
                            .format(to!string(aKey, _table.aliasName()))
                    );
                }
                continue;
            }
            myassoc = _table.getAssociation(to!string(aKey));

            if (options.hasKey("forceNew"])) {
                mynested["forceNew"] = options["forceNew"];
            }
            if (options.hasKey("isMerge"])) {
                mycallback = auto(myvalue, IORMEntity myentity) use(myassoc, mynested) {
                    options = mynested ~ ["associated": Json.emptyArray, "association": myassoc];

                    return _mergeAssociation(myentity.get(myassoc.getProperty()), myassoc, myvalue, options);
                };
            } else {
                mycallback = auto(myvalue, myentity) use(myassoc, mynested) {
                    options = mynested ~ ["associated": Json.emptyArray];

                    return _marshalAssociation(myassoc, myvalue, options);
                };
            }
            mymap[myassoc.getProperty()] = mycallback;
        }
        mybehaviors = _table.behaviors();
        foreach (mybehaviors.loaded() as myname) {
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
     * @param Json[string] options List of options
     */
    IORMEntity one(Json[string] data, Json[string] options = null) {
        [mydata, options] = _prepareDataAndOptions(mydata, options);

        myprimaryKey = (array) _table.primaryKeys();
        myentity = _table.newEmptyEntity();

        if (options.hasKey("accessibleFields"])) {
            foreach ((array) options["accessibleFields"] as aKey : myvalue) {
                myentity.setAccess(aKey, myvalue);
            }
        }
        myerrors = _validate(mydata, options["validate"], true);

        options["isMerge"] = false;
        mypropertyMap = _buildPropertyMap(mydata, options);
        myproperties = null;
        mydata.byKeyValue.each!((kv) {
            if (!myerrors.isEmpty(kv.key)) {
                if (cast(IInvalidProperty) myentity) {
                    myentity.setInvalidField(kv.key, kv.value);
                }
                continue;
            }
            if (kv.value is null && isIn(kv.key, myprimaryKey, true)) {
                // Skip marshalling "" for pk fields.
                continue;
            }

            myproperties[kv.key] = mypropertyMap.hasKey(kv.key)
                ? mypropertyMap[kv.key](kv.value, myentity) : kv.value;

            if (options.hasKey("fields"])) {
                foreach ((array) options["fields"] as fieldName) {
                    if (array_key_exists(fieldName, myproperties)) {
                        myentity.set(fieldName, myproperties[fieldName], [
                                "asOriginal": true.toJson
                            ]);
                    }
                }
            } else {
                myentity.set(myproperties, ["asOriginal": true.toJson]);
            }
            // Don"t flag clean association entities as
            // dirty so we don"t persist empty records.
            myproperties.byKeyValue
                .filter!(fieldValue => cast(IORMEntity) fieldValue.value)
                .each!(fieldValue => myentity.setDirty(fieldValue.key, fieldValue.value.isChanged()));
            myentity.setErrors(myerrors);
            this.dispatchAfterMarshal(myentity, mydata, options);

            return myentity;
        }

        /**
     * Returns the validation errors for a data set based on the passed options
     * Params:
     * Json[string] data The data to validate.
     * @param string myvalidator Validator name or `true` for default validator.
     * @param bool myisNew Whether it is a new DORMEntity or one to be updated.
     */
        protected Json[string] _validate(Json[string] data, string myvalidator, bool myisNew) {
            if (!myvalidator) {
                return null;
            }
            if (myvalidator == true) {
                myvalidator = null;
            }
            return _table.getValidator(myvalidator).validate(mydata, myisNew);
        }

        /**
     * Returns data and options prepared to validate and marshall.
     * Params:
     * Json[string] mydata The data to prepare.
     * @param Json[string] options The options passed to this marshaller.
     */
        protected Json[string] _prepareDataAndOptions(Json[string] data, Json[string] options) {
            auto updatedOptions = options.update["validate": true.toJson];

            mytableName = _table.aliasName();
            if (mydata.hasKey(mytableName) && isArray(mydata.hasKey(mytableName))) {
                mydata += mydata[mytableName];
                remove(mydata[mytableName]);
            }
            mydata = new ArrayObject(mydata);
            options = new ArrayObject(options);
            _table.dispatchEvent("Model.beforeMarshal", compact("data", "options"));

            return [(array) mydata, (array) options];
        }

        /**
     * Create a new sub-marshaller and marshal the associated data.
     * Params:
     * \ORM\Association myassoc The association to marshall
     * @param Json aValue The data to hydrate. If not an array, this method will return null.
     * @param Json[string] options List of options.
     */
        protected IORMEntity[] _marshalAssociation(DORMAssociation myassoc, Json aValue, Json[string] options) {
            if (!isArray(myvalue)) {
                return null;
            }
            auto mytargetTable = myassoc.getTarget();
            auto mymarshaller = mytargetTable.marshaller();
            auto mytypes = [Association.ONE_TO_ONE, Association.MANY_TO_ONE];
            auto mytype = myassoc.type();
            if (isIn(mytype, mytypes, true)) {
                return mymarshaller.one(myvalue, options);
            }
            if (mytype == Association.ONE_TO_MANY || mytype == Association.MANY_TO_MANY) {
                myhasIds = array_key_exists("_ids", myvalue);
                myonlyIds = array_key_exists("onlyIds", options) && options["onlyIds"];

                if (myhasIds && isArray(myvalue["_ids"])) {
                    return _loadAssociatedByIds(myassoc, myvalue["_ids"]);
                }
                if (myhasIds || myonlyIds) {
                    return null;
                }
            }
            if (mytype == Association.MANY_TO_MANY) {
                assert(cast(BelongsToMany) myassoc);

                return mymarshaller._belongsToMany(myassoc, myvalue, options);
            }
            return mymarshaller.many(myvalue, options);
        }

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
     * Params:
     * Json[string] data The data to hydrate.
     * @param Json[string] options List of options
     */
        IORMEntity[] many(Json[string] data, Json[string] options = null) {
            auto myoutput = null;
            foreach (mydata as myrecord) {
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
     * Params:
     * \ORM\Association\BelongsToMany myassoc The association to marshal.
     * @param Json[string] data The data to convert into entities.
     * @param Json[string] options List of options.
     */
        protected IORMEntity[] _belongsToMany(BelongsToMany myassoc, Json[string] data, Json[string] options = null) {
            auto myassociated = options.getArray("associated");
            auto myforceNew = options.get("forceNew", false);
            auto mydata = mydata.values;
            auto mytarget = myassoc.getTarget();
            auto myprimaryKey = array_flip(mytarget.primaryKeys());
            auto myrecords = myconditions = null;
            auto myprimaryCount = count(myprimaryKey);

            foreach (index : myrow; mydata) {
                if (!isArray(myrow)) {
                    continue;
                }
                if (array_intersectinternalKey(myprimaryKey, myrow) == myprimaryKey) {
                    someKeys = array_intersectinternalKey(myrow, myprimaryKey);
                    if (count(someKeys) == myprimaryCount) {
                        myrowConditions = null;
                        foreach (someKeys as aKey : myvalue) {
                            myrowConditions[][mytarget.aliasField(aKey)] = myvalue;
                        }
                        if (myforceNew && !mytarget.exists(myrowConditions)) {
                            myrecords[index] = this.one(myrow, options);
                        }
                        myconditions = chain(myconditions, myrowConditions);
                    }
                } else {
                    myrecords[index] = one(myrow, options);
                }
            }
            if (!myconditions.isEmpty) {
                /** @var \Traversable<\UIM\Datasource\IORMEntity> results */
                results = mytarget.find()
                    .andWhere(fn(QueryExpression myexp) : myexp.or(myconditions))
                    .all();

                mykeyFields = myprimaryKey.keys;

                myexisting = null;
                results.each!((row) {
                    auto myKey = row.extract(mykeyFields).join(";");
                    myexisting[myKey] = row;
                });
                foreach (index : myrow; mydata) {
                    string[] keys = mykeyFields
                        .filter!(key => myrow.hasKey(myKey))
                        .map!(key => myrow[key])
                        .array;

                    aKey = keys.join(";");

                    // Update existing record and child associations
                    if (myexisting.hasKey(aKey)) {
                        myrecords[index] = this.merge(myexisting[aKey], myrow, options);
                    }
                }
            }
            myjointMarshaller = myassoc.junction().marshaller();

            mynested = null;
            if (isSet(myassociated.hasKey()"_joinData"])) {
                mynested = (array) myassociated["_joinData"];
            }
            foreach (myrecords as myi : myrecord) {
                // Update junction table data in _joinData.
                /* if (isSet(mydata[myi]["_joinData"])) {
                    myjoinData = myjointMarshaller.one(mydata[myi]["_joinData"], mynested);
                    myrecord.set("_joinData", myjoinData);
                } */
            }
            return myrecords;
        }

        /**
     * Loads a list of belongs to many from ids.
     * Params:
     * \ORM\Association myassoc The association class for the belongsToMany association.
     * @param Json[string] myids The list of ids to load.
     */
        protected IORMEntity[] _loadAssociatedByIds(Association myassoc, Json[string] myids) {
            if (isEmpty(myids)) {
                return null;
            }
            auto mytarget = myassoc.getTarget();
            auto myprimaryKey = (array) mytarget.primaryKeys();
            auto mymulti = count(myprimaryKey) > 1;
            auto myprimaryKey = array_map([mytarget, "aliasField"], myprimaryKey);

            if (mymulti) {
                myfirst = currentValue(myids);
                if (!isArray(myfirst) || count(myfirst) != count(myprimaryKey)) {
                    return null;
                }
                mytype = null;
                myschema = mytarget.getSchema();
                foreach ((array) mytarget.primaryKeys() as mycolumn) {
                    mytype ~= myschema.getColumnType(mycolumn);
                }
                myfilter = new DTupleComparison(myprimaryKey, myids, mytype, "IN");
            } else {
                myfilter = [myprimaryKey[0] ~ " IN": myids];
            }
            return mytarget.find().where(myfilter).toJString();
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
     * Params:
     * \UIM\Datasource\IORMEntity myentity the entity that will get the data merged in
     * @param Json[string] data key value list of fields to be merged into the entity
     * @param Json[string] options List of options.
     */
        IORMEntity merge(IORMEntity myentity, Json[string] data, Json[string] options = null) {
            [mydata, options] = _prepareDataAndOptions(mydata, options);

            myisNew = myentity.isNew();
            someKeys = null;

            if (!myisNew) {
                someKeys = myentity.extract((array) _table.primaryKeys());
            }
            if (options.hasKey("accessibleFields"])) {
                foreach ((array) options["accessibleFields"] as aKey : myvalue) {
                    myentity.setAccess(aKey, myvalue);
                }
            }
            myerrors = _validate(mydata + someKeys, options["validate"], myisNew);
            options["isMerge"] = true;
            mypropertyMap = _buildPropertyMap(mydata, options);
            myproperties = null;

            // @var string aKey
            foreach (aKey, myvalue; mydata) {
                if (!myerrors < .isEmpty(aKey))

                    

                    ) {
                    if (cast(IInvalidProperty) myentity) {
                        myentity.setInvalidField(aKey, myvalue);
                    }
                    continue;
                }
                myoriginal = myentity.get(aKey);

                if (isSet(mypropertyMap[aKey])) {
                    myvalue = mypropertyMap[aKey](myvalue, myentity);

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
                myproperties[aKey] = myvalue;
            }
            myentity.setErrors(myerrors);
            if (!options.hasKey("fields")) {
                myentity.set(myproperties);

                myproperties.byKeyValue
                    .filter!(fieldValue => cast(IORMEntity) fieldValue.value)
                    .each!(fieldValue => myentity.setDirty(fieldValue.key, fieldValue.value.isChanged()));

                this.dispatchAfterMarshal(myentity, mydata, options);

                return myentity;
            }
            foreach ( /* (array) */ options["fields"] as fieldName) {
                assert(isString(fieldName));
                if (!array_key_exists(fieldName, myproperties)) {
                    continue;
                }
                myentity.set(fieldName, myproperties[fieldName]);
                if (cast(IORMEntity) myproperties[fieldName]) {
                    myentity.setDirty(fieldName, myproperties[fieldName].isChanged());
                }
            }
            this.dispatchAfterMarshal(myentity, mydata, options);

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
     * Params:
     * iterable<\UIM\Datasource\IORMEntity> myentities the entities that will get the
     * data merged in
     * @param Json[string] data list of arrays to be merged into the entities
     * @param Json[string] options List of options.
     */
        IORMEntity[] mergeMany(Json[string] myentities, Json[string] data, Json[string] options = null) {
            auto myprimary =  /* (array) */ _table.primaryKeys();

            auto myindexed = (new DCollection(mydata))
                .groupBy(function(myel) use(myprimary) {
                    auto someKeys = myprimary
                        .map!(key => myel.get(key, "")).array;
                    return someKeys.join(";");
                })
                .map(function(myelement, aKey) {
                    return aKey is null ? myelement : myelement[0];
                })
                .toJString();

            mynew = myindexed.getArray("");
            remove(myindexed[""]);
            myoutput = null;

            myentities.each!((entity) {
                if (auto myEntity = cast(IORMEntity) entity)

                    

                    ) {
                    auto aKey = myEntity.extract(myprimary).join(";");
                    if (myindexed.isNull(aKey)) {
                        continue;
                    }
                    myoutput ~= this.merge(myEntity, myindexed[aKey], options);
                    remove(myindexed[aKey]);
                }
            }

            myconditions = (new DCollection(myindexed))
                .map(function(mydata, aKey) {
                    return to!string(aKey).split(";");
                })
                .filter(fn(someKeys) : count(Hash.filter(someKeys)) == count(myprimary))
                .reduce(function(myconditions, someKeys) use(myprimary) {
                    fieldNames = array_map([_table, "aliasField"], myprimary);
                    myconditions["OR"] ~= array_combine(fieldNames, someKeys);

                    return myconditions;
                }, ["OR": Json.emptyArray]);
            mymaybeExistentQuery = _table.find().where(myconditions);

            if (!myindexed.isEmpty && count(mymaybeExistentQuery.clause("where"))) {
                /** @var \Traversable<\UIM\Datasource\IORMEntity> myexistent */
                myexistent = mymaybeExistentQuery.all();
                myexistent.each!((entity) {
                    string key = entity.extract(myprimary).join(";");
                    if (isSet(myindexed[key])) {
                        myoutput ~= this.merge(myentity, myindexed[key], options);
                        remove(myindexed[key]);
                    }
                }
            }
            foreach ((new DCollection(myindexed)).append(mynew) as myvalue) {
                if (!isArray(myvalue)) {
                    continue;
                }
                myoutput ~= this.one(myvalue, options);
            }
            return myoutput;
        }

        /**
     * Creates a new sub-marshaller and merges the associated data.
     * Params:
     * \UIM\Datasource\IORMEntity|array<\UIM\Datasource\IORMEntity>|null myoriginal The original entity
     * @param \ORM\Association myassoc The association to merge
     * @param Json aValue The array of data to hydrate. If not an array, this method will return null.
     * @param Json[string] options List of options.
     */
        protected IORMEntity[] _mergeAssociation(
            IORMEntity | array | null myoriginal,
            Association myassoc,
            Json aValue,
            Json[string] options
        ) {
            if (!myoriginal) {
                return _marshalAssociation(myassoc, myvalue, options);
            }
            if (!isArray(myvalue)) {
                return null;
            }
            auto mytargetTable = myassoc.getTarget();
            auto mymarshaller = mytargetTable.marshaller();
            auto mytypes = [Association.ONE_TO_ONE, Association.MANY_TO_ONE];
            auto mytype = myassoc.type();
            if (isIn(mytype, mytypes, true)) {
                /** @var \UIM\Datasource\IORMEntity myoriginal */
                return mymarshaller.merge(myoriginal, myvalue, options);
            }
            if (mytype == Association.MANY_TO_MANY) {
                /**
             * @var array<\UIM\Datasource\IORMEntity> myoriginal
             * @var \ORM\Association\BelongsToMany myassoc
             */
                return mymarshaller._mergeBelongsToMany(myoriginal, myassoc, myvalue, options);
            }
            if (mytype == Association.ONE_TO_MANY) {
                myhasIds = array_key_exists("_ids", myvalue);
                myonlyIds = array_key_exists("onlyIds", options) && options["onlyIds"];
                if (myhasIds && isArray(myvalue["_ids"])) {
                    return _loadAssociatedByIds(myassoc, myvalue["_ids"]);
                }
                if (myhasIds || myonlyIds) {
                    return null;
                }
            }
            /**
         * @var array<\UIM\Datasource\IORMEntity> myoriginal
         */
            return mymarshaller.mergeMany(myoriginal, myvalue, options);
        }

        /**
     * Creates a new sub-marshaller and merges the associated data for a BelongstoMany
     * association.
     * Params:
     * myoriginal = The original entities list.
     * @param \ORM\Association\BelongsToMany myassoc The association to marshall
     * @param Json[string] myvalue The data to hydrate
     * @param Json[string] options List of options.
     */
        protected IORMEntity[] _mergeBelongsToMany(IORMEntity[] myoriginal, BelongsToMany associationToMarshall, Json[string] myvalue, Json[string] options) {
            auto myassociated = options.getArray("associated");

            auto myhasIds = array_key_exists("_ids", myvalue);
            auto myonlyIds = array_key_exists("onlyIds", options) && options["onlyIds"];

            if (myhasIds && isArray(myvalue["_ids"])) {
                return _loadAssociatedByIds(associationToMarshall, myvalue["_ids"]);
            }
            if (myhasIds || myonlyIds) {
                return null;
            }

            return !empty(myassociated) && !isIn("_joinData", myassociated, true) && !myassociated.hasKey("_joinData")
                ? _mergeMany(myoriginal, myvalue, options) : _mergeJoinData(myoriginal, associationToMarshall, myvalue, options);
        }

        /**
     * Merge the special _joinData property into the entity set.
     * Params:
     * array<\UIM\Datasource\IORMEntity> myoriginal The original entities list.
     * @param \ORM\Association\BelongsToMany myassoc The association to marshall
     * @param Json[string] myvalue The data to hydrate
     * @param Json[string] options List of options.
     */
        protected IORMEntity[] _mergeJoinData(Json[string] myoriginal, BelongsToMany myassoc, Json[string] myvalue, Json[string] options) {
            auto myassociated = options.getArray("associated");
            Json[string] myextra = null;
            foreach (myentity; myoriginal) {
                // Mark joinData as accessible so we can marshal it properly.
                myentity.setAccess("_joinData", true);

                myjoinData = myentity.get("_joinData");
                if (myjoinData && cast(IORMEntity) myjoinData) {
                    myextra[spl_object_hash(myentity)] = myjoinData;
                }
            }
            auto myjoint = myassoc.junction();
            auto mymarshaller = myjoint.marshaller();

            auto mynested = null;
            if (myassociated.hasKey("_joinData")) {
                mynested =  /* (array) */ myassociated["_joinData"];
            }
            options["accessibleFields"] = ["_joinData": true.toJson];

            auto myrecords = this.mergeMany(myoriginal, myvalue, options);
            myrecords.each!((myrecord) {
                auto myhash = spl_object_hash(myrecord);
                auto myvalue = myrecord.get("_joinData");

                // Already an entity, no further marshalling required.
                if (cast(IORMEntity) myvalue) {
                    continue;
                }
                // Scalar data can"t be handled
                if (!isArray(myvalue)) {
                    myrecord.remove("_joinData");
                    continue;
                }
                // Marshal data into the old object, or make a new joinData object.
                if (myextra.hasKey(myhash)) {
                    myrecord.set("_joinData", mymarshaller.merge(myextra[myhash], myvalue, mynested));
                } else {
                    myjoinData = mymarshaller.one(myvalue, mynested);
                    myrecord.set("_joinData", myjoinData);
                }
            });
            return myrecords;
        }

        /**
     * dispatch Model.afterMarshal event.
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity that was marshaled.
     * @param Json[string] data readOnly mydata to use.
     * @param Json[string] options List of options that are readOnly.
     */
        protected void dispatchAfterMarshal(IORMEntity myentity, Json[string] data, Json[string] options = null) {
            auto mydata = new ArrayObject(mydata);
            auto options = new ArrayObject(options);
            _table.dispatchEvent("Model.afterMarshal", compact("entity", "data", "options"));
        }
    }
