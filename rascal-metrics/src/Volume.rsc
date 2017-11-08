module src::Volume

import IO;
import lang::java::m3::Core;
import List;
import String;

// M3 helloWorldModel = createM3FromDirectory(|project://smallsql0.21_src|);
// list[loc] helloWorldMethods = [ e | e <- helloWorldModel.containment[|java+class:///CommandLine|], e.scheme == "java+method"];

M3 helloWorldModel = createM3FromDirectory(|cwd:///../example|);

void printModel() {
    iprintln(helloWorldMethods);
}

void numberOfMethods() {
    int size = size(helloWorldMethods);
    println(size);
}

void printC() {
    println("hello");
}

int linesOfCode() {
    list[str] rawLines = readFileLines(|cwd:///../example/src/HelloWorld.java|);
    list[str] lines = [line | line <- rawLines, isNonEmptyLine(line), isNonLineComment(line)];    
    return size(lines);
}

bool isNonEmptyLine(str line) {
    return !isEmpty(trim(line));
}

bool isNonLineComment(str line) {
    return !startsWith(trim(line), "//");
}

str tr

list[str] filterOutBlockComments(list[str] lines) {
    bool open = false;
    for (line <- lines) {
        if(line)
    }
}

bool isNonJavaDocComment(str line) {
    return 
}