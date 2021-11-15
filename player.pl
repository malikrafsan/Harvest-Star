:- dynamic(player_lvl/4).   /* player_lvl(Level total, fishing, farming, ranching) */
:- dynamic(player_xp/4).   /* player_xp(XP total, fishing, farming, ranching). asumsi naik level kalo xp total 300, trus xp job 100 */ 
:- dynamic(player_job/1).   /* ini ngeset dia jobnya apa */
:- dynamic(player_inv/3).    /* (list of items, cap, neff) */
:- dynamic(player_position/2). /* posisinya dalam x,y kali ya */
:- dynamic(money/1).      /* money(Gold) */
:- dynamic(onGoingQuest/3 ).   /* misi minimal fishing, farming, ranching, nanti di random generator */
:- dynamic(state/1).  /* sori aku lupa ini buat apa oawkaowk */

/* Facts */
job(1, 'Fisherman').
job(2, 'Farmer'). 
job(3, 'Rancher').
job_ing(1, 'Fishing').
job_ing(2, 'Farming'). 
job_ing(3, 'Ranching').

/* Functions to set the player with default stats */
set_job_default(Job):-
    asserta(player_job(Job)), !.

set_lvl_default:-
    asserta(player_lvl(1,1,1,1)), !.

set_xp_default:-
    asserta(player_xp(0,0,0,0)), !.

set_money_default:-
    asserta(money(1000)), !.

set_position_default:-
    asserta(player_position(1,1)), !.

set_player_default(Job):-
    set_job_default(Job),
    set_lvl_default,
    set_xp_default,
    set_position_default, 
    set_money_default, !. 

/* to get the player's stats in status */
player(Job, Leveltotal, Level1, Level2, Level3, Xptotal, Xp1, Xp2, Xp3, Gold) :-
    player_job(Job),
    player_lvl(Leveltotal, Level1, Level2, Level3),
    player_xp(Xptotal, Xp1, Xp2, Xp3),
    money(Gold), !.

/* To get random quests */
create_quest :-
    random(0,6,X),
    random(0,6,Y),
    random(0,6,Z),
    asserta(onGoingQuest(X,Y,Z)).

/* to create the player */
write_job(Jobing):-
    write('You choose '),
    write(Jobing),
    write(', lets start working'), nl, nl, !.

create_player :-
    write('Welcome to Harvest Star. Choose your job '),nl,
    write('1. Fisherman '),nl,
    write('2. Farmer '),nl,
    write('3. Rancher '),nl,
    read(X), nl,
    job(X, Job),
    job_ing(X,Jobing),
    set_player_default(Job),
    create_quest,
    write_job(Jobing).

/* List of commands */
status:-
    player(Job, Leveltotal, Level1, Level2, Level3, Xptotal, Xp1, Xp2, Xp3, Gold),
    write('Your status: '), nl,
    write('Job: '), write(Job), nl,
    write('Level: '), write(Leveltotal), nl,
    write('Level farming: '), write(Level1), nl,
    write('EXP farming: '), write(Xp1), nl,
    write('Level fishing: '), write(Level2), nl,
    write('EXP fishing: '), write(Xp2), nl,
    write('Level ranching: '), write(Level3), nl,
    write('EXP ranching: '), write(Xp3), nl,
    write('EXP: '), write(Xptotal), write('/'), write('300'), nl,
    write('Gold: '), write(Gold), nl, nl, !.

/*w :-
    player_position(PosX, PosY),
    retractall(player_position(_, _)),
    PosY1 is PosY + 1,
    asserta(player_position(PosX, PosY1)).

a :-
    player_position(PosX, PosY),
    retractall(player_position(_, _)),
    PosX1 is PosX - 1,
    asserta(player_position(PosX1, PosY)).

s :-
    player_position(PosX, PosY),
    retractall(player_position(_, _)),
    PosY1 is PosY - 1,
    asserta(player_position(PosX, PosY1)).

d :-
    player_position(PosX, PosY),
    retractall(player_position(_, _)),
    PosX1 is PosX + 1,
    asserta(player_position(PosX1, PosY)).*/

/* Operations regarding leveling up */
leveluptot :-
    player_xp(Xtot,Xfish,Xfarm,Xranch),
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    L1 is Ltot + 1,
    X1 is Xtot - 300,
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    asserta(player_xp(X1,Xfish,Xfarm,Xranch)),
    asserta(player_lvl(L1,Lfish,Lfarm,Lranch)), !.

levelupfish :-
    player_xp(Xtot,Xfish,Xfarm,Xranch),
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    L1 is Lfish + 1,
    X1 is Xfish - 100,
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    asserta(player_xp(Xtot,X1,Xfarm,Xranch)),
    asserta(player_lvl(Ltot,L1,Lfarm,Lranch)), !.

levelupfarm :-
    player_xp(Xtot,Xfish,Xfarm,Xranch),
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    L1 is Lfarm + 1,
    X1 is Xfarm - 100,
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    asserta(player_xp(Xtot,Xfish,X1,Xranch)),
    asserta(player_lvl(Ltot,Lfish,L1,Lranch)), !.

levelupranch :-
    player_xp(Xtot,Xfish,Xfarm,Xranch),
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    L1 is Lranch + 1,
    X1 is Xranch - 100,
    retractall(player_lvl(_,_,_,_)),
    retractall(player_xp(_,_,_,_)),
    asserta(player_xp(Xtot,Xfish,Xfarm,X1)),
    asserta(player_lvl(Ltot,Lfish,Lfarm,L1)), !.

check_leveluptot:-
    player_xp(X,_,_,_),
    (X >= 300 -> leveluptot, write('Congratulations, you leveled up!'), nl, check_leveluptot ; true), !.

check_levelupfish:-
    player_xp(_,X,_,_),
    (X >= 100 -> levelupfish, write('Congratulations, your fishing skills leveled up!'), nl, check_levelupfish ; true), !.

check_levelupfarm:-
    player_xp(_,_,X,_),
    (X >= 100 -> levelupfarm, write('Congratulations, your farming skills leveled up!'), nl, check_levelupfarm ; true), !.

check_levelupranch:-
    player_xp(_,_,_,X),
    (X >= 100 -> levelupranch, write('Congratulations, your ranching skills leveled up!'), nl , check_levelupranch ; true), !.

/* Operations regarding adding xp and money */
add_xp(X1,X2,X3,X4):-
    player_xp(Xtot, Xfish, Xfarm, Xranch),
    Xtot1 is Xtot + X1,
    Xfish1 is Xfish + X2,
    Xfarm1 is Xfarm + X3,
    Xranch1 is Xranch + X4,
    retract(player_xp(_,_,_,_)),
    asserta(player_xp(Xtot1,Xfish1,Xfarm1,Xranch1)),
    check_leveluptot,
    check_levelupfish,
    check_levelupfarm,
    check_levelupranch, !.

add_money(X):-
    money(Gold),
    Gold1 is Gold + X,
    retract(money(_)),
    asserta(money(Gold1)),
    write('Gold: '), write(Gold1), nl, !.

sub_money(X):-
    money(Gold),
    Gold1 is Gold - X,
    retract(money(_)),
    asserta(money(Gold1)),
    write('Gold: '), write(Gold1), nl, !.


