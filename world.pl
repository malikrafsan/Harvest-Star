:- dynamic(world/3).
:- dynamic(time/1).

season(1, 'Spring').
season(2, 'Summer').
season(3, 'Fall').
season(4, 'Winter').

resetWorld :-
  retractall(world(_,_,_)),
  retractall(time(_)).

initWorld :-
  asserta(world(1,'Spring', 'Sunny')),
  asserta(time(60)).

addDay :-
  world(_date, _season, _weather),
  % Menambahkan hari
  (_date < 30, _date1 is _date + 1, _season1 = _season, !;
   _date == 30, _date1 is 1, season(X, _season), X1 is X + 1, season(X1, _season1), !),
  % Random weather berdasarkan season
  (_season1 == 'Fall', S is 3, SR is 10, SRW is 10, !;
   _season1 == 'Spring', S is 5, SR is 10, SRW is 10, !;
   _season1 == 'Summer', S is 7, SR is 10, SRW is 10, !;
   _season1 == 'Winter', S is 4, SR is 5, SRW is 10, !),
  random(1, SRW, Y),
  (Y =< S, _weather1 = 'Sunny', !;
   Y =< SR, _weather1 = 'Rainy', !;
   Y =< SRW, _weather1 = 'Snowy'),
  updateHarvestTime,
  updateDayLeft,
  (
    advAlchemistDate,!;
    true
  ),      
  getFairy,
  retractall(player_position(_,_)),
  map_object('H', X2,Y2),
  asserta(player_position(X2,Y2)),
  % Assign world 
  retract(world(_,_,_)),
  asserta(world(_date1,_season1,_weather1)),  
  write('Day '), write(_date1), write('\n'),
  write('Season : '), write(_season1), write('\n'),
  write('Weather : '), write(_weather1), write('\n').

  

fail_state :-
  write('One year passed and yet you still can\'t pay your debt.\n'),
  money(Gold),
  write('You failed miserably and you only have: '), write(Gold), write(' Gold.'),nl,
  resetAll,
  startGame.

goal_state :-
  write('Congratulations you\'ve paid your debt!'), nl,
  write('With this, you can enjoy your remaining life in this farmland.'), nl,
  world(Date, Season,_), season(SN, Season), TotDay is (SN -1) * 30 + Date,
  write('You completed this game in: '), write(TotDay), write(' Days'),nl,
  resetAll,
  startGame.


addTime(Time) :-
  retract(time(X)),
  X1 is Time + X,
  (
    X1 < 240, asserta(time(X1)),!;
    nl,
    write('You fell asleep'),nl,nl,
    addDay,
    asserta(time(60))
  ),
  time.

time :-
  time(Time),
  Hr is Time // 10,
  Mn is mod(Time, 10) * 6,
  write('Time: '), write(Hr),write(':'),
  (
    Mn < 10, write(0), write(Mn),!;
    write(Mn)
  ),nl.