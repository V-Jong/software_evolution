module main::Metrics

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import main::CommentRemover;
import main::LinesOfCode;

public void calculateMetricsForProject(loc project) {
	println("Creating model ...");
    M3 model = createM3FromEclipseProject(project);
    
    println("Model created, calculating metrics ...");
    
    set[loc] javaFiles = files(model);
    
    println("Removing comments and white lines ...");
    
    
    
    int totalLines = linesOfCodePerProject(model);
    
    
}