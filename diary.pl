/*ini masih asumsi game belum mulai kalo player_job gaada karena otomatis belum start game*/

save :-
    \+player_job(_) -> write('Game has not started') ;   
    write('input your filename: '),nl, read(Filename), 
    open(Filename,write,Savefile),
    set_output(Savefile),
    saveplayer, 
    saveinventory,/*setelah ini kasih save semua dynamics*/
    close(Savefile), !.
    
    
saveplayer :-
    player_job(Job),
    player_lvl(Leveltotal, Level1, Level2, Level3),
    player_xp(Xptotal, Xp1, Xp2, Xp3),
    money(Gold),
    write('player_job(\''),write(Job),write('\').'), nl,
    write(player_lvl(Leveltotal, Level1, Level2, Level3)),write('.'), nl,
    write(player_xp(Xptotal, Xp1, Xp2, Xp3)),write('.'), nl,
    write(money(Gold)),write('.'), nl.

saveinventory :-
    forall(player_inv(Name,Qty),(write('player_inv(\''),write(Name),write('\','),write(Qty), write(').'), nl)).
    
load:-
    player_job(_) -> write('Game has already started!');
    write('input your filename: '), nl, read(Filename),    
    ( \+file_exists(Filename), write('Filename does not exist.'), nl, !;
    open(Filename, read, Str),
    readfromfile(Str,_),
    close(Str),
    nl,write('Succesfully loaded from savefile'), nl,
    write('Continuing from last progress.'), nl).

readfromfile(Stream,[]) :-
    at_end_of_stream(Stream),!.

readfromfile(Stream,[H|T]) :-
    \+at_end_of_stream(Stream),
    read(Stream,H),
    assertz(H),
    readfromfile(Stream,T).