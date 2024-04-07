getRoad = {
	params ["_roadObject"];

	_roadInfo = getRoadInfo _roadObject;
	_connectedRoads = roadsConnectedTo _roadObject;

	[_roadObject,0,0,0, _roadInfo#6#0, _roadInfo#6#1, _roadInfo#9, _connectedRoads,objNull];
};

addRoads = {
	
	{
		road = [_x] call getRoad; 
		
		roads pushBack road;
	} forEach allRoads;
};

findRoad = {
	params ["_roadObject"];

	_foundObject = objNull;
	for [{_j =0}, {_j < count(roads)}, {_j = _j + 1}] do {
		if(_roadObject == (roads select _j)#0) then {
			_foundObject = roads select _j;
			break;
		};
	};
	_foundObject;
};
findRoadIndex = {
	params ["_roadObject"];

	_index = 0;
	for [{_j =0}, {_j < count(roads)}, {_j = _j + 1}] do {
		if(_roadObject == (roads select _j)#0) then {
			_index = _j;
			break;
		};
	};
	_index;
};

InClosedSet = {
	params ["_roadObject"];

	_inClosedSet = false;
	for [{_j =0}, {_j < count(closedSet)}, {_j = _j + 1}] do {
		if(_roadObject == (closedSet select _j)#0) then {
			_inClosedSet = true;
			break;
		};
	};
	_inClosedSet;
};

InOpenSet = {
	params ["_roadObject"];

	_inOpenSet = false;
	for [{_j =0}, {_j < count(openSet)}, {_j = _j + 1}] do {
		if(_roadObject == (openSet select _j)#0) then {
			_inOpenSet = true;
			break;
		};
	};
	_inOpenSet;
};

/**
	This function can add a cost to the road.
 */
treeCalculator = {
	params ["_xPos", "_yPos"];
	// This cost finds any nearby trees. We want to find open routes.
	(count(nearestTerrainObjects [[_xPos,_yPos], ["Tree"], 100]) * 1000);
};

areaPosition = getMarkerPos "obj_area";
allRoads = areaPosition nearRoads (getMarkerSize "obj_area")#0;

openSet = [];
closedSet = [];
path = [];
roads = [];

counter = 0;
[] spawn {
	scriptAddRoads = [] spawn addRoads;
};

startSearch = {
	scriptSearch = [getPosATL start_0, getPosATL end_0] execVM "A_Start.sqf";
	waituntil{scriptDone scriptSearch};
	openSet = [];
	closedSet = [];
	path = [];
	roads = [];
	scriptAddRoads = [] spawn addRoads;
	waitUntil{scriptDone scriptAddRoads};
	scriptSearch = [getPosATL start_1, getPosATL end_0] execVM "A_Start.sqf";
	waituntil{scriptDone scriptSearch};
	openSet = [];
	closedSet = [];
	path = [];
	roads = [];
	scriptAddRoads = [] spawn addRoads;
	waitUntil{scriptDone scriptAddRoads};
	scriptSearch = [getPosATL start_2, getPosATL end_0] execVM "A_Start.sqf";
	waituntil{scriptDone scriptSearch};
	openSet = [];
	closedSet = [];
	path = [];
	roads = [];
	scriptAddRoads = [] spawn addRoads;
	waitUntil{scriptDone scriptAddRoads};
	scriptSearch = [getPosATL start_3, getPosATL end_0] execVM "A_Start.sqf";
	waituntil{scriptDone scriptSearch};
	openSet = [];
	closedSet = [];
	path = [];
	roads = [];
	scriptAddRoads = [] spawn addRoads;
	waitUntil{scriptDone scriptAddRoads};
	scriptSearch = [getPosATL start_4, getPosATL end_0] execVM "A_Start.sqf";
};

startDrive = {
	scriptSearch = [getPosATL start_10, getPosATL end_10] execVM "A_Start.sqf";
	waituntil{scriptDone scriptSearch};

	start_10 setFuel 1;
	_group = group driver start_10;
	roadStep = floor(( count(path)-1) / (30 - 1));

	for [{_i = count(path) - 1}, {_i > 0 }, {_i = _i - roadStep}] do {
		_roadSection = [path select _i] call findRoad;
		_name = format ["path%1%2%3", _i, _roadSection#4 ,_roadSection#5];
		_position = [_roadSection#4, _roadSection#5];

		_wp = _group addWaypoint [_position, 1];
		_wp setWaypointCompletionRadius 50;
		_marker = createMarker [_name,  _position];
		_marker setMarkerType "hd_dot";
		_marker setMarkerColor "ColorCIV";
	};
};
