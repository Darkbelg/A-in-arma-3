params ["_startPos", "_stopPos"];

	_startRoad = roads select (([_startPos, 50] call BIS_fnc_nearestRoad) call findRoadIndex);
	_stopRoad = roads select (([_stopPos, 50] call BIS_fnc_nearestRoad) call findRoadIndex);

	// diag_log format ["_startRoad: %1",_startRoad];
	// diag_log format ["_stopRoad: %1",_stopRoad];

	openSet pushBack _startRoad;

	while {count openSet > 0} do {
		// diag_log format ["OpenSet size: %1, ClosedSet size: %2", count openSet, count closedSet];

		winner = 0;
		for [{_i =0}, {_i < count(openSet)}, {_i = _i + 1}] do {
			if((openSet select _i)#1 < (openSet select winner)#1) then {
				winner = _i;
			}
		};

		_current = openSet select winner;

		if(_current#4 == _stopRoad#4 && _current#5 == _stopRoad#5 ) then {

			temp = _current#0;
			path pushBack temp;
			// diag_log(format ["_current: %1", _current]);
			while {not (isNull temp)} do {
				path pushBack temp;
				// diag_log(format ["tempOld: %1", temp]);
				temp = ([temp] call findRoad)#8;
				// diag_log(format ["temp findRoad: %1", ([temp] call findRoad)]);
				// diag_log(format ["tempNew: %1", temp]);
			};

			// for [{_i =0}, {_i < count(path)}, {_i = _i + 1}] do {
			// 	_roadSection = [path select _i] call findRoad;
			// 	_name = format ["path%1%2%3", _i, _startPos ,_stopPos];
			// 	_position = [_roadSection#4, _roadSection#5];
			// 	// deleteMarker _name;
			// 	_marker = createMarker [_name,  _position];
			// 	_marker setMarkerType "hd_dot";
			// 	_marker setMarkerColor "ColorCIV";
			// };

			hint "end found";
			break;
		};

		openSet deleteAt winner;
		closedSet pushBack _current;

		_neighbors = _current#7;
		// diag_log format ["Neighbors: %1, %2", count(_neighbors), _neighbors];
		for [{_i = 0}, {_i < count(_neighbors)}, {_i = _i + 1}] do {
			// diag_log format ["Neighbor start: %1", _i];
			_neighbor = roads select ((_neighbors select _i) call findRoadIndex);

			// diag_log format ["Neighbor: %1, %2", _i, _neighbor];


			if(_neighbor#0 call InClosedSet) then {
				continue;
			};

			// _tempG = _current#2 + _current#6 + ([_current#4, _current#5] call treeCalculator);
			_tempG = _current#2 + _current#6;

			if(_neighbor#0 call InOpenSet) then {
				if(_tempG < _neighbor#2) then {
					_neighbor set [2 ,_tempG];
				};
			}  else {
				_neighbor set [2,_tempG];
				openSet pushBack _neighbor;
			};


			_neighbor set [3 , [_neighbor#4,_neighbor#5] distance2D [_stopRoad#4, _stopRoad#5]];
			_neighbor set [1 , _neighbor#2 + _neighbor#3];	
			_neighbor set [8, _current#0];

			
			diag_log(format ["_neighbor#8: %1 %2",_neighbor#0, _neighbor#8]);

			// diag_log format ["h: %1", _neighbor#3];
			// diag_log format ["h: %1", _neighbor#1];

			roads set [_neighbor#0 call findRoadIndex, _neighbor];
			// diag_log format ["Neighbor end: %1", _i];
		
		};

		counter = counter + 1;

		_name = format ["path%1", counter];
		_position = [_current#4, _current#5];
		_marker = createMarker [_name,  _position];
		_marker setMarkerType "hd_dot";
		_marker setMarkerColor "ColorGreen";



		// for [{_i =0}, {_i < count(openSet)}, {_i = _i + 1}] do {
		// 	_name = format ["openSet%1", _i];
		// 	_position = [(openSet select _i)#4, (openSet select _i)#5];
		// 	deleteMarker _name;
		// 	_marker = createMarker [_name,  _position];
		// 	_marker setMarkerType "hd_dot";
		// 	_marker setMarkerColor "ColorGreen";
		// };

		// for [{_i =0}, {_i < count(closedSet)}, {_i = _i + 1}] do {
		// 	_name = format ["closedset%1", _i];
		// 	_position =  [(closedSet select _i)#4, (closedSet select _i)#5];
		// 	deleteMarker _name;
		// 	_marker = createMarker [_name, _position];
		// 	_marker setMarkerType "hd_dot";
		// 	_marker setMarkerColor "ColorRed";
		// };
	// sleep 0.5;
	};
