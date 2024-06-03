module uim.models.interfaces.data;

import uim.models;

@safe:
interface IData {

    // IAttribute attribute();
    string typeName();

    // #region is-check
        // #region is-BasicTypes
            bool isArray();
            void isArray(bool mode);

            bool isBigInt();	 
            void isBigInt(bool mode);

            bool isBool();	 
            void isBool(bool mode);

            bool isFloat();	 
            void isFloat(bool mode);

            bool isInt();	 
            void isInt(bool mode);

            bool isNull();	 
            void isNull(bool mode);

            bool isObject();	 
            void isObject(bool mode);

            bool isString();	 
            void isString(bool mode);
        // #endregion is-BasicTypes

        // #region is-AdditionalTypes
            bool isUUID();
            void isUUID(bool mode);

            bool isNumber();
            void isNumber(bool mode);

            bool isNumeric();
            void isNumeric(bool mode);

            bool isTime();
            void isTime(bool mode);

            bool isDate();
            void isDate(bool mode);

            bool isDatetime();
            void isDatetime(bool mode);

            bool isTimestamp();
            void isTimestamp(bool mode);
        // #region is-AdditionalTypes

        // #region is-General
            bool isScalar();
            void isScalar(bool mode);

            bool isArray();
            void isArray(bool mode);

            bool isEntity();
            void isEntity(bool mode);

            bool isNullable();
            void isNullable(bool mode);

            bool isEmpty();
            void isEmpty(bool mode);

            bool isReadOnly();
            void isReadOnly(bool mode);
        // #region is-General
    // #endregion is-check

    // #region get
        bool getBool();
        int getInt();
        long getLong();
        float getFloat();
        string getString();
        UUID getUUID();
        Json getJson();
    // #region isEqual

    // #region isEqual
        bool isEqual(bool value);
        bool isEqual(int value);
        bool isEqual(long value);
        bool isEqual(float value);
        bool isEqual(double value);
        bool isEqual(string value);
        bool isEqual(UUID value);
        bool isEqual(Json value);
    // #endregion isEqual

    // #region set
        void set(bool value);
        void set(int value);
        void set(long value);
        void set(float value);
        void set(double value);
        void set(string value);
        void set(UUID value);
        void set(Json value);
    // #endregion set

    /* IData at(size_t pos);
    Json toJson();
    string toString();
    string[] toStringArray();
    size_t length();

    bool hasPaths(string[] paths, string separator = "/");
    bool hasPath(string path, string separator = "/");

    bool hasKey(); // One single key
    string key();
    void key(string newKey);

    bool hasAllKeys(string[]); // Has many keys , one or more 
    string[] keys();

    bool hasAllKeys(string[] keys, bool deepSearch = false);
    bool hasKey(string key, bool deepSearch = false);

    bool hasData(IData[string] checkData, bool deepSearch = false);
    bool hasData(IData[] data, bool deepSearch = false);
    bool hasData(IData data, bool deepSearch = false);

    IData value(string key, IData defaultData);

    IData[string] data(string[] keys);
    IData data(string key);
    IData opIndex(string key);

    void data(string key, IData data);
    void opAssignIndex(IData data, string key);

    string toString();
    Json toJson(string[] selectedKeys = null); */
}
