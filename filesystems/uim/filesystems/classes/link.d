/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.classes.link;

import uim.filesystems;

unittest {
	version (testUimFilesystems) {
		debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
	}
}

@safe:
class DLink : DFilesystemEntry, ILink {
	mixin(FolderThis!("Link"));

	override bool initialize(Json[string] initData = null) { // Hook
		if (!super.initialize(initData)) {
			return false;
		}
		return true;
	}

	override bool isLink() {
		return exists;
	}

	bool isFileLink() {
		return false;
	}

	bool isFolderLink() {
		return false;
	}

	override bool exists() {
		return (hasFilesystem ? filesystem.existsLink(name) : false);
	}

	override string toString() {
		return this.className ~ ": " ~ name;
	}
}

// mixin(FolderCalls!("Link"));

unittest {
	// assert(Link, "Could not create LInk");
}
