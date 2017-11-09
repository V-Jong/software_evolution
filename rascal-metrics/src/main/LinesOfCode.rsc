module main::LinesOfCode

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import List;
import String;

public int linesOfCodePerProject(loc project) {
    M3 model = createM3FromEclipseProject(project);
    list[loc] files = [ from | <from, to> <- model.containment, from.scheme == "java+compilationUnit"];
    return sum([linesOfCodePerFile(file)| file <- files]);
}     

public int linesOfCodePerFile(loc file) {
    str rawFile = readFile(file);
    
    str multiLineCommentsRemoved = removeMultiLineComments(rawFile);
    list[str] lines = split("\n", multiLineCommentsRemoved);
    list[str] linesWithoutWhiteLinesAndComments = [line | line <- lines, !isWhiteLine(line), !isLineComment(line)];    
    // for(line <- linesWithoutWhiteLinesAndComments) {
    //     println(line);
    // }
    return size(linesWithoutWhiteLinesAndComments);
}

private bool isWhiteLine(str line) {
    return /^\s*$/ := line;
}

private bool isLineComment(str line) {
    return /^\s*\/\// := line;
}

str removeMultiLineComments(str input) {
    return visit(input) {
       case /\/\*[\s\S]*?\*\// => ""  
    };
}
