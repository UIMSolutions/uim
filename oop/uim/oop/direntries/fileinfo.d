module uim.oop.direntries.fileinfo;

import uim.oop;
@safe:

class DFileInfo : UIMObject {
    int getATime() {
        return 0; 
    }
    string getBasename(string $suffix = "") {
        return null; 
    }
    int getCTime() {
        return 0; 
    }
    string getExtension(): string
    DFileInfo getFileInfo(?string $class = null) {
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
     getLinkTarget() {
        return null; 
    }
    int getMTime() {
        return 0; 
    }
    int getOwner() {
        return 0; 
    }
    string getPath() {
        return null; 
    }
    DFileInfo getPathInfo(?string $class = null) {
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
     getSize() {
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
     openFile(string $mode = "r", bool $useIncludePath = false, ?resource $context = null): SplFileObject
     setFileClass(string $class = SplFileObject::class) {}
     setInfoClass(string $class = SplFileInfo::class) {}
     __toString(): string
}