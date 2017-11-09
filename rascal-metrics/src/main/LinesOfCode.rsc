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
    
    str withoutLineComments = removeLineComments(rawFile);
    str emptyStrings = emptyStrings(withoutLineComments);
    str withoutMultiLineComments = removeMultiLineComments(emptyStrings);
    
    list[str] lines = split("\n", withoutMultiLineComments);
    list[str] withoutWhiteLines = [line | line <- lines, !isWhiteLine(line)];    
	//for(line <- linesWithoutWhiteLines) {
	//	println(line);
	//}
    return size(withoutWhiteLines);
}

private bool isWhiteLine(str line) {
    return /^\s*$/ := line;
}

private str emptyStrings(str input) {
    return visit(input) {
       case /".*"/ => "\"\""  
    };
}

private str removeLineComments(str input) {
    return visit(input) {
       case /^\s*\/\/.*/ => ""  
    };
}

private str removeMultiLineComments(str input) {
    return visit(input) {
       case /\/\*[\s\S]*?\*\// => ""  
    };
}
