module spec::DuplicationSpec

import IO;
import List;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import main::Duplication;

test bool duplicationTest() {
	loc location = |project://rascal-metrics/src/spec/resources/Duplication.txt|;
    list[str] fileLines = readFileLines(location);	
    map[loc, list[str]] locationLinesMap = (location: fileLines);
    
    int result = countDuplicateLines(locationLinesMap);
    return result == 13;
}

test bool slidingWindowTest() {
	lrel[int, int] result = slidingWindow(7);
	return result == [<0,6>, <1,6>];
}
