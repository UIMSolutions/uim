/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.behaviors.timestamp;


@safe:
import uim.orm;

/* use DateTimeInterface;
use RuntimeException;
use UnexpectedValueException; */

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
     * @var array<string, mixed>
     */
    protected _defaultConfig = [
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

    /**
     * Current timestamp
     *
     * @var DORMI18n\FrozenTime|null
     */
    protected _ts;

    /**
     * Initialize hook
     *
     * If events are specified - do *not* merge them with existing events,
     * overwrite the events to listen on
     *
     * @param array<string, mixed> myConfiguration The config for this behavior.
     */
    void initialize(Json myConfiguration) {
        if (isset(myConfiguration["events"])) {
            this.setConfig("events", myConfiguration["events"], false);
        }
    }

    /**
     * There is only one event handler, it can be configured to be called for any event
     *
     * @param DORMevents.IEvent event Event instance.
     * @param DORMDatasource\IEntity anEntity Entity instance.
     * @throws \UnexpectedValueException if a field"s when value is misdefined
     * @return true Returns true irrespective of the behavior logic, the save will not be prevented.
     * @throws \UnexpectedValueException When the value for an event is not "always", "new" or "existing"
     */
    bool handleEvent(IEvent event, IEntity anEntity) {
        eventName = event.getName();
        events = _config["events"];

        new = entity.isNew() != false;
        refresh = _config["refreshTimestamp"];

        foreach (events[eventName] as field: when) {
            if (!in_array(when, ["always", "new", "existing"], true)) {
                throw new UnexpectedValueException(sprintf(
                    "When should be one of "always", "new" or "existing". The passed value '%s' is invalid",
                    when
                ));
            }
            if (
                when == "always" ||
                (
                    when == "new" &&
                    new
                ) ||
                (
                    when == "existing" &&
                    !new
                )
            ) {
                _updateField(entity, field, refresh);
            }
        }

        return true;
    }

    /**
     * implementedEvents
     *
     * The implemented events of this behavior depend on configuration
     *
     * @return array<string, mixed>
     */
    array implementedEvents() {
        return array_fill_keys(_config["events"].keys, "handleEvent");
    }

    /**
     * Get or set the timestamp to be used
     *
     * Set the timestamp to the given DateTime object, or if not passed a new DateTime object
     * If an explicit date time is passed, the config option `refreshTimestamp` is
     * automatically set to false.
     *
     * @param \DateTimeInterface|null ts Timestamp
     * @param bool refreshTimestamp If true timestamp is refreshed.
     * @return DORMI18n\FrozenTime
     */
    function timestamp(?DateTimeInterface ts = null, bool refreshTimestamp = false): DateTimeInterface
    {
        if (ts) {
            if (_config["refreshTimestamp"]) {
                _config["refreshTimestamp"] = false;
            }
            _ts = new FrozenTime(ts);
        } elseif (_ts == null || refreshTimestamp) {
            _ts = new FrozenTime();
        }

        return _ts;
    }

    /**
     * Touch an entity
     *
     * Bumps timestamp fields for an entity. For any fields configured to be updated
     * "always" or "existing", update the timestamp value. This method will overwrite
     * any pre-existing value.
     *
     * @param DORMDatasource\IEntity anEntity Entity instance.
     * @param string eventName Event name.
     * @return bool true if a field is updated, false if no action performed
     */
    bool touch(IEntity anEntity, string eventName = "Model.beforeSave") {
        events = _config["events"];
        if (empty(events[eventName])) {
            return false;
        }

        return = false;
        refresh = _config["refreshTimestamp"];

        foreach (events[eventName] as field: when) {
            if (in_array(when, ["always", "existing"], true)) {
                return = true;
                entity.setDirty(field, false);
                _updateField(entity, field, refresh);
            }
        }

        return return;
    }

    /**
     * Update a field, if it hasn"t been updated already
     *
     * @param DORMDatasource\IEntity anEntity Entity instance.
     * @param string field Field name
     * @param bool refreshTimestamp Whether to refresh timestamp.
     */
    protected void _updateField(IEntity anEntity, string field, bool refreshTimestamp) {
        if (entity.isDirty(field)) {
            return;
        }

        ts = this.timestamp(null, refreshTimestamp);

        columnType = this.table().getSchema().getColumnType(field);
        if (!columnType) {
            return;
        }

        /** @var DDBType\DateTimeType type */
        type = TypeFactory::build(columnType);

        if (!type instanceof DateTimeType) {
            throw new RuntimeException("TimestampBehavior only supports columns of type DateTimeType.");
        }

        class = type.getDateTimeClassName();

        entity.set(field, new class(ts));
    }
}
