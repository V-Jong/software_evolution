module main::Metrics

import IO;
import main::LinesOfCode;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public void calculateMetricsForProject(loc project) {
	println("Creating model...");
    M3 model = createM3FromEclipseProject(project);
    println("Model created, calculating metrics");
    
    int totalLines = linesOfCodePerProject(model);
    println("Total lines is <totalLines>");
}