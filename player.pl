:- dynamic(player_lvl/4).   /* player_lvl(Level total, fishing, farming, ranching) */
:- dynamic(player_xp/4).   /* player_xp(XP total, fishing, farming, ranching). asumsi naik level kalo xp total 300, trus xp job 100 */ 
:- dynamic(player_job/1).   /* ini ngeset dia jobnya apa */
:- dynamic(money/1).      /* money(Gold) */
:- dynamic(state/1).     /* State Player */

/* Facts */
job(1, 'Fisherman').
job(2, 'Farmer'). 
job(3, 'Rancher').
job_ing(1, 'Fishing').
job_ing(2, 'Farming'). 
job_ing(3, 'Ranching').

/* to get the player's stats in status */
player(Job, Leveltotal, Level1, Level2, Level3, Xptotal, Xp1, Xp2, Xp3, Gold) :-
    player_job(Job),
    player_lvl(Leveltotal, Level1, Level2, Level3),
    player_xp(Xptotal, Xp1, Xp2, Xp3),
    money(Gold), !.

/* Functions to set the player with default stats */
set_player_default(Job):-
    asserta(player_job(Job)),
    asserta(player_lvl(1,1,1,1)), 
    asserta(player_xp(0,0,0,0)), 
    asserta(money(100)),
    giveDefaultItems,  
    asserta(state(outside)),!.

/* to create the player */
write_job(Job):-
    write('You choose '),
    write(Job),
    write(', let\'s start '), job(Id,Job), job_ing(Id,Jobing), write(Jobing), write('.'), nl, !.

initPlayer :-
    write('Welcome to Harvest Star. Choose your job '),nl,
    write('1. Fisherman '),nl,
    write('2. Farmer '),nl,
    write('3. Rancher '),nl,
    read(X), nl,
    job(X, Job),
    set_player_default(Job),
    write_job(Job).

resetPlayer :-
    retractall(player_inv(_,_)),
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    retractall(player_job(_)),
    retractall(money(_)),
    retractall(state(_)).

/* List of commands */
status:-
    isGameStarted,
    player(Job, Leveltotal, Level1, Level2, Level3, Xptotal, Xp1, Xp2, Xp3, Gold),
    Xptotalcap is (300 + 30*(Leveltotal-1)),
    Xpfishcap is (100 + 10*(Level1-1)),
    Xpfarmcap is (100 + 10*(Level2-1)),
    Xpranchcap is (100 + 10*(Level3-1)),
    write('Your status: '), nl,
    write('Job: '), write(Job), nl,
    write('Level: '), write(Leveltotal), nl,
    write('Level farming: '), write(Level2), nl,
    write('EXP farming: '), write(Xp2), write('/'), write(Xpfarmcap), nl,
    write('Level fishing: '), write(Level1), nl,
    write('EXP fishing: '), write(Xp1), write('/'), write(Xpfishcap), nl,
    write('Level ranching: '), write(Level3), nl,
    write('EXP ranching: '), write(Xp3), write('/'), write(Xpranchcap), nl,
    write('EXP: '), write(Xptotal), write('/'), write(Xptotalcap), nl,
    write('Gold: '), write(Gold), nl, nl, !.

/* Operations regarding leveling up */
leveluptot :-
    player_xp(Xtot,Xfish,Xfarm,Xranch),
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    Xcap is (300 + 30*(Ltot-1)),
    L1 is Ltot + 1,
    X1 is Xtot - Xcap,
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    asserta(player_xp(X1,Xfish,Xfarm,Xranch)),
    asserta(player_lvl(L1,Lfish,Lfarm,Lranch)), !.

levelupfish :-
    player_xp(Xtot,Xfish,Xfarm,Xranch),
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    Xcap is (100 + 10*(Lfish-1)),
    L1 is Lfish + 1,
    X1 is Xfish - Xcap,
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    asserta(player_xp(Xtot,X1,Xfarm,Xranch)),
    asserta(player_lvl(Ltot,L1,Lfarm,Lranch)), !.

levelupfarm :-
    player_xp(Xtot,Xfish,Xfarm,Xranch),
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    Xcap is (100 + 10*(Lfarm-1)),
    L1 is Lfarm + 1,
    X1 is Xfarm - Xcap,
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    asserta(player_xp(Xtot,Xfish,X1,Xranch)),
    asserta(player_lvl(Ltot,Lfish,L1,Lranch)), !.

levelupranch :-
    player_xp(Xtot,Xfish,Xfarm,Xranch),
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    Xcap is (100 + 10*(Lranch-1)),
    L1 is Lranch + 1,
    X1 is Xranch - Xcap,
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    asserta(player_xp(Xtot,Xfish,Xfarm,X1)),
    asserta(player_lvl(Ltot,Lfish,Lfarm,L1)), !.

check_leveluptot:-
    player_xp(X,_,_,_), player_lvl(L,_,_,_), Xcap is (300 + 30*(L-1)),
    (X >= Xcap -> leveluptot, write('Congratulations, you leveled up!'), nl, check_leveluptot ; true), !.

check_levelupfish:-
    player_xp(_,X,_,_), player_lvl(_,L,_,_), Xcap is (100 + 10*(L-1)),
    (X >= Xcap -> levelupfish, write('Congratulations, your fishing skills leveled up!'), nl, check_levelupfish ; true), !.

check_levelupfarm:-
    player_xp(_,_,X,_), player_lvl(_,_,L,_), Xcap is (100 + 10*(L-1)),
    (X >= Xcap -> levelupfarm, write('Congratulations, your farming skills leveled up!'), nl, check_levelupfarm ; true), !.

check_levelupranch:-
    player_xp(_,_,_,X), player_lvl(_,_,_,L), Xcap is (100 + 10*(L-1)),
    (X >= Xcap -> levelupranch, write('Congratulations, your ranching skills leveled up!'), nl , check_levelupranch ; true), !.

/* Operations regarding adding xp and money */
add_xp(X2,X3,X4):-
    player_xp(Xtot, Xfish, Xfarm, Xranch),
    player_job(Job),
    (Job = 'Fisherman', Xfish1 is round(1.5*X2 + Xfish), Xfarm1 is Xfarm + X3, Xranch1 is Xranch + X4;
    Job = 'Farmer', Xfish1 is Xfish + X2, Xfarm1 is round(1.5*X3 + Xfarm), Xranch1 is Xranch + X4;
    Job = 'Rancher', Xfish1 is Xfish + X2, Xfarm1 is Xfarm + X3, Xranch1 is round(1.5*X4 + Xranch)),
    (X2 > 0 , write('You gained '), write(X2), write(' '), (Job = 'Fisherman', X2 > 1, write('(+ '), Bonus is round(0.5*X2), write(Bonus), write(' bonus) ') ; true), write('fishing xp!'),nl;true),
    (X3 > 0 , write('You gained '), write(X3), write(' '), (Job = 'Farmer', X3 > 1, write('(+ '), Bonus is round(0.5*X3), write(Bonus), write(' bonus) ') ; true), write('farming xp!'),nl;true),
    (X4 > 0 , write('You gained '), write(X4), write(' '), (Job = 'Rancher', X4 > 1, write('(+ '), Bonus is round(0.5*X4), write(Bonus), write(' bonus) ') ; true), write('ranching xp!'),nl;true),
    Xtot1 is Xtot + X2 + X3 + X4,
    retract(player_xp(_,_,_,_)),
    asserta(player_xp(Xtot1,Xfish1,Xfarm1,Xranch1)),
    check_leveluptot,
    check_levelupfish,
    check_levelupfarm,
    check_levelupranch, !.

add_money(X):-
    money(Gold),
    Gold1 is Gold + X,
    (Gold1 >= 20000 -> goal_state;
    retract(money(_)), asserta(money(Gold1))).

sub_money(X):-
    money(Gold),
    Gold1 is Gold - X,
    retract(money(_)),
    asserta(money(Gold1)).
