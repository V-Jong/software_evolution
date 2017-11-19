module main::Metrics

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import main::CommentRemover;
import main::LinesOfCode;
import main::Duplication;
import main::LinesOfCode;
import main::lib::StringHelpers;
import util::Math;

public void calculateMetricsForProject() {
	println("Creating model ...");
    //M3 model = createM3FromEclipseProject(project);
     //M3 model = createM3FromEclipseProject(|project://smallsql0.21_src|);
    M3 model = createM3FromEclipseProject(|project://example|);
    println("Model created, calculating metrics ...");
    
    set[loc] javaFiles = files(model);
    
    println("Removing comments and white lines ...");
    	map[loc, fileLines] locationLinesMap = (location: removeCommentsAndWhiteSpacesFromFile(readFile(location)) | location <- javaFiles);
    println("Counting duplicate lines ...");
    int duplicateLOC = countDuplicateLines(locationLinesMap);
    println(duplicateLOC);
    println("Counting total lines ...");
    int totalLOC = totalLines(locationLinesMap);
    locRisk(totalLOC);
    	
}

public int locRisk(int linesOfCode) {
	if(linesOfCode < 66000) {
		return 1;
	} 
	if(linesOfCode < 246000) {
		return 2;
	} 
	if(linesOfCode < 665000) {
		return 3;
	} 
	if (linesOfCode < 1310000){
		return 4;
	}
	return 5;
}

public int unitSizeRisk(int unitSize) {
	if(unitSize <= 6) {
		return 1;
	}
	if(unitSize <= 8) {
		return 2;
	}
	if(unitSize <= 15) {
		return 3;
	} 
	return 4;
}

public int unitComplexityRisk(int unitComplexity) {
	if(unitComplexity <= 10) {
		return 1;
	}
	if(unitComplexity <= 20) {
		return 2;
	}
	if(unitComplexity <= 50) {
		return 3;
	} 
	return 4;
}

public str locScore(int average) {
	switch (average) {
		case 1: return "++";
		case 2: return "+";
		case 3: return "o";
		case 4: return "-";
		case 5: return "--";
	}
}

public str manYearsScore(int average) {
	switch (average) {
		case 1: return "0 − 8";
		case 2: return "8 − 30";
		case 3: return "30 − 80";
		case 4: return "80 − 160";
		case 5: return "\> 160";
	}
}

public str getDuplicationScore(int percentage) {
	if(percentage < 3) {
		return "++";
	} 
	if(percentage < 5) {
		return "+";
	} 
	if(percentage < 10) {
		return "o";
	} 
	if (percentage < 20){
		return "-";
	}
	return "--";
}

public void printResult(int LOC, int duplicateLines, int totalUnits, str complexityScore, str unitSizeScore) {
	paddedLOC = padLeft(toString(LOC), 7, " ");
	
	locRiskAverage = locRisk(LOC);
	paddedLOCScore = padLeft(locScore(locRiskAverage), 7, " ");
	myvbp = padLeft(manYearsScore(locRiskAverage), 8, " ");
	
	paddedTotalUnits = padLeft(toString(totalUnits), 7, " ");
	
	paddedDuplicateLines = padLeft(toString(duplicateLines), 7, " ");
	
	duplicationPercentage = percent(duplicateLines, LOC);
	duplicationScore = getDuplicationScore(duplicationPercentage);
	
	paddedUnitSizeScore = padLeft(unitSizeScore, 4, " ");
	
	paddedDuplicationScore = padLeft("(<duplicationPercentage>%) <duplicationScore>", 9, " ");
	
	paddedComplexityScore = padLeft(complexityScore, 4, " ");
	
	str template = 	"  Measure   |   LOC   |  MYVBP   | Total units | Unit size | Duplicate LOC | Cyclomatic Complexity
					'------------|---------|----------|-------------|-----------|---------------|----------------------
					' Absolute   | <paddedLOC> |  <paddedLOC> |     <paddedTotalUnits> |       N/A |       <paddedDuplicateLines> |                  N/A
					' SIG score  | <paddedLOCScore> | <myvbp> |         N/A |      <paddedUnitSizeScore> |     <paddedDuplicationScore> |                 <paddedComplexityScore>
					";
	println(template);
}

