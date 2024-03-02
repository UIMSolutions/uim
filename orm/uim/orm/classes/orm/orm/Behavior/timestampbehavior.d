module uim.orm.behaviors;

import uim.orm;

@safe:

class TimestampBehavior : Behavior {
    /**
     * Default config
     *
     * These are merged with user-provided config when the behavior is used.
     *
     * events - an event-name keyed array of which fields to update, and when, for a given event
     * possible values for when a field will be updated are "always", "new" or "existing", to set
     * the field value always, only when a new record or only when an existing record.
     *
     * refreshTimestamp - if true (the default) the timestamp used will be the current time when
     * the code is executed, to set to an explicit date time value - set refreshTimetamp to false
     * and call setTimestamp() on the behavior class before use.
     *
     */
    protected IData[string] _defaultConfigData = [
        "implementedFinders": [],
        "implementedMethods": [
            "timestamp": "timestamp",
            "touch": "touch",
        ],
        "events": [
            "Model.beforeSave": [
                "created": "new",
                "modified": "always",
            ],
        ],
        "refreshTimestamp": true,
    ];

    // Current timestamp
    protected DateTime my_ts = null;

    /**
     * Initialize hook
     *
     * If events are specified - do *not* merge them with existing events,
     * overwrite the events to listen on
     * Params:
     * IConfigData[string] configData The config for this behavior.
     */
    bool initialize(IData[string] initData = null) {
        if (configuration.hasKey("events")) {
            configuration.update("events", configData("events"), false);
        }
        return super.initialize(configData);
    }
    
    /**
     * There is only one event handler, it can be configured to be called for any event
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent Event instance.
     * @param \UIM\Datasource\IEntity myentity Entity instance.
     * @throws \UnexpectedValueException if a field"s when value is misdefined
     */
    void handleEvent(IEvent myevent, IEntity myentity) {
        myeventName = myevent.name;
        myevents = configuration.data("events"];

        mynew = myentity.isNew() != false;
        myrefresh = configuration.data("refreshTimestamp"];

        foreach (myfield: mywhen; myevents[myeventName]) {
            if (!in_array(mywhen, ["always", "new", "existing"], true)) {
                throw new UnexpectedValueException(
                    "When should be one of "always", "new" or "existing". The passed value `%s` is invalid."
                    .format(mywhen
                ));
            }
            if (
                mywhen == "always" ||
                (
                    mywhen == "new" &&
                    mynew
                ) ||
                (
                    mywhen == "existing" &&
                    !mynew
                )
            ) {
               _updateField(myentity, myfield, myrefresh);
            }
        }
    }
    
    /**
     * implementedEvents
     *
     * The implemented events of this behavior depend on configuration
     */
    IData[string] implementedEvents() {
        return array_fill_keys(configuration.data("events"].keys, "handleEvent");
    }
    
    /**
     * Get or set the timestamp to be used
     *
     * Set the timestamp to the given DateTime object, or if not passed a new DateTime object
     * If an explicit date time is passed, the config option `refreshTimestamp` is
     * automatically set to false.
     * Params:
     * \IDateTime|null myts Timestamp
     * @param bool myrefreshTimestamp If true timestamp is refreshed.
     */
    DateTime timestamp(?IDateTime myts = null, bool myrefreshTimestamp = false) {
        if (myts) {
            if (configuration.data("refreshTimestamp"]) {
               configuration.data("refreshTimestamp"] = false;
            }
           _ts = new DateTime(myts);
        } else if (_ts.isNull || myrefreshTimestamp) {
           _ts = new DateTime();
        }
        return _ts;
    }
    
    /**
     * Touch an entity
     *
     * Bumps timestamp fields for an entity. For any fields configured to be updated
     * "always" or "existing", update the timestamp value. This method will overwrite
     * any pre-existing value.
     * Params:
     * \UIM\Datasource\IEntity myentity Entity instance.
     * @param string myeventName Event name.
     */
    bool touch(IEntity myentity, string myeventName = "Model.beforeSave") {
        myevents = configuration.data("events"];
        if (isEmpty(myevents[myeventName])) {
            return false;
        }
        result = false;
        myrefresh = configuration.data("refreshTimestamp"];

        foreach (myevents[myeventName] as myfield: mywhen) {
            if (in_array(mywhen, ["always", "existing"], true)) {
                result = true;
                myentity.setDirty(myfield, false);
               _updateField(myentity, myfield, myrefresh);
            }
        }
        return result;
    }
    
    /**
     * Update a field, if it hasn"t been updated already
     * Params:
     * \UIM\Datasource\IEntity myentity Entity instance.
     * @param string myfield Field name
     * @param bool myrefreshTimestamp Whether to refresh timestamp.
     */
    protected void _updateField(IEntity myentity, string myfield, bool myrefreshTimestamp) {
        if (myentity.isDirty(myfield)) {
            return;
        }
        myts = this.timestamp(null, myrefreshTimestamp);

        mycolumnType = this.table().getSchema().getColumnType(myfield);
        if (!mycolumnType) {
            return;
        }
        mytype = TypeFactory.build(mycolumnType);
        assert(
            cast(DateTimeType)mytype,
            "TimestampBehavior only supports columns of type `%s`."
            .format(DateTimeType.classname)
        );

        myclass = mytype.getDateTimeClassName();

        myentity.set(myfield, new myclass(myts));
    }
}
