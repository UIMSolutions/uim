/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.databases.classes.drivers.driver;

import uim.databases;

@safe:

class DDriver : UIMObject, IDriver {
    mixin(DriverThis!());

    // Establishes a connection to the database server.
    IDriver connect() {
        return this;
    }

    // Returns connected server version.
    string currentVersion() {
        return null; 
    }

    // #region startQuote
        // String used to start a database identifier quoting to make it safe
        protected string _startQuote;
        string startQuote() {
            return _startQuote;
        }

        IDriver startQuote(string quote) {
            _startQuote = quote;
            return this;
        }
    // #endregion startQuote

    // #region endQuote
        // String used to end a database identifier quoting to make it safe
        protected string _endQuote;
        string endQuote() {
            return _endQuote;
        }

        IDriver endQuote(string quote) {
            _endQuote = quote;
            return this;
        }
    // #endregion endQuote

    // #region connection
        // Returns correct connection resource or object that is internally used.
        IDatabaseConnection connection() {
            return null;
        }

        // Set the internal connection object.
        IDriver connection(IDatabaseConnection connection) {
            return this;
        }
    // #endregion connection

    // true if it is valid to use this driver
    bool enabled() {
        return false;
    }

    // #region SQL
        string sqlReleaseSavePoint(string name) {
            // SQLServer has no release save point operation.
            return null;
        }

        string sqlDisableForeignKey() {
            return null;
        }

        string sqlEnableForeignKey() {
            return null;
        }
    // #endregion SQL

    // Checks whether the driver is connected.
    bool isConnected() {
        return false;
    }

   // Disconnects from database server. 
    IDriver disconnect() {
        return this;
    }
}
