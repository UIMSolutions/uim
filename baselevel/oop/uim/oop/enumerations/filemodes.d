/*********************************************************************************************************
	Copyright: © 2018-2025 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.enumerations.filemodes; 

version (test_uim_oop) {
  import std.stdio;
  
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// Specifies how a file is manipulated on disk.
enum FileModes : string {
	/// The file is opened read-only.
	READ = "READ", // = FileOpenMode.read,
	/// The file is opened for read-write random access.
	READWRITE = "READWRITE", // = FileOpenMode.readWrite,
	/** Create the file and open read/write, fails if already existing

		Note that eventcore 0.9.24 or up is required, older versions will fall
		back to `FileMode.read`.
	*/
	CREATE = "CREATE", // = _createFileModeValue!(),
	/// The file is truncated if it exists or created otherwise and then opened for read-write access.
	CREATETRUNC = "CREATETRUNC", // = FileOpenMode.createTrunc,
	/// The file is opened for appending data to it and created if it does not exist.
	APPEND = "APPEND" // = FileOpenMode.append
}