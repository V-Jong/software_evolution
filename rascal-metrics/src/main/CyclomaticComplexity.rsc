module main::CyclomaticComplexity

import IO;
import List;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public list[loc] cyclomaticComplexityPerProject(loc project) {
	println("Creating model...");
    M3 model = createM3FromEclipseProject(project);
    println("Model created, calculating CC");
    
	myMethods = toList(methods(model));
	return myMethods;
}