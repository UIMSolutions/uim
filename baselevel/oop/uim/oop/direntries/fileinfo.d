module uim.oop.direntries.fileinfo;

import uim.oop;
@safe:

version (test_uim_oop) {
  import std.stdio;
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}
class DFileInfo : UIMObject {
    int getATime() {
        return 0;
    }

    string getBasename(string suffix = null) {
        return null;
    }

    int getCTime() {
        return 0;
    }

    string getExtension() {
        return null;
    }

    DFileInfo getFileInfo(string classname = null) {
        return null;
    }

    string getFilename() {
        return null;
    }

    int getGroup() {
        return 0;
    }

    int getInode() {
        return 0;
    }

    string getLinkTarget() {
        return null;
    }

    int getMTime() {
        return 0;
    }

    int getOwner() {
        return 0;
    }

    string path() {
        return null;
    }

    DFileInfo getPathInfo(string classname = null) {
        return null;
    }

    string getPathname() {
        return null;
    }

    int getPerms() {
        return 0;
    }

    string getRealPath() {
        return null;
    }

    int getSize() {
        return 0;
    }
    string getType() {
        return null;
    }

    bool isDir() {
        return false;
    }

    bool isExecutable() {
        return false;
    }

    bool isFile() {
        return false;
    }

    bool isLink() {
        return false;
    }

    bool isReadable() {
        return false;
    }

    bool isWritable() {
        return false;
    }

    DFileInfo openFile(string mode = "r", bool useIncludePath = false, Json[string] context = null) {
        return null;
    }

    void setFileClass(string classname = null) {
    }

    void setInfoClass(string classname = null) {
    }

    override string toString() {
        return null;
    }
}
