module uim.oop.configurations.interface_;

import uim.oop;

@safe:
interface IConfiguration : INamed {
    mixin(IProperty!("IData[string]", "data"));

    // #region default data
        mixin(IProperty!("IData[string]", "defaultData"));

        bool hasDefault(string path);

        void updateDefaults(IData[string] newData);
        void updateDefault(string path, IData newData);

        void mergeDefaults(IData[string] newData);
        void mergeDefault(string path, IData newData);
    // #endregion default data

    // #region paths
        string[] paths();

        bool hasAnyPaths(string[] paths...);
        bool hasAnyPaths(string[] paths);

        bool hasAllPaths(string[] paths...);
        bool hasAllPaths(string[] paths);

        bool has(string path); // Short of hasPath
        bool hasPath(string path);
    // #endregion paths

    // #region values
        bool hasAnyValues(string[] values...);
        bool hasAnyValues(string[] values);

        bool hasAllValues(string[] values...);
        bool hasAllValues(string[] values);

        bool hasValue(string value);
    // #endregion values

    IData get(string path);
    IData[string] get(string[] paths, bool compressMode = true);

    // void set(string path, IData newData);
    // void set(string[] paths, IData[string] newData);

    void update(IData[string] newData, string[] validPaths = null);
    void update(string path, IData newData);

    void merge(IData[string] newData, string[] validPaths = null);
    void merge(string path, IData newData);

    IConfiguration remove(string[] paths);
    IConfiguration remove(string paths);
}
