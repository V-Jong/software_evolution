module main

import IO;
import List;
import Node;
import Set;
import Map;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

public void detectClones() {
	loc project = |project://example|;
	M3 model = createM3FromEclipseProject(project);
	
	set[loc] projectFiles = files(model);
	set[Declaration] fileAsts = getFileAsts(projectFiles);
	
	subtrees = findSubtrees(fileAsts);
	//println(size(subtrees));
	
	map[node, set[node]] groupedClasses = classify(subtrees, unsetRec);
	println(size(groupedClasses));
	map[node, set[node]] cloneClasses = filterNonDuplicates(groupedClasses);
	println(size(cloneClasses));
	//map[node, set[node]] removedSubtrees = domainX(cloneClasses, subsumption(domain(cloneClasses)));
	map[node, set[node]] subsumptedCloneClasses = subsumption(cloneClasses);
	println(size(subsumptedCloneClasses));
	//println("--------------------");
	printGroup(subsumptedCloneClasses);
}

private map[node, set[node]] filterNonDuplicates(map[node, set[node]] grouped) {
	return (group: grouped[group] | group <- grouped, size(grouped[group]) > 1);
}

// subsumption drops all clone classes that are strictly included in others
private map[node, set[node]] subsumption(map[node, set[node]] cloneClasses) {
	set[set[node]] valuesOnly = range(cloneClasses);
	set[set[node]] cloneClassessChildren = mapper(valuesOnly, findSubtreesNodes);
	
		
	return (cloneClass: cloneClasses[cloneClass] | cloneClass <- cloneClasses, memberOfSet(cloneClasses[cloneClass], cloneClassessChildren));
}

private bool memberOfSet(set[node] cloneClass, set[set[node]] cloneClassessChildren) {
	for (setOfChildren <- cloneClassessChildren) {
		if (cloneClass < setOfChildren) { 
			return true;
		}
	}
	return false;
}

private set[Declaration] getFileAsts(set[loc] javaFiles) {
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

private set[&T] flatten(set[set[&T]] elems) {
	return {elem | subElems <- elems, elem <- subElems};
}

private set[&T] flatten(set[list[&T]] elems) {
	return {elem | subElems <- elems, elem <- subElems};
}

private map[&K, &V2] mapValues(map[&K, &V] genericMap, fn) {
	return (key: fn(genericMap[key]) | key <- genericMap);
}

private void printSource(loc source) {
	println(readFile(source));
}

private void printGroup(map[node, set[node]] group) {
	for (key <- group) {
		println(key);
		//printSource(getOneFrom(group[key]).src);
		println("##########");			
		for (decl <- group[key]) {
			print(decl);
		}
		println("");
		println("");
	}
}
