module main::LinesOfCode

import IO;
import List;
import String;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import main::lib::StringHelpers;
import main::lib::ListHelpers;
import main::CommentRemover;

public int linesOfCodePerProject(M3 model) {    	
    set[loc] javaFiles = files(model);
    
    int numberOfFiles = size(javaFiles);    
    println("Found <numberOfFiles> files. Counting lines of code ...");
    
    zippedWithIndex = zipWithIndex(toList(javaFiles));
    
	int sum = sum([withFileCounter(file, number + 1, numberOfFiles) | <file, number> <- zippedWithIndex]);
    return sum;
} 

public int withFileCounter(loc file, int number, int numberOfFiles) {
	println("<number>/<numberOfFiles>");
	
	linesOfCode = linesOfCodePerLocation(file);
	
	return linesOfCode;
}

public int linesOfCodePerLocation(loc location) {
    str rawFile = readFile(location);
	
	list[str] cleanedFile = removeCommentsAndWhiteSpacesFromFile(rawFile);
    
    int numberOfLines = size(cleanedFile);
    return numberOfLines; 
}

