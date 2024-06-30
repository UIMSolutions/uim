module uim.oop.interfaces.keyandpath;

import uim.oop;
@safe:

interface IKeyAndPath {
	// #region paths
		string[][] paths();

		bool hasAnyPaths(string[][] paths);

		bool hasAllPaths(string[][] paths);

		bool hasPath(string[] path);
	// #endregion paths

    // #region keys
		string[] keys();

		bool hasAllKeys(string[] keys...);

		bool hasAllKeys(string[] keys);

		bool hasAnyKeys(string[] keys...);

		bool hasAnyKeys(string[] keys);

		bool hasKey(string key);

        string correctKey(string[] path);

		string correctKey(string key);
	// #endregion keys

	// #region remove
		bool removePaths(string[][] paths); 

		bool removePath(string[] path); 

		bool removeKeys(string[] keys...); 

		bool removeKeys(string[] keys); 

		bool removeKey(string key); 

		void clear(); 
	// #endregion remove
}