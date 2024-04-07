params ["_startPos", "_stopPos"];

_startRoad = roads select (([_startPos, 50] call BIS_fnc_nearestRoad) call findRoadIndex);
_stopRoad = roads select (([_stopPos, 50] call BIS_fnc_nearestRoad) call findRoadIndex);

openSet pushBack _startRoad;

while {count openSet > 0} do {

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
		while {not (isNull temp)} do {
			path pushBack temp;
			temp = ([temp] call findRoad)#8;
		};

		hint "end found";
		break;
	};

	openSet deleteAt winner;
	closedSet pushBack _current;

	_neighbors = _current#7;

	for [{_i = 0}, {_i < count(_neighbors)}, {_i = _i + 1}] do {
		_neighbor = roads select ((_neighbors select _i) call findRoadIndex);

		if(_neighbor#0 call InClosedSet) then {
			continue;
		};

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

		roads set [_neighbor#0 call findRoadIndex, _neighbor];		
	};

	counter = counter + 1;

	_name = format ["path%1", counter];
	_position = [_current#4, _current#5];
	_marker = createMarker [_name,  _position];
	_marker setMarkerType "hd_dot";
	_marker setMarkerColor "ColorGreen";
};
