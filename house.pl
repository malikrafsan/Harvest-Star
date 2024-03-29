:- dynamic(diary/2).

house :-
  isGameStarted,
  (isInObject('H'),
  (retract(state(outside)),
  asserta(state(inHouse)),!;
  state(inHouse)),
  write('What do you want todo?\n'),
  write('- sleep\n'),
  write('- writeDiary\n'),
  write('- readDiary\n'),
  write('- exit\n'), !;
  write('You can\'t go to your house\n'),!).
  

rewrite_diary(Stream, _, Found):-
  at_end_of_stream(Stream), Found = false,!.

rewrite_diary(Stream, _, true):-
  at_end_of_stream(Stream),!.

rewrite_diary(Stream, Date, Found):-
  \+ at_end_of_stream(Stream),
  read(Data),
  (
    Data == diary(Date), Found = true, !;
    true
  ),
  (
    Data == end_of_file,!;
    write(Data),write('.'),nl
  ),
  rewrite_diary(Stream, Date, Found).

add_diary(Date) :-
  open('list_diary.pl', read, Read), set_input(Read),
  open('list_diary.pl', append, Append), set_output(Append),
  rewrite_diary(Read, Date, Found),
  (
    \+ Found, write('diary('), write(Date), write(').'),nl,!;
    true
  ),
  open('list_diary.pl', write, Write),
  close(Write), close(Read), close(Append).



writeDiary :-
  isGameStarted,
  state(inHouse),!,
  world(Date, Season, _), season(NS, Season), TotalDate is (NS-1) * 30 + Date, 
  (
    write('Write your diary for '), write(Season), write(' Day '), write(Date), write(': '),nl,
    read_string(Sentences),
    retractall(diary(_, _)),
    asserta(diary(TotalDate, Sentences)),
    add_diary(TotalDate),
    save(Date),
    write('Your writing has been recorded on diary.'),!
  ).
  
save(Date):-
    \+player_job(_) -> write('Game has not started') ;
    number_atom(Date, Filename),
    atom_concat('saves/', Filename, Dir),   
    open(Dir,write,Savefile),
    set_output(Savefile),
    saveall,
    close(Savefile), !.

write_list_diary([]) :- !.
write_list_diary([Head|Tail]) :-
  M is Head//30 + 1,
  D is mod(Head,30),
  season(M, Season),
  write('- '), write(Season), write(' Day '), write(D),nl,
  write_list_diary(Tail). 

readDiary :-
  isGameStarted,
  state(inHouse),!,
  (
    consult('list_diary.pl'),
    findall(
      X, diary(X), List
    ),
    length(List, Len), Len > 0,
    write('You found some entries on diary.'), nl,
    write_list_diary(List),
    write('Choose which entries that you want to read. (1 is the most top entry, 0 to cancel)'),nl,
    read(X),
    (
      X == 0,!; X1 is X - 1, X1 >= 0,
      (
        get_idx(List, X1, TotD), load_file(TotD), diary(TotD, Sentences),
        write(Sentences),nl 
      ),!;
      write('There are no entries.'),nl
    ),!;
    write('There are no diary entries.')
  ).

load_all(Stream, []):-
  at_end_of_stream(Stream),!.

load_all(Stream, [H|T]):-
  \+ at_end_of_stream(Stream),
  read(Stream,H),
  asserta(H),
  load_all(Stream, T).

load_file(Date) :-
  number_atom(Date, Filename),
  atom_concat('saves/', Filename, Dir),
  resetAll,   
  open(Dir,read,Savefile),
  load_all(Savefile, _),
  close(Savefile).

sleep :-
  isGameStarted, (
    state(inHouse), !, (
      write('You went to sleep.'), nl, nl,
      (addTime(240),
      retract(state(inHouse)),
      asserta(state(outside)),!;
      fail_state,!)
    ) ; (
      write('You can\'t sleep outside your house.\n')
    )
  ).

resetDiary :-
  retractall(diary(_,_)).

