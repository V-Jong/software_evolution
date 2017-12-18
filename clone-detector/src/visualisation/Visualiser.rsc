module visualisation::Visualiser

import IO;
import Map;
import Set;

import main::CloneMetrics;
import main::LinesOfCode;

import util::IDE;
import util::Editors;
import lang::java::m3::AST;

import vis::Figure;
import vis::Render;
import vis::KeySym;

public void getFileVisualisations(map[str, set[node]] clonesPerFiles, loc project) {
	list[Figure] fileFigs = [];
	for (file <- clonesPerFiles) {
		if (file != "/") {
			set[node] fileClones = clonesPerFiles[file];
			loc fileLoc = project + file;
			int fileSize = LOCForFileAst(createAstFromFile(fileLoc, true));
			Figure linesFig = vcat(getLines(fileSize, fileClones), resizable(false), hsize(130));
			Figure fileFig = vcat([text(fileLoc.file, valign(0)), linesFig], resizable(false));
			fileFigs += fileFig;
		}
	}
	render(hvcat(fileFigs, gap(20), ialign(0.0)));
}

public list[Figure] getLines(int size, set[node] clones) {
	figures = [];
	for (int i <- [1 .. size+1]) {
		if (isCloneLine(i, clones)) {
			loc cloneLocation = getSmallestCloneForLine(i, clones) ;//|project://example/src/HelloWorld.java|;
			figures += box(fillColor("red"), addPopup(readFile(cloneLocation)), 
					addClick(cloneLocation), resizable(false), lineSize(130));
		}
		else
			figures += box(fillColor("white"), resizable(false), lineSize(130));
	}
	return figures;
}

private bool isCloneLine(int lineNumber, set[node] clones) {
	for (clone <- clones) {
		if (loc cloneLocation := clone.src) {
//			list[int] lineRange = [cloneLocation.begin.line .. (cloneLocation.end.line+1)];
			if (lineNumber >= cloneLocation.begin.line && lineNumber <= cloneLocation.end.line)
				return true;
		}
	}
	return false;
}

private loc getSmallestCloneForLine(int lineNumber, set[node] clones) {
	list[node] smallestClones = [];
	for (clone <- clones) {
		if (loc cloneLocation := clone.src) {
//			list[int] lineRange = [cloneLocation.begin.line .. cloneLocation.end.line+1];
			if (lineNumber >= cloneLocation.begin.line && lineNumber <= cloneLocation.end.line) {
				smallestClones += clone;
			}
		}
	}
	node smallestClone;
	int distance = 1000000000;
	for (smallClone <- smallestClones) {
		int curDistance = getLocationSize(smallClone.src);
		if (curDistance < distance) {
			smallestClone = smallClone;
			distance = curDistance;
		}
	}
	return getLocationFromValue(smallestClone.src);
}

private FProperty lineSize(int width) {
	return size(width, 10);
}

private FProperty addPopup(str message) {
	return mouseOver(box(text(message), fillColor("lightyellow"), halign(1),  resizable(false)));
}

private FProperty addClick(loc jumpTo) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		edit(jumpTo);
		return true;
	});
}
