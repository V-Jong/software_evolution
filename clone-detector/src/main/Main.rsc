module main::Main

import List;
import Node;
import Set;
import Map;

import IO;

import main::lib::SetHelpers;

import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

public void detectClones() {
	loc project = |project://example|;
	M3 model = createM3FromEclipseProject(project);
	
	set[loc] projectFiles = files(model);
	set[Declaration] fileAsts = createAstsFromFiles(projectFiles);
	
	set[node] subtrees = findSubtrees(fileAsts);

	map[node, set[node]] groupedByNormalisedDeclaration = classify(subtrees, unsetRec);
	map[node, set[node]] cloneClasses = filterNonDuplicates(groupedByNormalisedDeclaration);
	map[node, set[node]] noSubsumptedCloneClasses = dropSubsumptedCloneClasses(cloneClasses);

	printCloneClasses(noSubsumptedCloneClasses);
}

private void printCloneClasses(map[node, set[node]] cloneClasses) {
	set[set[node]] cloneGroups = range(cloneClasses);
	
	for(cloneGroup <- cloneGroups) {
		for(clone <- cloneGroup) {
			switch (clone) {
				case Declaration x: println(readFile(x.src));
				case Expression x: println(readFile(x.src));
				case Statement x: println(readFile(x.src)); 
			}
		}
	}
}

private map[node, set[node]] filterNonDuplicates(map[node, set[node]] grouped) {
	return (group: grouped[group] | group <- grouped, size(grouped[group]) > 1);
}

public map[node, set[node]] dropSubsumptedCloneClasses(map[node, set[node]] cloneClasses) {
	set[set[node]] valuesOnly = range(cloneClasses);
	set[set[node]] cloneClassesChildren = mapper(valuesOnly, findSubtreesNodes);
	
	return (cloneClass: cloneClasses[cloneClass] | cloneClass <- cloneClasses, !isSubsumpted(cloneClasses[cloneClass], cloneClassesChildren));
}

// A subsumpted clone class is a clone class that is strictly included in another
public bool isSubsumpted(set[&T] cloneClass, set[set[&T]] cloneClassesChildren) {
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
