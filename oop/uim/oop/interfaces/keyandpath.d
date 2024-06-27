module uim.oop.interfaces.keyandpath;

import uim.oop;
@safe:

interface IKeyAndPath {
	// #region paths
		string[][] path();

		bool hasAnyPaths(string[][] paths);

		bool hasAllPaths(string[][] paths);

		bool hasPath(string[] path);
	// #endregion paths

    // #region keys
		string[] keys();

		bool hasAllKeys(string[] keys);

		bool hasAnyKeys(string[] keys);

		bool hasKey(string key);
	// #endregion keys
}