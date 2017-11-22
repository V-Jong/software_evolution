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
import main::UnitInterfacing;

import main::config::Config;

public void run() {
	if(WITH_TIMER) {
		results = benchmark(("Rascal - Metrics": void() { calculateMetricsForProject(); }) );
		println("\nExecution time: " + toString(results["Rascal - Metrics"] / 1000) + "s");
	} else {
		calculateMetricsForProject();
	}
}

public void calculateMetricsForProject() {
	println("Creating model ...");
    M3 model = createM3FromEclipseProject(CURRENT_PROJECT);
    	       
    set[loc] javaFiles = files(model);
        
    println("Removing comments ...");
    	map[loc, fileLines] locationLinesMap = (location: removeCommentsAndWhiteSpacesFromFile(readFile(location)) | location <- javaFiles);
    	
    println("Counting duplicate lines ...");
    int duplicateLOC = countDuplicateLines(locationLinesMap);
    int totalLOC = totalLines(locationLinesMap);
    
    println("Determining unit size risk ...");
    list[int] unitSizes = unitSizePerModel(model);
    int totalUnits = size(unitSizes);
    int totalUnitSize = sum(unitSizes);
    
	unitSizeComplexityFootprint = calculateComplexityFootprint(unitSizes, totalLOC, unitSizeRisk);
	unitSizeComplexityRating = calculateComplexityRating(unitSizeComplexityFootprint, threshold);
	
	println("Determining unit interface risk ...");
	list[int] interfaceSizes = values(getParametersPerUnit(javaFiles));
	
	unitInterfaceComplexityFootprint = calculateComplexityFootprint(interfaceSizes, sum(interfaceSizes), unitInterfaceRisk);
	unitInterfaceComplexityRating = calculateComplexityRating(unitInterfaceComplexityFootprint, thresholdInterface);
	
	println("Determining cyclomatic complexity ...");
	ccOfFiles = ccPerProjectFiles(javaFiles);
	map[str, int] locPerCategory = locPerComplexityCategory(ccOfFiles);
	map[str, real] riskProfile = getCyclomaticComplexityFootprint(locPerCategory, totalLOC);
	cyclomaticComplexityRating = getCyclomaticComplexityRating(riskProfile);
	
	printFootPrints(unitSizeComplexityFootprint, unitInterfaceComplexityFootprint, riskProfile);
    	printTotal(totalLOC, duplicateLOC, totalUnits, totalUnitSize, cyclomaticComplexityRating, unitSizeComplexityRating, unitInterfaceComplexityRating);
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

private str unitInterfaceRisk(int numberOfParms) {
	if(numberOfParms <= 2) {
		return "low";
	}
	if(numberOfParms <= 3) {
		return "moderate";
	}
	if(numberOfParms <= 4) {
		return "high";
	} else {
		return "extreme";
	}	
}

private list[tuple[str, map[str, real]]] threshold = [
	<"++",("extreme": 0.0, "high": 0.0, "moderate": 25.0, "low": 100.0)>,
	<"++",("extreme": 0.0, "high": 5.0, "moderate": 30.0, "low": 100.0)>,
	<"o",("extreme": 0.0, "high": 10.0, "moderate": 40.0, "low": 100.0)>,
	<"-",("extreme": 5.0, "high": 15.0, "moderate": 50.0, "low": 100.0)>,
	<"--",("extreme": 100.0, "high": 100.0, "moderate": 100.0, "low": 100.0)>
	];
	
private list[tuple[str, map[str, real]]] thresholdInterface = [
	<"*****",("extreme": 2.2, "high": 5.4, "moderate": 12.1, "low": 100.0)>,
	<"****",("extreme": 14.9, "high": 7.2, "moderate": 14.9, "low": 100.0)>,
	<"***",("extreme": 4.8, "high": 10.2, "moderate": 17.7, "low": 100.0)>,
	<"**",("extreme": 5.0, "high": 15.0, "moderate": 50.0, "low": 100.0)>,
	<"*",("extreme": 100.0, "high": 100.0, "moderate": 100.0, "low": 100.0)>
];
	
private map[value, num] calculateComplexityFootprint(list[int] complexity, int totalLoc, complexityScore) {
	map[value, list[int]] grouped = groupBy(complexity, complexityScore);
	sums = mapValues(grouped, sum);
	return (group: percent(sums[group], totalLoc) | group <- sums);
}

private str calculateComplexityRating(map[str, num] complexityFootprint, list[tuple[str, map[str, num]]] thresholds) {
	currentThresholdScore = thresholds[0];
	currentThresholdMap = currentThresholdScore[1];
	
	belowThresholdValues = forall([complexityFootprint[riskLevel] <= currentThresholdMap[riskLevel] | riskLevel<-complexityFootprint]);
	if (belowThresholdValues) {
		return currentThresholdScore[0];	
	}
	return calculateComplexityRating(complexityFootprint, thresholds[1..]);
}

private void printComplexityMatrix(map[value, num] complexityMatrix) {
	println(" Risk level | Percentage
			'------------|-----------");
	for (key <- complexityMatrix) {
		println(" <padLeft(key, 10, " ")> | <padLeft("<complexityMatrix[key]>", 9, " ")> ");	
	}
	println();
}

public void printCyclomaticComplexityMatrix(map[str, num] complexityMatrix) {
	println("Cyclomatic Complexity matrix:");
	
	println(" Risk level | Percentage
			'------------|-----------");
	for (key <- complexityMatrix) {
		println(" <padLeft(key, 10, " ")> | <padLeft("<complexityMatrix[key]>", 9, " ")> ");	
	}
	println();
}

private void printFootPrints(map[value, num] unitSizeComplexityFootprint, map[value, num] unitInterfaceComplexityFootprint, map[str, real] riskProfile) {
	println("
			'Unit size complexity matrix:");
	printComplexityMatrix(unitSizeComplexityFootprint);

	println("
			'Unit interface complexity matrix:");
	printComplexityMatrix(unitInterfaceComplexityFootprint);
	
	printCyclomaticComplexityMatrix(riskProfile);
}

private void printTotal(int LOC, int duplicateLines, int totalUnits, int totalUnitSize, str complexityScore, str unitSizeScore, str interfaceScore) {
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
	
	paddedInterfaceScore = padLeft(interfaceScore, 15, " ");
	
	str metrictemplate = "  Measure   |  Volume |    MYVBP | Total Units | Unit Size | Unit Complexity | Duplicate LOC | Unit Interface |
						 '------------|---------|----------|-------------|-----------|-----------------|--------------------------------|
						 ' Absolute   | <paddedLOC> |  <paddedLOC> | <paddedTotalUnits> | <paddedTotalUnitSize> |             N/A | <paddedDuplicateLines> |             N/A
						 ' SIG score  | <paddedLOCScore> | <myvbp> |         N/A | <paddedUnitSizeScore> | <paddedComplexityScore> | <paddedDuplicationScore> | <paddedInterfaceScore>
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

