module main::Main

import List;
import Node;
import Set;
import Map;

import IO;

import main::IDEIntegration;
import main::lib::SetHelpers;
import main::lib::PrintHelpers;

import main::Config;

import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

public map[str, set[loc]] cloneLocationsPerFile = ();

public void detectClones(loc project) {
	println("Running clone detection for <project>");
	M3 model = createM3FromEclipseProject(project);
	
	set[loc] projectFiles = files(model);
	set[Declaration] fileAsts = createAstsFromFiles(projectFiles);
	
	set[node] subtrees = findSubtrees(fileAsts);

	map[node, set[node]] groupedByNormalisedAst = classify(subtrees, unsetRec);
	map[node, set[node]] cloneClasses = filterNonDuplicates(groupedByNormalisedAst);
	map[node, set[node]] noSubsumptedCloneClasses = dropSubsumptedCloneClasses(cloneClasses);

	cloneLocationsPerFile = getCloneLocationsPerFile(noSubsumptedCloneClasses);
	println("Finished clone detection");
}

private map[str, set[loc]] getCloneLocationsPerFile (map[node, set[node]] cloneClasses) {
	allCloneLocations = mapper(flatten(range(cloneClasses)), getLocation);
	return classify(allCloneLocations, getUri);	
}

private str getUri(loc location) {
	return PROJECT.uri + location.path;
}

private loc getLocation(node tree) {
	switch (tree) {
		case Declaration x: return x.src;
		case Expression x: return x.src;
		case Statement x: return x.src;
	}
}

private map[node, set[node]] filterNonDuplicates(map[node, set[node]] grouped) {
	return (group: grouped[group] | group <- grouped, size(grouped[group]) > 1);
}

private map[node, set[node]] dropSubsumptedCloneClasses(map[node, set[node]] cloneClasses) {
	set[set[node]] valuesOnly = range(cloneClasses);
	set[set[node]] cloneClassesChildren = mapper(valuesOnly, findSubtreesNodes);
	
	return (cloneClass: cloneClasses[cloneClass] | cloneClass <- cloneClasses, !isSubsumpted(cloneClasses[cloneClass], cloneClassesChildren));
}

// A subsumpted clone class is a clone class that is strictly included in another
private bool isSubsumpted(set[&T] cloneClass, set[set[&T]] cloneClassesChildren) {
	return any(set[node] setOfChildren <- cloneClassesChildren, cloneClass < setOfChildren);
}

private set[Declaration] createAstsFromFiles(set[loc] javaFiles) {
	return {createAstFromFile(location, true) | location <- javaFiles};
}

private set[node] findSubtrees(set[Declaration] fileAsts) {
	 return flatten({findSubtrees(ast) | ast <- fileAsts});
}

private set[node] findSubtrees(Declaration fileAst){
	set[node] subtrees = {};
	visit(fileAst.types) {
		case Declaration x: subtrees += x;
		case Expression x: subtrees += x;
		case Statement x: subtrees += x;
	}
	return subtrees;
}

private set[node] findSubtreesNodes(set[node] parents) {
	 return flatten({findSubtreesNode(parent) | parent <- parents});
}

private set[node] findSubtreesNode(node parent) {
	set[node] subtrees = {};
	visit(parent) {
		case node x: subtrees += x;
	}	
	return subtrees - parent;
}
