module main

import IO;
import List;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

// Maybe useful code:

//Declaration ast = createAstFromFile(fileLocation, true);
//list[Declaration] decls = ast.types;
//visit (decls) {
//    case \method(_, name, params, exceptions, impl): {
//        result += ccPerMethod(impl.src, impl);
//    }
//    case \constructor(name, params, exceptions, impl): {
//        result += ccPerMethod(impl.src, impl);
//    }
//}

public void detectClones() {
	loc project = |project://example|;
	M3 model = createM3FromEclipseProject(project);
	
	set[loc] projectFiles = {|project://example/src/HelloWorld.java|, |project://example/src/HelloWorld2.java|}; //files(model);
	allMethods = [getMethodsFromFileLocation(projectFile) | projectFile <- projectFiles];
	allMethods = mergeListOfLists(allMethods);

	type1s = getType1Clones(allMethods);
	println(type1s);
}

public list[Declaration] getMethodsFromFileLocation(loc fileLocation) {
	Declaration fileAst = createAstFromFile(fileLocation, true);
	list[Declaration] allMethods = [];
//	println(fileAst.types);
	visit (fileAst.types) {
		case fMethod:\method(_, name, params, exceptions, impl): {
//			iprintln("Found function <fMethod.decl>");
			allMethods += fMethod;
//			println(fMethod.decl);
		}
	}
	return allMethods;
}

public lrel[loc, loc] getType1Clones(list[Declaration] allMethods) {
	lrel[loc, loc] type1Clones = [];
	for (int index <- [0 .. size(allMethods)]) {
		filteredMethods = delete(allMethods, index);
		indexMethod = allMethods[index];
		println("\nSearching for clones for <indexMethod.decl>");
		type1Clones += locateType1Clones(indexMethod, filteredMethods);
	}
	return type1Clones;
}

public lrel[loc, loc] locateType1Clones(Declaration pMethod, list[Declaration] allMethods) {
	lrel[loc, loc] result = [];
	for (method <- allMethods) {
		if (areType1Clones(pMethod, method)) {
			result += <pMethod.decl, method.decl>;
			println("Type 1 clones found");
		} 
		else {
			println("METHOD1: <pMethod.decl> and METHOD2: <method.decl> are not type1 clones");
		}
	}
	return result;
}

public bool areType1Clones(Declaration method1, Declaration method2) {
	return method1.name == method2.name && areParamsEqual(method1.parameters, method2.parameters);
}

public bool areParamsEqual(list[Declaration] params1, list[Declaration] params2) {
	if (size(params1) != size(params2)) 
		return false;
	for (int i <- [0 .. size(params1)]) {
		param1 = params1[i];
		param2 = params2[i];
//		println("Comparing <param1.\type> and <param2.\type>");
//		println("Comparing <param1.name> and <param2.name>");
		if (param1.name != param2.name) // param1.\type != param2.\type || 
			return false;
	}
	return true;
}

public bool areType2Clones(Declaration method1, Declaration method2) {
	return true;
}

public list[&T] mergeListOfLists(list[list[&T]] pList) {
	result = [];
	for (pEl <- pList) {
		result += pEl;
	}
	return result;
}
