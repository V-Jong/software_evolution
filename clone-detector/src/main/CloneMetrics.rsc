module main::CloneMetrics

import List;
import Map;
import IO;

import util::Math;

import lang::java::m3::AST;

public int totalLOCClones(map[node, set[node]] clones) {
	int total = 0;
	set[set[node]] cloneGroups = range(clones);
	
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

public tuple[loc, int] getBiggestClone(map[node, set[node]] clones) {
	int biggestLOC = 0;
	loc cloneSource = |project://unknown|;
	set[set[node]] cloneGroups = range(clones);
	
	for (cloneGroup <- cloneGroups) {
		for (clone <- cloneGroup) {
			switch (clone) {
				case Declaration x: {
					curSize = getLocationSize(x.src);
					if (curSize > biggestLOC) {
						biggestLOC = curSize;
						cloneSource = x.src;
					}
				}
				case Expression x: {
					curSize = getLocationSize(x.src);
					if (curSize > biggestLOC) {
						biggestLOC = curSize;
						cloneSource = x.src;
					}
				}
				case Statement x: {
					curSize = getLocationSize(x.src);
					if (curSize > biggestLOC) {
						biggestLOC = curSize;
						cloneSource = x.src;
					}
				}
			}
		}
	}
	return <cloneSource, biggestLOC>;
}

public int getLocationSize(loc location) = location.end.line - location.begin.line;

public real getClonePercentage(int LOCClones, int totalLOC) {
	return round(toReal(LOCClones) / totalLOC * 100, 0.01);
}

public int getAmountOfClones(map[node, set[node]] clones) {
	int total = 0;
	set[set[node]] cloneGroups = range(clones);
	
	for (cloneGroup <- cloneGroups) {
		for (clone <- cloneGroup) {
			total += 1;
		}
	}
	return total;
}

public int getAmountOfCloneClasses(map[node, set[node]] clones) {
	int total = 0;
	set[set[node]] cloneGroups = range(clones);
	
	for (cloneGroup <- cloneGroups) {
		total += 1;
	}
	return total;
}