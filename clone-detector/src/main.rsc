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
	map[node, set[node]] subsumptionCloneClasses = domainR(cloneClasses, subsumption(domain(cloneClasses)));
	println(size(subsumptionCloneClasses));
	//println("--------------------");
	printGroup(subsumptionCloneClasses);
}

private map[node, set[node]] filterNonDuplicates(map[node, set[node]] grouped) {
	return (group: grouped[group] | group <- grouped, size(grouped[group]) > 1);
}

public void printGroup(map[node, set[node]] group) {
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

public set[node] subsumption(set[node] cloneClasses) {
	children = findSubtreesNodes(cloneClasses);
	println(size(children));
	return {cloneClass | cloneClass <- cloneClasses, !(cloneClass in children)};
}


public set[Declaration] getFileAsts(set[loc] javaFiles) {
	return {createAstFromFile(location, true) | location <- javaFiles};
}

public set[node] findSubtrees(set[Declaration] fileAsts) {
	 return flatten({findSubtrees(ast) | ast <- fileAsts});
}

public set[node] findSubtrees(Declaration fileAst){
	set[node] subtrees = {};
	visit(fileAst.types) {
		case Declaration x: subtrees += x;
		case Expression x: subtrees += x;
		case Statement x: subtrees += x;
	}
	return subtrees;
}

public set[node] findSubtreesNodes(set[node] parents) {
	 return flatten({findSubtreesNode(parent) | parent <- parents});
}

public set[node] findSubtreesNode(node parent) {
	set[node] subtrees = {};
	visit(parent) {
		case node x: subtrees += x;
	}
	
	//println(subtrees);
	return subtrees - parent;
}

public set[&T] flatten(set[set[&T]] elems) {
	return {elem | subElems <- elems, elem <- subElems};
}

public set[&T] flatten(set[list[&T]] elems) {
	return {elem | subElems <- elems, elem <- subElems};
}

public void printSource(loc source) {
	println(readFile(source));
}

public bool isSubNode(node child, node parent) {
	return child in getChildren(parent);
}

//public void example() {
//	helloWorld = |java+compilationUnit:///src/HelloWorld.java|;
//	helloWorld2 = |java+compilationUnit:///src/HelloWorld2.java|;
//	
//	astHelloWorld = createAstFromFile(helloWorld, true);
//	astHelloWorld2 = createAstFromFile(helloWorld2, true);
//
//	
//	iprintln(unsetRec(astHelloWorld));
//	println("*****************************");
//	iprintln(unsetRec(astHelloWorld2));
//	
//	println("*****************************");
//	
//	println(unsetRec(astHelloWorld) == unsetRec(astHelloWorld2));
//}

