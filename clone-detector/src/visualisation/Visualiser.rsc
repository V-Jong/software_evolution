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

public void main() {
	s = "";
	b = box(text(str () { return s; }), fillColor("red"), shrink(0.5), onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		s = "<butnr>";
		return true;
	}));
//	render(b);
//	render(tree());
//	render(outline([info(100,"a"), warning(125, "b"), highlight(190, "c")], 200, size(50, 200)));
	i = vcat(getLines(23, [3,4,5,6,7,8,10,11,12,13,14,15,18,19,20,21]), resizable(false), size(130, 200));
	sc = vcat([text("HelloWorld.java\n"), i], resizable(false));
//	render(sc);
	
	b1 = box(size(20,30), fillColor("Red"));
	b2 = box(size(40,20), fillColor("Blue"));
	b3 = box(size(40,40), fillColor("Yellow"));
	b4 = box(size(10,20), fillColor("Green"));
	b5 = box(size(10,20), fillColor("Purple"));
	b6 = box(size(60,20), fillColor("Orange"));
	render(hvcat([b1, b2, b3, b4, b5, b6], gap(5)));
}

public void getFileVisualisations(map[str, set[node]] clonesPerFiles, loc project) {
	list[Figure] fileFigs = [];
	for (file <- clonesPerFiles) {
		if (file != "/") {
			set[node] fileClones = clonesPerFiles[file];
			loc fileLoc = project + file;
			int fileSize = LOCForFileAst(createAstFromFile(fileLoc, true));
			Figure linesFig = vcat(getLines(fileSize, fileClones), resizable(false), hsize(130), top());
			Figure fileFig = vcat([text(fileLoc.file, valign(0)), linesFig], resizable(false), valign(0));
			fileFigs += fileFig;
		}
	}
	render(hvcat(fileFigs, gap(20), valign(0)));
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
			list[int] lineRange = [cloneLocation.begin.line .. (cloneLocation.end.line+1)];
			if (lineNumber in lineRange)
				return true;
		}
	}
	return false;
}

private loc getSmallestCloneForLine(int lineNumber, set[node] clones) {
	list[node] smallestClones = [];
	for (clone <- clones) {
		if (loc cloneLocation := clone.src) {
			list[int] lineRange = [cloneLocation.begin.line .. cloneLocation.end.line+1];
			if (lineNumber in lineRange) {
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
