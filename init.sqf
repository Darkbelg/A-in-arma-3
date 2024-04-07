getRoad = {
	params ["_roadObject"];

	// diag_log format ["roadObject Type: %1",typeName _roadObject];

	_roadInfo = getRoadInfo _roadObject;
	_connectedRoads = roadsConnectedTo _roadObject;

	[_roadObject,0,0,0, _roadInfo#6#0, _roadInfo#6#1, _roadInfo#9, _connectedRoads,objNull];
};

addRoads = {
	
	{
		road = [_x] call getRoad; 
		//diag_log format [ 'Roads: %1' , road];
		
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

	
treeCalculator = {
	params ["_xPos", "_yPos"];

	(count(nearestTerrainObjects [[_xPos,_yPos], ["Tree"], 100]) * 1000);
};
// A_Start = {
// 	_startRoad = roads select (([getPosATL player, 50] call BIS_fnc_nearestRoad) call findRoadIndex);
// 	_stopRoad = roads select (([getPosATL obj_stop, 50] call BIS_fnc_nearestRoad) call findRoadIndex);

// 	// diag_log format ["_startRoad: %1",_startRoad];
// 	// diag_log format ["_stopRoad: %1",_stopRoad];

// 	openSet pushBack _startRoad;

// 	while {count openSet > 0} do {
// 		// diag_log format ["OpenSet size: %1, ClosedSet size: %2", count openSet, count closedSet];

// 		winner = 0;
// 		for [{_i =0}, {_i < count(openSet)}, {_i = _i + 1}] do {
// 			if((openSet select _i)#1 < (openSet select winner)#1) then {
// 				winner = _i;
// 			}
// 		};

// 		_current = openSet select winner;

// 		if(_current#4 == _stopRoad#4 && _current#5 == _stopRoad#5 ) then {

// 			// _temp = _current;
// 			// path pushBack _temp;
// 			// while {temp#8} do {
// 			// 	path pushBack _temp#8;
// 			// 	_temp = roads select (roads ) (_temp#8 get road);
				
// 			// };

// 			// for [{_i =0}, {_i < count(path)}, {_i = _i + 1}] do {
// 			// 	_name = format ["path%1", _i];
// 			// 	_position = [(path select _i)#4, (path select _i)#5];
// 			// 	deleteMarker _name;
// 			// 	_marker = createMarker [_name,  _position];
// 			// 	_marker setMarkerType "hd_dot";
// 			// 	_marker setMarkerColor "ColorYellow";
// 			// };

// 			hint "end found";
// 			break;
// 		};

// 		openSet deleteAt winner;
// 		closedSet pushBack _current;

// 		_neighbors = _current#7;
// 		// diag_log format ["Neighbors: %1, %2", count(_neighbors), _neighbors];
// 		for [{_i = 0}, {_i < count(_neighbors)}, {_i = _i + 1}] do {
// 			// diag_log format ["Neighbor start: %1", _i];
// 			_neighbor = roads select ((_neighbors select _i) call findRoadIndex);

// 			// diag_log format ["Neighbor: %1, %2", _i, _neighbor];


// 			if(not (_neighbor#0 call InClosedSet)) then {
// 				_tempG = _current#2 + 1;

// 				if(_neighbor#0 call InOpenSet) then {
// 					if(_tempG < _neighbor#2) then {
// 						_neighbor set [2 ,_tempG];
// 					};
// 				}  else {
// 					_neighbor set [2,_tempG];
// 					openSet pushBack _neighbor;
// 				};
// 			};

// 			_neighbor set [3 , [_neighbor#4,_neighbor#5] distance2D [_stopRoad#4, _stopRoad#5]];
// 			_neighbor set [1 , _neighbor#2 + _neighbor#3];
// 			_neighbor set [8, _neighbor#0];

// 			// diag_log format ["h: %1", _neighbor#3];
// 			// diag_log format ["h: %1", _neighbor#1];

// 			roads set [_neighbor#0 call findRoadIndex, _neighbor];
// 			// diag_log format ["Neighbor end: %1", _i];
// 		};


// 		// for [{_i =0}, {_i < count(openSet)}, {_i = _i + 1}] do {
// 		// 	_name = format ["openSet%1", _i];
// 		// 	_position = [(openSet select _i)#4, (openSet select _i)#5];
// 		// 	deleteMarker _name;
// 		// 	_marker = createMarker [_name,  _position];
// 		// 	_marker setMarkerType "hd_dot";
// 		// 	_marker setMarkerColor "ColorGreen";
// 		// };

// 		// for [{_i =0}, {_i < count(closedSet)}, {_i = _i + 1}] do {
// 		// 	_name = format ["closedset%1", _i];
// 		// 	_position =  [(closedSet select _i)#4, (closedSet select _i)#5];
// 		// 	deleteMarker _name;
// 		// 	_marker = createMarker [_name, _position];
// 		// 	_marker setMarkerType "hd_dot";
// 		// 	_marker setMarkerColor "ColorRed";
// 		// };
// 	// sleep 0.5;
// 	};
	
// };

areaPosition = getMarkerPos "obj_area";
allRoads = areaPosition nearRoads (getMarkerSize "obj_area")#0;

openSet = [];
closedSet = [];
path = [];
roads = [];

counter = 0;
[] spawn {
	scriptAddRoads = [] spawn addRoads;
	// waitUntil{scriptDone scriptAddRoads};
	//[] spawn A_Start;
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
		// deleteMarker _name;
		_wp = _group addWaypoint [_position, 1];
		_wp setWaypointCompletionRadius 50;
		_marker = createMarker [_name,  _position];
		_marker setMarkerType "hd_dot";
		_marker setMarkerColor "ColorCIV";
	};
	// _totalRoadSections = count(path);
	// _jumps = count(path)/20;
	// for [{_i = count(path) - 1}, {_i > 0 }, {_i = _i - 1}] do {
	// 	_roadSection = [path select _i] call findRoad;
	// 	_name = format ["path%1%2%3", _i, _roadSection#4 ,_roadSection#5];
	// 	_position = [_roadSection#4, _roadSection#5];
	// 	// deleteMarker _name;
	// 	_wp = _group addWaypoint [_position, 15];
	// 	_marker = createMarker [_name,  _position];
	// 	_marker setMarkerType "hd_dot";
	// 	_marker setMarkerColor "ColorCIV";
	// };
};