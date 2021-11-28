move(X,Y) :-
    isGameStarted,
    state(outside), !, (
        isInMap(X,Y), !, (
            map_object('o', X, Y), !, ( 
                write('You can\'t move into water!'), nl, fail
            ) ; (
                player_position(OX, OY),
                AX is abs(X - OX),
                AY is abs(Y - OY),
                MDist is AX + AY,
                retractall(player_position(_, _)),
                asserta(player_position(X, Y)),
                addTime(MDist)
            )
        ) ; (
            write('You can\'t move outside the map!'), nl, fail
        )
    ) ; (
        player_position(_, _),
        write('You\'re not outside.'), nl,
        write(' Use command \'exit\' to go outside.'), nl, fail
    ).

w :-
    isGameStarted,
    player_position(X, Y),
    YP is Y - 1,
    move(X, YP),
    write('You moved to North'), nl.

a :-
    isGameStarted,
    player_position(X, Y),
    XP is X - 1,
    move(XP, Y),
    write('You moved to West'), nl.

s :-
    isGameStarted,
    player_position(X, Y),
    YP is Y + 1,
    move(X, YP),
    write('You moved to South'), nl.

d :-
    isGameStarted,
    player_position(X, Y),
    XP is X + 1,
    move(XP, Y),
    write('You moved to East'), nl.
