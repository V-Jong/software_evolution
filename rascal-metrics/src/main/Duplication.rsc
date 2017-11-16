module main::Duplication

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import String;
import Set;
import List;
import main::lib::ListHelpers;
import util::Math;

private	int windowSize = 6;
map[tuple[loc, tuple[int, int]], str] locationWindowsHashMap = ();

public int totalLines(map[loc, list[str]] locationLines) {
	return sum([size(locationLines[location])|location <- locationLines]);
}

public int duplicationPerModel() {
	M3 model = createM3FromEclipseProject(|project://example|);
	
	list[loc] javaFiles = toList(files(model));
	
	map[loc, list[str]] locationLinesMap = toMapUnique([<location, readFileLines(location)> | location <- javaFiles]);
		
	set[tuple[loc, tuple[int, int]]] locationWindows = {}; 
	list[tuple[tuple[loc, tuple[int, int]], str]] locationWindowsHash = [];
	for(location <- javaFiles) {
		fileLines = locationLinesMap[location];
		windows = slidingWindow(size(locationLinesMap[location]));
		for(window <- windows) {
			block = slice(fileLines, window[0], window[1]);
			blockHash = toStringHash(block);
			key = <location, window>;
			locationWindows = locationWindows + key;
			locationWindowsHash = locationWindowsHash + <key, blockHash>; 
		}
	}
	
	locationWindowsHashMap = toMapUnique(locationWindowsHash);
	grouped = classify(locationWindows, getHash);
	duplicateWindows = [locationWindow | group <- grouped, locationWindow <- grouped[group] ,size(grouped[group]) > 1];
	
	duplicateLines = {};
	for (<location, <startLine, windowSize>> <- duplicateWindows) {
		for (lineNumber <- [startLine..(startLine+windowSize)]) {
			println("<location>: <lineNumber>");
			duplicateLines = duplicateLines + <location, lineNumber>;
		}
	}
	
	numberOfDuplicateLines = size(duplicateLines); 
	totalNumberOfLines = totalLines(locationLinesMap);
	return percent(numberOfDuplicateLines,  totalNumberOfLines);
}

public str getHash(tuple[loc, tuple[int, int]] t1) {
	return locationWindowsHashMap[t1];
}

public list[tuple[int, int]] slidingWindow(int maxLine) {
	if(windowSize > maxLine) {
		return [<0, maxLine>];
	} else {
		return [<i, windowSize> | i <- [0..maxLine - windowSize]];
	}
}