/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.tests.general;

import uim.filesystems;

@safe:
bool testFilesystem(IFilesystem aFilesystem) {
	if (aFilesystem is null) { return false; }

 	if (!aFilesystem.existsFolder("testFolder")) {
		assert(aFilesystem.createFolder("testFolder"), "testFilesystem: Couldn't create testFolder");
		return false;
	}
	assert(aFilesystem.existsFolder("testFolder"), "testFilesystem: testFolder missing");

	if (auto myFolder = aFilesystem.folder("testFolder")) {
		// debug writeln(myFolder.debugInfo);		
		assert(myFolder.exists(), "testFilesystem: FolderObj testFolder missing");
	}
	else {
		assert(false, "testFilesystem: FolderObj missing");
	}

	return true;
}