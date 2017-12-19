module main::Logger

import Map;
import Set;
import IO;

import main::Config;

import main::CloneMetrics;

public void logClones(loc location, map[node, set[node]] cloneClasses) {
	bool logged = writeClonesToFile(LOG_FILE, cloneClasses);
	if (logged) println("Logged to file <LOG_FILE>");
	else println("Failed to log to <LOG_FILE>");
}

public bool writeClonesToFile(loc location, map[node, set[node]] cloneClasses) {
	str fileContent = "";
	set[set[node]] cloneGroups = range(cloneClasses);
	int cloneClassNr = 1;
	int failures = 0;
	
	for (cloneGroup <- cloneGroups) {
		fileContent += "------- Clone class <cloneClassNr> -------\n\n";
		for (clone <- cloneGroup) {
			try {
				loc cloneLoc = getLocationFromValue(clone.src);
				fileContent += "Location: <cloneLoc.path>:\n\n";
				fileContent += readFile(cloneLoc) + "\n\n";
			}
			catch: failures += 1;
		}
		cloneClassNr += 1;
	}
//	println("Failed to log <failures> clones");
//	println(fileContent);
	try {
		writeFile(location, fileContent);
		return true;
	}
	catch: return false;
}