module main::LinesOfCode

import IO;
import List;
import String;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import main::lib::StringHelpers;
import main::lib::ListHelpers;

public int linesOfCodePerProject(loc project) {
	println("Creating model...");
    M3 model = createM3FromEclipseProject(project);
    	
    set[loc] javaFiles = files(model);
    
    int numberOfFiles = size(javaFiles);    
    println("Found <numberOfFiles> files. Counting lines of code ...");
    
    zippedWithIndex = zipWithIndex(toList(javaFiles));
    
	int sum = sum([withFileCounter(file,number,numberOfFiles) | <file, number> <- zippedWithIndex]);
    return sum;
} 

public int withFileCounter(loc file, int number, int numberOfFiles) {
	linesOfCode = linesOfCodePerFile(file);
	
	println("<number>/<numberOfFiles>");
	// println("<file>,<linesOfCode>");
	
	return linesOfCode;
}

public int linesOfCodePerFile(loc file) {
    str rawFile = readFile(file);
	
	list[str] cleanedFile = removeCommentsAndWhiteSpacesFromFile(rawFile);
    
    int numberOfLines = size(cleanedFile);
    return numberOfLines; 
}

private list[str] removeCommentsAndWhiteSpacesFromFile(str input) {
	str clearedStringContent = clearStringContent(input);
    str withoutComments = removeComments(clearedStringContent);
        
    list[str] lines = split("\n", withoutComments);
    list[str] withoutWhiteLines = [line | line <- lines, !isWhiteLine(line)];    

    return withoutWhiteLines;
}

private bool isWhiteLine(str line) {
    return isEmpty(trim(line));
}

private str clearStringContent(str input) {
    return visit(input) {
       case /".*"/ => "\"\""  
    };
}

private str removeComments(str input) {
    return visit(input) {
       case /\/\*[\s\S]*?\*\/|\/\/.*/ => ""  
    };
}
