module main::lib::PrintHelpers

import Map;
import IO;

import main::CloneMetrics;

import lang::java::m3::AST;

private void printSource(loc source) {
	println(readFile(source));
}

private void printGroup(map[node, set[node]] group) {
	for (key <- group) {
		println(key);
		println("##########");			
		for (cloneClass <- group[key]) {
			println(cloneClass);
		}
		println("");
		println("");
	}
}

public void printCloneClasses(map[node, set[node]] cloneClasses) {
	set[set[node]] cloneGroups = range(cloneClasses);
	
	for(cloneGroup <- cloneGroups) {
		for(clone <- cloneGroup) {
			switch (clone) {
				case Declaration x: {
					println(x.src);
					//println(readFile(x.src));
				}
				case Expression x: {
					println(x.src);
					//println(readFile(x.src));
				}
				case Statement x: {
					println(x.src);
					//println(readFile(x.src));
				} 
			}
		}
	}
}

public void printClonesReport(map[node, set[node]] clones, totalLOC) {
	set[set[node]] cloneGroups = range(clones);
	println();
	println("Project contains <totalLOC> lines");
	
	clonesLOC = totalLOCClones(cloneGroups);
	println("The total LOC of all clones in project is <clonesLOC> lines");
	
	real clonePercentage = getClonePercentage(clonesLOC, totalLOC);
	println("Percentage of clones is: <clonePercentage>%");
	
	nrCloneClasses = getAmountOfCloneClasses(cloneGroups);
	nrClones = getAmountOfClones(cloneGroups);
	println("Nr of clone classes: <nrCloneClasses>");
	println("Nr of clones: <nrClones>");
	
	tuple[loc location, int bSize] biggestClone = getBiggestClone(cloneGroups);
	println("The largest clone consists of <biggestClone.bSize> lines, example: <biggestClone.location>");
	
	int biggestCloneClass = getBiggestCloneClass(cloneGroups);
	println("The largest clone class consists of <biggestCloneClass> clones");
}