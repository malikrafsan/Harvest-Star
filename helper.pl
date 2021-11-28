/* Helper Input */
read_until_end(Output) :-
    get_char(Char),
    (
     Char = '.' -> Output=''
    ;
     Char = end_of_file -> Output=''
    ;
     (
       read_until_end(NOutput),
       atom_concat(Char, NOutput, Output)
     )
    ).

read_string(Line) :-
    read_until_end(Line).


/* Helper List */
get_idx([], _, _) :- !,fail.
get_idx([H|_], 0, H).
get_idx([_|T], I, E) :-
  NI is I - 1,
  get_idx(T,NI, E).