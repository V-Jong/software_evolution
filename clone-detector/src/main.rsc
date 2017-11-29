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
	
	set[loc] projectFiles = files(model);
	allMethods = [getMethodFromFileLocation(projectFile) | projectFile <- projectFiles];

	iprintln(allMethods);
}

public list[Declaration] getMethodFromFileLocation(loc fileLocation) {
		Declaration fileAst = createAstFromFile(fileLocation, true);
		list[Declaration] allMethods = [];
		visit (fileAst.types) {
			case fMethod:\method(_, name, params, exceptions, impl): {
				iprintln("Found function <fMethod.decl>");
				allMethods += fMethod;
			}
		}
		return allMethods;
}