module uim.databases.classes.drivers.driver;

import uim.databases;

@safe:

class DDriver { // }: IDriver {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    // #region name
        protected string _name;
        string name() {
            return _name;
        }
        void name(string quote) {
            _name = quote;
        }
    // #endregion name

    // #region startQuote
        // String used to start a database identifier quoting to make it safe
        protected string _startQuote;
        string startQuote() {
            return _startQuote;
        }
        void startQuote(string quote) {
            _startQuote = quote;
        }
    // #endregion startQuote

    // String used to end a database identifier quoting to make it safe
    protected string _endQuote;
    string endQuote() {
        return _endQuote;
    }
    void string(string quote) {
        _endQuote = quote;
    }

    void connect() {
    }

    // true if it is valid to use this driver
    bool enabled() {
        return false;
    }

    // #region foreignKeySQL
        string disableForeignKeySQL() {
            return null;
        }

        string enableForeignKeySQL() {
            return null;
        }
    // #endregion foreignKeySQL
}
