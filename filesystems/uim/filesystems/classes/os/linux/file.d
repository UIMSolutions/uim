/***********************************************************************************
*	Copyright: ©2015- 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.classes.os.linux.file;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DLinuxFile : DFile {
  mixin(FileThis!("LinuxFile"));

}
mixin(FileCalls!("LinuxFile"));

version(testUimFilesystems) { 
	unittest {
		version(testUimFilesystems) { debug writeln (StyledString("\nStart tests in "~__MODULE__).setBackground(AnsiColor.yellow).setForeground(AnsiColor.black)); }

		auto myFilesystem = LinuxFilesystem("TestmyFilesystem");
		myFilesystem.rootPath("for_testing");

		myFilesystem.createIfNotExitsFolder("LinuxFile"); 
		myFilesystem.createIfNotExitsFolder(["LinuxFile"], "files"); 
		myFilesystem.createIfNotExitsFolder(["LinuxFile"], "file"); 

		IFile aFile = myFilesystem.createFile(["LinuxFile", "file"], "file"~to!string(uniform(0, 1000)));
		int[] a = [1, 2, 3];
		aFile.appendData(a);
		const data = aFile.readData;
		const results =  (() @trusted => cast(int[])data)();  
		writeln(results);

		aFile = myFilesystem.createFile(["LinuxFile", "file"], "file"~to!string(uniform(0, 1000)));
		aFile.writeText("text");
		assert(aFile.readText == "text");

		aFile.appendText("2text");
		assert(aFile.readText == "text2text");
		debug writeln(aFile.readText);

	/* 	// #region Test Files
			if (!myFilesystem.existsFolder("LinuxFilesystem/files")) { myFilesystem.createFolder("LinuxFile/files"); }

			if (!myFilesystem.existsFolder("LinuxFilesystem/files/creatingFiles")) { myFilesystem.createFolder("LinuxFilesystem/files/creatingFiles"); }
			testFile_CreateFiles(__MODULE__, myFilesystem, "LinuxFilesystem/files/creatingFiles", ["LinuxFilesystem", "files", "creatingFiles"]);

			if (!myFilesystem.existsFolder("LinuxFilesystem/files/readFiles")) { myFilesystem.createFolder("LinuxFilesystem/files/readFiles"); }
			testFile_ReadFiles(__MODULE__, myFilesystem, "LinuxFilesystem/files/readFiles", ["LinuxFilesystem", "files", "readFiles"]);

			if (!myFilesystem.existsFolder("LinuxFilesystem/files/updateFiles")) { myFilesystem.createFolder("LinuxFilesystem/files/updateFiles"); }
			testFile_UpdateFiles(__MODULE__, myFilesystem, "LinuxFilesystem/files/updateFiles", ["LinuxFilesystem", "files", "updateFiles"]);

			if (!myFilesystem.existsFolder("LinuxFilesystem/files/removeFiles")) { myFilesystem.createFolder("LinuxFilesystem/files/removeFiles"); }
			testFile_RemoveFiles(__MODULE__, myFilesystem, "LinuxFilesystem/files/removeFiles", ["LinuxFilesystem", "files", "removeFiles"]);  
	// #endregion Test Files */

	/* 	// #region Test File
			if (!myFilesystem.existsFolder("LinuxFilesystem/files")) { myFilesystem.createFolder("LinuxFile/file"); }

			if (!myFilesystem.existsFolder("LinuxFilesystem/files/creatingFiles")) { myFilesystem.createFolder("LinuxFilesystem/files/creatingFiles"); }
			testFile_CreateFile(__MODULE__, myFilesystem, "LinuxFilesystem/files/creatingFiles", ["LinuxFilesystem", "files", "creatingFiles"]);

			if (!myFilesystem.existsFolder("LinuxFilesystem/files/readFiles")) { myFilesystem.createFolder("LinuxFilesystem/files/readFiles"); }
			testFile_ReadFile(__MODULE__, myFilesystem, "LinuxFilesystem/files/readFiles", ["LinuxFilesystem", "files", "readFiles"]);

			if (!myFilesystem.existsFolder("LinuxFilesystem/files/updateFiles")) { myFilesystem.createFolder("LinuxFilesystem/files/updateFiles"); }
			testFile_UpdateFile(__MODULE__, myFilesystem, "LinuxFilesystem/files/updateFiles", ["LinuxFilesystem", "files", "updateFiles"]);

			if (!myFilesystem.existsFolder("LinuxFilesystem/files/removeFiles")) { myFilesystem.createFolder("LinuxFilesystem/files/removeFiles"); }
			testFile_RemoveFile(__MODULE__, myFilesystem, "LinuxFilesystem/files/removeFiles", ["LinuxFilesystem", "files", "removeFiles"]);  
	// #endregion Test File */

		version(testUimFilesystems) { debug writeln (StyledString("End tests in "~__MODULE__).setBackground(AnsiColor.white).setForeground(AnsiColor.black)); }
	} 
}
