module main::LinesOfCode

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import List;
import String;
import Set;

public int linesOfCodePerProject(loc project) {
	println("Creating model...");
    M3 model = createM3FromEclipseProject(project);
    set[loc] files = files(model);
    int numberOfFiles = size(files);
    zipped = zip(toList(files), [1..numberOfFiles+1]);
	println("Found <numberOfFiles> files. Counting lines of code ...");
    return sum([linesOfCodePerFile(file, number, numberOfFiles) | <file, number> <- zipped]);
}     

public int linesOfCodePerFile(loc file, int number, int numberOfFiles) {
    println("<number>/<numberOfFiles>");
    str rawFile = readFile(file);
    
    str withoutLineComments = removeLineComments(rawFile);
    str emptyStrings = emptyStrings(withoutLineComments);
    str withoutMultiLineComments = removeMultiLineComments(emptyStrings);
    
    list[str] lines = split("\n", withoutMultiLineComments);
    list[str] withoutWhiteLines = [line | line <- lines, !isWhiteLine(line)];    
    int numberOfLines = size(withoutWhiteLines);
    
    return numberOfLines;
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
       case /\/\/.*/ => ""  
    };
}

private str removeMultiLineComments(str input) {
    return visit(input) {
       case /\/\*[\s\S]*?\*\// => ""  
    };
}
