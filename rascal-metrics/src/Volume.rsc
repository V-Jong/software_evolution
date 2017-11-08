module src::Volume

import IO;
import lang::java::m3::Core;
import List;
import String;

// M3 helloWorldModel = createM3FromDirectory(|project://smallsql0.21_src|);
// list[loc] helloWorldMethods = [ e | e <- helloWorldModel.containment[|java+class:///CommandLine|], e.scheme == "java+method"];

M3 helloWorldModel = createM3FromDirectory(|cwd:///../example|);

void numberOfMethods() {
    int size = size(helloWorldMethods);
    println(size);
}

int linesOfCode() {
    str rawFile = readFile(|cwd:///../example/src/HelloWorld.java|);
    str multiLineCommentsRemoved = removeMultiLineComments(rawFile);
    list[str] splitted = split("\n", multiLineCommentsRemoved);
    list[str] withoutComments = [line | line <- splitted, !isWhiteLine(line), !isLineComment(line), !isClosedMultiLineComment(line)];    
    return size(withoutComments);
}

bool isWhiteLine(str line) {
    return /^\s*$/ := line;
}

bool isLineComment(str line) {
    return /^\s*\/\// := line;
}

bool isOpenMultiLineComment(str line) {
    return /\/\*(?!.*\*\/)/ := line;
}

bool isClosedMultiLineComment(str line) {
    return /^\s*\/\*.*\*\/\s*$/ := line;
}

str removeMultiLineComments(str input){
    return visit(input) {
       case /\/\*[\s\S]*?\*\// => ""  
    };
}
