module main

import IO;
import List;
import Node;
import Set;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

public void detectClones() {
	loc project = |project://example|;
	M3 model = createM3FromEclipseProject(project);
	
	set[loc] projectFiles = files(model);
	set[Declaration] fileAsts = getFileAsts(projectFiles);
	
	subtrees = findSubtrees(fileAsts);
	//println(size(subtrees));
	
	map[node, set[node]] grouped = classify(subtrees, unsetRec);
	printGroup(grouped);
}

public void printGroup(map[node, set[node]] group) {
	for (key <- group) {
		//println(key);
		if(size(group[key]) > 1) {
			println(key);
			println("##########");			
			for (decl <- group[key]) {
				println(decl);
			}
			println("");
		}
	}
}

public set[Declaration] getFileAsts(set[loc] javaFiles) {
	return {createAstFromFile(location, true) | location <- javaFiles};
}

public set[Declaration] findSubtrees(set[Declaration] fileAsts) {
	 return flatten({findSubtrees(ast) | ast <- fileAsts});
}

public set[Declaration] findSubtrees(Declaration fileAst){
	set[Declaration] subtrees = {};
	visit(fileAst.types) {
		// These cases can probably be replaced by one Declaration case but I did not yet find out how.
		case d: \compilationUnit(_, _): subtrees += d;
    		case d: \compilationUnit(_, _, _): subtrees += d;
    		case d: \enum(_, _, _, _): subtrees += d;
    		case d: \enumConstant(_, _, _): subtrees += d;
    		case d: \enumConstant(_, _): subtrees += d;
    		case d: \class(_, _, _, _): subtrees += d;
    		case d: \class(_): subtrees += d;
    		case d: \interface(_, _, _, _): subtrees += d;
    		case d: \field(_, _): subtrees += d;
    		case d: \initializer(_): subtrees += d;
    		case d: \method(_, _, _, _, _): subtrees += d;
    		// this one breaks
    		//case d: \method(_, _, _, _): subtrees += d;
    		case d: \constructor(_, _, _, _): subtrees += d;
    		case d: \import(_): subtrees += d;
    		case d: \package(_): subtrees += d;
    		case d: \package(_, _): subtrees += d;
    		case d: \variables(_, _): subtrees += d;
    		case d: \typeParameter(_, _): subtrees += d;
    		case d: \annotationType(_, _): subtrees += d;
    		case d: \annotationTypeMember(_, _): subtrees += d;
    		case d: \annotationTypeMember(_, _, _): subtrees += d;
    		case d: \parameter(_, _, _): subtrees += d;
    		case d: \vararg(_, _): subtrees += d;
	}
	return subtrees;
}

public set[&T] flatten(set[set[&T]] elems) {
	return {elem | subElems <- elems, elem <- subElems};
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

