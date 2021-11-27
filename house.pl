:- dynamic(state/1).

house :-
  % TODO: cek posisi di house
  (retract(state(outside)),
  asserta(state(inHouse)),
  write('What do you want todo?\n'),
  write('- sleep\n'),
  write('- writeDiary\n'),
  write('- readDiary\n'),
  write('- exit\n'), !;
  write('You can\'t go to your house\n'),!).
  

sleep :-
  state(inHouse),!,
  write('You went to sleep.\n\n'),
  (addTime(240),
  world(_date, _season, _weather),
  write('Day '), write(_date), write('\n'),
  write('Season : '), write(_season), write('\n'),
  write('Weather : '), write(_weather), write('\n'),
  retract(state(inHouse)),
  asserta(state(outside)),!;
  fail_state,!).

sleep :-
  write('You can\'t sleep outside your house.\n').
