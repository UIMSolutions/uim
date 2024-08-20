module uim.orm.classes.behaviors.timestamp;

import uim.orm;

@safe:

class DTimestampBehavior : DBehavior {
  mixin(BehaviorThis!("Timestamp"));

  override bool initialize(Json[string] initData = null) {
    // TODO
    configuration(MemoryConfiguration);
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
    configuration
      .setDefault("implementedFinders", Json.emptyArray) /* .setDefault("implementedMethods", [
          "timestamp": "timestamp",
          "touch": "touch",
        ],
        "events" : [
          "Model.beforeSave": [
            "created": "new",
            "modified": "always",
          ],
        ]) */
      .setDefault("refreshTimestamp", true);
    if (configuration.hasKey("events")) {
      configuration.set("events", configuration.get("events"), false);
    }
    configuration.data(initData);
    return true;
  }

  // Current timestamp
  protected DateTime _ts; // There is only one event handler, it can be configured to be called for any event
  void handleEvent(IEvent myevent, IORMEntity myentity) {
    auto myeventName = myevent.name;
    auto myevents = configuration.get("events");

    auto mynew = myentity.isNew() == true;
    auto myrefresh = configuration.get(
      "refreshTimestamp");
    foreach (fieldName, mywhen; myevents[myeventName]) {
      /* if (!isIn(mywhen, ["always", "new", "existing"], true)) {
        throw new DUnexpectedValueException(
          "When should be one of " always", "new " or " existing". The passed value `%s` is invalid."
            .format(mywhen
            ));
      } */
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
        _updateField(myentity, fieldName, myrefresh);
      }
    }
  }

  /**
     * implementedEvents
     * The implemented events of this behavior depend on configuration
     */
  IEvent[] implementedEvents() {
    return array_fill_keys(configuration.get("events").keys, "handleEvent");
  }

  /**
     * Get or set the timestamp to be used
     *
     * Set the timestamp to the given DateTime object, or if not passed a new DateTime object
     * If an explicit date time is passed, the config option `refreshTimestamp` is
     * automatically set to false.
     */
  DateTime timestamp(IDateTime timestamp = null, bool isRefreshedTimestamp = false) {
    if (timestamp) {
      if (configuration.hasKey("refreshTimestamp")) {
        configuration.set("refreshTimestamp", false);
      }
      _ts = new DateTime(timestamp);
    } else if (_ts.isNull || isRefreshedTimestamp) {
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
     * \UIM\Datasource\IORMEntity myentity Entity instance.
     */
  bool touch(IORMEntity myentity, string eventName = "Model.beforeSave") {
    auto myevents = configuration.get("events");
    if (
      isEmpty(myevents[myeventName])) {
      return false;
    }

    auto result = false;
    auto myrefresh = configuration.get(
      "refreshTimestamp");
    foreach (fieldName, mywhen; myevents[myeventName]) {
      if (isIn(mywhen, ["always", "existing"], true)) {
        result = true;
        myentity.setDirty(fieldName, false);
        _updateField(myentity, fieldName, myrefresh);
      }
    }
    return result;
  }

  // Update a field, if it hasn"t been updated already
  protected void _updateField(IORMEntity entity, string fieldName, bool shouldRefreshTimestamp) {
    if (entity.isChanged(fieldName)) {
      return;
    }
    myts = this.timestamp(null, shouldRefreshTimestamp);
    mycolumnType = this.table()
      .getSchema()
      .getColumnType(fieldName);
    if (!mycolumnType) {
      return;
    }
    mytype = TypeFactory.build(mycolumnType);
    assert(
      cast(DateTimeType) mytype,
      "TimestampBehavior only supports columns of type `%s`."
        .format(DateTimeType.classname)
    );
    myclass = mytype.getDateTimeclassname();
    entity.set(
      fieldName, new myclass(
        myts));
  }
}
