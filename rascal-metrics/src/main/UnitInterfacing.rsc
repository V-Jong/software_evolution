module main::UnitInterfacing

import IO;
import List;

import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

import main::config::Config;

public map[loc, int] getParametersPerUnit(set[loc] files) {
	result = ();
	for (file <- files) {
		Declaration ast = createAstFromFile(file, true);
		visit(ast) {
			case \method(_, name, params, exceptions, impl): {
	            result += (impl.src : size(params));
	        }
	        case \constructor(name, params, exceptions, impl): {
	            result += (impl.src : size(params));
	        }
		}
	}
	return result;
}

set[loc] filesProject() {
	M3 model = createM3FromEclipseProject(CURRENT_PROJECT);
	return files(model);
}