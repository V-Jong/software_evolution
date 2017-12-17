module main::CloneMetrics

import List;
import Map;
import Set;
import IO;
import Type;

import util::Math;

import lang::java::m3::AST;

public int totalLOCClones(set[set[node]] cloneGroups) {
	int total = 0;
	
	for (cloneGroup <- cloneGroups) {
		for (clone <- cloneGroup) {
			switch (clone) {
				case Declaration x: total += getLocationSize(x.src);
				case Expression x: total += getLocationSize(x.src);
				case Statement x: total += getLocationSize(x.src);
			}
		}
	}
	return total;
}

public tuple[loc, int] getBiggestClone(set[set[node]] cloneGroups) {
	int biggestCloneSize = 0;
	loc cloneSource = |unknown:///|;
	
	for (cloneGroup <- cloneGroups) {
		for (clone <- cloneGroup) {
			switch (clone) {
				case Declaration x: {
					curSize = getLocationSize(x.src);
					if (curSize > biggestCloneSize) {
						biggestCloneSize = curSize;
						cloneSource = x.src;
					}
				}
				case Expression x: {
					curSize = getLocationSize(x.src);
					if (curSize > biggestCloneSize) {
						biggestCloneSize = curSize;
						cloneSource = x.src;
					}
				}
				case Statement x: {
					curSize = getLocationSize(x.src);
					if (curSize > biggestCloneSize) {
						biggestCloneSize = curSize;
						cloneSource = x.src;
					}
				}
			}
		}
	}
	return <cloneSource, biggestCloneSize>;
}

public int getBiggestCloneClass(set[set[node]] cloneGroups) {
	list[int] cloneClassSizes = [ size(toList(cloneGroup)) | cloneGroup <- cloneGroups ];
	return max(cloneClassSizes);
}

public int getLocationSize(loc location) {
	try return location.end.line - location.begin.line;
	catch: return 0;
}

public loc getLocationFromValue(value val) {
	if (loc tmp := val) return tmp;
	return |unknown:///|;
}

public void cc() {
	loc location = |java+compilationUnit:///src/HelloWorld.java|(301,218,<13,4>,<18,5>);// |project://example|;
	switch (location) {
		case _(_): {
			println("Found with line info");
		}
		case _: {
			println("Found without");
		}
	}
}


public real getClonePercentage(int LOCClones, int totalLOC) {
	return round(toReal(LOCClones) / totalLOC * 100, 0.01);
}

public int getAmountOfClones(set[set[node]] cloneGroups) {
	int total = 0;
	
	for (cloneGroup <- cloneGroups) {
		for (clone <- cloneGroup) {
			total += 1;
		}
	}
	return total;
}

public int getAmountOfCloneClasses(set[set[node]] cloneGroups) {
	int total = 0;
	
	for (cloneGroup <- cloneGroups) {
		total += 1;
	}
	return total;
}