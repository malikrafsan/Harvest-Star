:- dynamic(world/3).

season(1, 'Spring').
season(2, 'Summer').
season(3, 'Fall').
season(4, 'Winter').

% main :-
%   asserta(world(29,'Spring', 'Sunny')).

addDay :-
  world(_date, _season, _weather),
  % Menambahkan hari
  (_date < 30, _date1 is _date + 1, _season1 = _season, !;
   _date == 30, _date1 is 1, season(X, _season), X1 is X + 1, season(X1, _season1), !),
  % Random weather berdasarkan season
  (_season1 == 'Spring', S is 3, SR is 10, SRW is 10, !;
   _season1 == 'Summer', S is 5, SR is 10, SRW is 10, !;
   _season1 == 'Fall', S is 7, SR is 10, SRW is 10, !;
   _season1 == 'Winter', S is 3, SR is 4, SRW is 10, !),
  random(0, SRW, Y),
  (Y =< S, _weather1 = 'Sunny', !;
   Y =< SR, _weather1 = 'Rainy', !;
   Y =< SRW, _weather1 = 'Snowy'),
  % Assign world 
  retract(world(_,_,_)),
  asserta(world(_date1,_season1,_weather1)).
  

fail_state :-
  write('Setelah 1 tahun berlalu, kamu tidak bisa mendapatkan kemakmuran yang kau incar\n'),
  write('Kamu tetap hidup dalam kesengsaraan.\n').
  % TODO: reset game