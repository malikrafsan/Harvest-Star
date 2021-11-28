/* Helper Input */
read_until_end(Output) :-
    get_char(Char),
    (
     Char = '\n' -> Output=''
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


