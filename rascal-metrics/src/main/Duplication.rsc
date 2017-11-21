module main::Duplication

import IO;
import Set;
import List;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Math;

import main::CommentRemover;
import main::lib::ListHelpers;
import main::lib::MapHelpers;

import main::config::config;

alias window = tuple[int, int];
alias locationWindow = tuple[loc, window];
alias fileLines = list[str];
alias lineIndex = tuple[loc, int];

public int countDuplicateLines(map[loc, list[str]] locationLinesMap) {
	locationWindowsBlockMap = buildLocationWindowsBlockMap(locationLinesMap);
	
	groupedByHash = values(groupByValue(locationWindowsBlockMap));
	onlyDuplicateWindows = filterNonDuplicates(groupedByHash);
	filterOriginalWindows = filterNonOriginal(onlyDuplicateWindows);
	
	duplicateLines = getLinesFromWindows(flatten(filterOriginalWindows));

	return size(duplicateLines);
}

private list[list[locationWindow]] filterNonOriginal(list[set[locationWindow]] groupedDuplicates) {
	if (COUNT_ORIGINALS) {
		return [toList(group) | group <- groupedDuplicates];
	}
	return [drop(1, sort(toList(group))) | group <- groupedDuplicates];
}

private list[set[locationWindow]] filterNonDuplicates(list[set[locationWindow]] groupedDuplicates) {
	return [group | group <- groupedDuplicates, size(group) > 1];
}

private map[locationWindow, fileLines] buildLocationWindowsBlockMap(map[loc, list[str]] locationLinesMap) {
	return (<location, window> : getBlock(location, window, locationLinesMap) | 
		location <- locationLinesMap, 
		window <- getWindowsForLocation(location, locationLinesMap)
	);
}

private list[str] getBlock(loc location, window window, map[loc, list[str]] locationLinesMap) {
	return slice(locationLinesMap[location], window[0], window[1]);
}

private set[tuple[loc, int]] getLinesFromWindows(list[locationWindow] duplicateWindows) {
	return { <location, lineNumber> | 
		<location, <startLine, WINDOW_SIZE>> <- duplicateWindows, 
		lineNumber <- [startLine..(startLine+WINDOW_SIZE)] 
	};
}

private list[window] getWindowsForLocation(loc location, map[loc, list[str]] locationLinesMap) {
	fileLines = locationLinesMap[location];
	return slidingWindow(size(fileLines));
}

private list[window] slidingWindow(int maxLine) {
	if(WINDOW_SIZE > maxLine) {
		return [<0, maxLine>];
	}
	return [<i, WINDOW_SIZE> | i <- [0..maxLine - WINDOW_SIZE + 1]];
}