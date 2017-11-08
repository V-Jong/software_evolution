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
    list[str] lines = [line | line <- rawLines, !isWhiteLine(line), !isLineComment(line), !isClosedMultLineComment(line)];    
    return size(lines);
}

bool isWhiteLine(str line) {
    return /^\s*$/ := line;
}

bool isSignificantLine(str line) {
    
}

bool isLineComment(str line) {
    return /^\s*\/\// := line;
}

bool isOpenMultiLineComment(str line) {
    return /\/\*(?!.*\*\/)/ := line;
}

bool isClosedMultLineComment(str line) {
    return /^\s*\/\*.*\*\/\s*$/ := line;
}
