module main::Metrics

import IO;
import List;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import util::Math;
import util::Benchmark;

import main::lib::MapHelpers;
import main::lib::ListHelpers;
import main::lib::StringHelpers;

import main::CommentRemover;
import main::CyclomaticComplexity;
import main::Maintainability;

import main::Duplication;
import main::LinesOfCode;
import main::UnitSize;

import main::config::Config;

public void run() {
	if(WITH_TIMER) {
		results = benchmark(("Rascal - Metrics": void() { calculateMetricsForProject(); }) );
		println(results["Rascal - Metrics"] / 1000);
	} else {
		calculateMetricsForProject();
	}
}

public void calculateMetricsForProject() {
	println("Creating model ...");

    M3 model = createM3FromEclipseProject(CURRENT_PROJECT);
    	
    println("Analysing ...");
       
    set[loc] javaFiles = files(model);
    	map[loc, fileLines] locationLinesMap = (location: removeCommentsAndWhiteSpacesFromFile(readFile(location)) | location <- javaFiles);
    
    int duplicateLOC = countDuplicateLines(locationLinesMap);
    int totalLOC = totalLines(locationLinesMap);
    
    list[int] unitSizes = unitSizePerModel(model);
    int totalUnits = size(unitSizes);
    int totalUnitSize = sum(unitSizes);
	unitSizeComplexityFootprint = calculateComplexityFootprint(unitSizes, totalLOC, unitSizeRisk);
	println("
			'Unit size complexity matrix:");
	printComplexityMatrix(unitSizeComplexityFootprint);
	unitSizeComplexityRating = calculateComplexityRating(unitSizeComplexityFootprint, threshold);
	
	ccOfFiles = ccPerProjectFiles(javaFiles);
	map[str, int] locPerCategory = locPerComplexityCategory(ccOfFiles);
	map[str, real] riskProfile = getCyclomaticComplexityFootprint(locPerCategory, totalLOC);
	printCyclomaticComplexityMatrix(riskProfile);
	cyclomaticComplexityRating = getCyclomaticComplexityRating(riskProfile);
    	printTotal(totalLOC, duplicateLOC, totalUnits, totalUnitSize, cyclomaticComplexityRating, unitSizeComplexityRating);
}

private str locRisk(int linesOfCode) {
	if(linesOfCode < 66000) {
		return "++";
	} 
	if(linesOfCode < 246000) {
		return "+";
	} 
	if(linesOfCode < 665000) {
		return "o";
	} 
	if (linesOfCode < 1310000){
		return "-";
	}
	return "--";
}

public str manYearsScore(str locScore) {
	switch (locScore) {
		case "++": return "0 − 8";
		case "+": return "8 − 30";
		case "o": return "30 − 80";
		case "-": return "80 − 160";
		case "--": return "160+";
	}
}

private str unitSizeRisk(int unitSize) {
	if(unitSize <= 6) {
		return "low";
	}
	if(unitSize <= 8) {
		return "moderate";
	}
	if(unitSize <= 15) {
		return "high";
	} 
	return "extreme";
}

private str getDuplicationScore(int percentage) {
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

private str unitComplexityRisk(int unitComplexity) {
	if(unitComplexity <= 10) {
		return "low";
	}
	if(unitComplexity <= 20) {
		return "moderate";
	}
	if(unitComplexity <= 50) {
		return "high";
	} else {
		return "extreme";
	}
	
}

private list[tuple[str, map[str, int]]] threshold = [
	<"++",("extreme": 0, "high": 0, "moderate": 25, "low": 100)>,
	<"++",("extreme": 0, "high": 5, "moderate": 30, "low": 100)>,
	<"o",("extreme": 0, "high": 10, "moderate": 40, "low": 100)>,
	<"-",("extreme": 5, "high": 15, "moderate": 50, "low": 100)>,
	<"--",("extreme": 100, "high": 100, "moderate": 100, "low": 100)>
	];

private map[value, int] calculateComplexityFootprint(list[int] complexity, int totalLoc, complexityScore) {
	map[value, list[int]] grouped = groupBy(complexity, complexityScore);
	sums = mapValues(grouped, sum);
	return (group: percent(sums[group], totalLoc) | group <- sums);
}

private str calculateComplexityRating(map[str, int] complexityFootprint, list[tuple[str, map[str, int]]] thresholds) {
	currentThresholdScore = thresholds[0];
	currentThresholdMap = currentThresholdScore[1];
	belowThresholdValues = forall([complexityFootprint[riskLevel] < currentThresholdMap[riskLevel] | riskLevel<-complexityFootprint]);
	if (belowThresholdValues) {
		return currentThresholdScore[0];	
	}
	return calculateComplexityRating(complexityFootprint, thresholds[1..]);
}

private void printComplexityMatrix(map[value, int] complexityMatrix) {
	println(" Risk level | Percentage
			'------------|-----------");
	for (key <- complexityMatrix) {
		println(" <padLeft(key, 10, " ")> | <padLeft("<complexityMatrix[key]>", 9, " ")> ");	
	}
	println();
}

public void printCyclomaticComplexityMatrix(map[str, real] complexityMatrix) {
	println("Cyclomatic Complexity matrix:");
	
	println(" Risk level | Percentage
			'------------|-----------");
	for (key <- complexityMatrix) {
		println(" <padLeft(key, 10, " ")> | <padLeft("<complexityMatrix[key]>", 9, " ")> ");	
	}
	println();
}

private void printTotal(int LOC, int duplicateLines, int totalUnits, int totalUnitSize, str complexityScore, str unitSizeScore) {
	paddedLOC = padLeft(toString(LOC), 7, " ");
	
	locScore = locRisk(LOC);
	paddedLOCScore = padLeft(locScore, 7, " ");
	myvbp = padLeft(manYearsScore(locScore), 8, " ");
	
	paddedTotalUnits = padLeft(toString(totalUnits), 11, " ");
	paddedTotalUnitSize = padLeft(toString(totalUnitSize), 9, " ");
	
	paddedDuplicateLines = padLeft(toString(duplicateLines), 13, " ");
	
	duplicationPercentage = percent(duplicateLines, LOC);
	duplicationScore = getDuplicationScore(duplicationPercentage);
	
	paddedUnitSizeScore = padLeft(unitSizeScore, 9, " ");
	
	paddedDuplicationScore = padLeft("(<duplicationPercentage>%) <duplicationScore>", 13, " ");
	
	paddedComplexityScore = padLeft(complexityScore, 15, " ");
	
	
	str metrictemplate = "  Measure   |  Volume |    MYVBP | Total units | Unit size | Unit Complexity | Duplicate LOC |
						 '------------|---------|----------|-------------|-----------|-----------------|---------------
						 ' Absolute   | <paddedLOC> |  <paddedLOC> | <paddedTotalUnits> | <paddedTotalUnitSize> |             N/A | <paddedDuplicateLines> |
						 ' SIG score  | <paddedLOCScore> | <myvbp> |         N/A | <paddedUnitSizeScore> | <paddedComplexityScore> | <paddedDuplicationScore> | 
						 ";
	println(metrictemplate);
	
	str analysability = calculateMaintainabilityCharacteristic([locScore, duplicationScore, unitSizeScore]);
	str changeability = calculateMaintainabilityCharacteristic([complexityScore, duplicationScore]);
	str testability = calculateMaintainabilityCharacteristic([complexityScore, unitSizeScore]);
	str maintainability = calculateMaintainabilityCharacteristic([analysability, changeability, testability]);
	
	println();
	println("Analysability: <analysability>");
	println("Changeability: <changeability>");
	println("Testability: <testability>");
	println();
	println("Maintainability score: <maintainability>");
}

