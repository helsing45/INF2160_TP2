#!C:\Program Files (x86)\swipl\bin\pl -q -g main -s

%Pour tester votre programme, charger le fichier des données (donneesTp2.pl), votre sources (Tp2.pl) et ce fichier test (testTp2.pl) comme suit
:- ['donneesTp2.pl', 'Tp2.pl'].
% Ensuite, tester en exécutant les testi en mode interactif.


% Tests pour 'listeActeurs' et pour 'experience'
test11 :- listeActeurs([arnold, merryl, maxi, julia, reno, sharon, robert]).
test21 :- experience(robert,2016,19).
test22 :- experience(merryl,2005,21).

% Tests pour 'filtreCritere'.
test31 :- findall(Act,(member(Act,[arnold, merryl, maxi, julia, reno, sharon, robert]),filtreCritere([feminin, revenuMin], Act)),[merryl, julia]).
test32 :- findall(Act,(member(Act,[arnold, merryl, maxi, julia, reno, sharon, robert]),filtreCritere([masculin, revenuMin, experienceMax], Act)),[robert]).

% Tests pour 'totalSalaireMin'.
test41 :-  totalSalaireMin([arnold, sharon, reno],1600).

% Tests pour 'selectionActeursCriteres'.
test5a1 :- selectionActeursCriteres([revenuMin], [merryl, julia, robert]).
test5a2 :- selectionActeursCriteres([masculin,experienceMin],[arnold, reno, robert]).
test5a3 :- selectionActeursCriteres([feminin,experienceMin,revenuMin],[merryl, julia]).

% Tests pour 'selectionActeursCriteresNouvelle'.
test5b1 :- selectionActeursCriteresNouvelle([masculin,feminin,revenuMin],[arnold, merryl, maxi, julia, reno, sharon, robert],[arnold, merryl, julia]).
test5b2 :- selectionActeursCriteresNouvelle([masculin,feminin,revenuMin,experienceMin],[arnold, merryl, maxi, julia, reno, sharon, robert],[arnold, merryl, julia, reno]).
test5b3 :- selectionActeursCriteresNouvelle([feminin,feminin,masculin,experienceMin],[arnold, merryl, maxi, julia, reno, sharon, robert],[merryl, julia, arnold, reno]).
test5b4 :- selectionActeursCriteresNouvelle([masculin,feminin,revenuMin,experienceMax],[arnold, merryl, maxi, julia, reno, sharon, robert],[arnold, merryl, julia, maxi]).

% Tests pour 'filmsAdmissibles'.
test61 :- filmsAdmissibles(maxi,[sica, nuit, coupe, wind, wind2]).
test62 :- filmsAdmissibles(julia, [nuit, wind, wind2]).
test63 :- filmsAdmissibles(merryl,[nuit, wind, wind2, sherlock]).


% Tests pour 'selectionActeursFilm'.
test7a1 :- selectionActeursFilm(nuit,[merryl, maxi, julia]).
test7a2 :- selectionActeursFilm(avengers,[arnold, sharon, robert]).
test7a3 :- selectionActeursFilm(wind2,[merryl, maxi, julia, reno]).
test7a4 :- selectionActeursFilm(coupe,[maxi]).

% Tests pour 'selectionActeursFilm'.
test7b1 :- selectionNActeursFilm2(wind2,[merryl, maxi]).
test7b2 :- selectionNActeursFilm2(avengers,[sharon, robert]).
test7b3 :- selectionNActeursFilm2(wind,[merryl, maxi, julia, reno]).
test7b4 :- selectionNActeursFilm2(sherlock,[merryl]).

% Tests pour 'affectationDesRolesSansCriteres & joueDans'.
test9a1 :- affectationDesRolesSansCriteres(sherlock), joueDans(merryl, sherlock).
test9a2 :- \+affectationDesRolesSansCriteres(sherlock).
test9a3 :- affectationDesRolesSansCriteres(avengers), joueDans(arnold, avengers), joueDans(sharon, avengers).

test8 :- findall((X,Y), joueDans(X,Y),  [ (merryl, sherlock), (arnold, avengers), (sharon, avengers)]).

% Tests pour 'affectationDesRolesCriteres'.
test9b1 :- \+ affectationDesRolesCriteres(coupe,[],_).
test9b2 :- affectationDesRolesCriteres(wind2,[masculin,revenuMin],[maxi, merryl]).
test9b3 :- \+ affectationDesRolesCriteres(coupe,[feminin],_).
test9b4 :- affectationDesRolesCriteres(coupe,[masculin],[maxi]).
test9b5 :- affectationDesRolesCriteres(wind,[masculin,revenuMin],[maxi, merryl]).

% Tests pour 'affectationDesRoles'.
test101 :- \+affectationDesRoles(wind,[masculin,feminin,revenuMin]).
test102 :- \+ affectationDesRoles(wind,[masculin,feminin]).
test103 :- \+ affectationDesRoles(nuit,[masculin,feminin,experienceMin]).
test104 :- \+affectationDesRoles(avengers,[masculin]), findall(X, joueDans(X, avengers), [arnold,sharon]).
test105 :-  affectationDesRoles(wind2,[masculin]), joueDans(merryl,wind2),joueDans(maxi,wind2).
test106 :-  affectationDesRoles(coupe,[]), joueDans(maxi,coupe).

% Tests pour 'distribuerFilm'.
test131 :- \+ distribuerFilm(nuit,10).
test132 :- distribuerFilm(iron,15), findall(X, (cinema(_,_,R), member(X,R)), [ (iron, 0, 15), (iron, 0, 15), (iron, 0, 15), (iron, 0, 15)]).

% Tests pour 'produire'.
test111 :- \+ produire('Fox',wind2).
test112 :- \+produire('Flop Films',nuit).
test113 :- produire('Fox',nuit), film(nuit,_, _, _, 'Fox', _, _, _, 1000), maison('Fox', 998000).

% Tests pour 'plusieursFilms'.
test121 :- plusieursFilms(2,['Streep Meryll','Farfelu Maximo']).
test122 :- plusieursFilms(1,['Schawrznnegger Arnold', 'Streep Meryll', 'Farfelu Maximo', 'Stone Sharon']).

% Tous les tests...
main :- write('Début des 
tests...'), nl, write('======================'), nl, 
test11, write('test11 pass'), nl, 
test21, write('test21 pass'),nl,
test22, write('test22 pass'),nl,
test31, write('test31 pass'),nl,
test32, write('test32 pass'),nl,
test41, write('test41 pass'),nl,
test5a1, write('test5a1 pass'),nl,
test5a2, write('test5a2 pass'),nl,
test5a3, write('test5a3 pass'),nl,
test5b1, write('test5b1 pass'),nl,
test5b2, write('test5b2 pass'),nl,
test5b3, write('test5b3 pass'),nl,
test5b4, write('test5b4 pass'),nl,
test61, write('test61 pass'),nl,
test62, write('test62 pass'),nl,
test63, write('test63 pass'),nl,
test7a1, write('test7a1 pass'),nl,
test7a2, write('test7a2 pass'),nl,
test7a3,write('test7a3 pass'),nl,
test7a4, write('test7a4 pass'),nl,
test7b1, write('test7b1 pass'),nl,
test7b2, write('test7b2 pass'),nl,
test7b3, write('test7b3 pass'),nl,
test7b4, write('test7b4 pass'),nl,
test9a1, write('test9a1 pass'),nl,
test9a2, write('test9a2 pass'),nl,
test9a3, write('test9a3 pass'),nl,
test8, write('test8 pass'),nl,
test9b1, write('test9b1 pass'),nl,
test9b2, write('test9b2 pass'),nl,
test9b3, write('test9b3 pass'),nl,
test9b4, write('test9b4 pass'),nl,
test9b5, write('test9b5 pass'),nl,
test101, write('test101 pass'),nl,
test102, write('test102 pass'),nl,
test103, write('test103 pass'),nl,
test104, write('test104 pass'),nl,
test105, write('test105 pass'),nl,
test106, write('test106 pass'),nl,
test131, write('test131 pass'),nl,
test132,write('test132 pass'),nl,
test111, write('test111 pass'),nl,
test112, write('test112 pass'),nl,
test113, write('test113 pass'),nl,
test121, write('test121 pass'),nl,
test122,write('test122 pass'),nl,
nl, write('Fin des 
tests.'), nl, write('======================').
%sous SWI: ?- qsave_program('testTP2.exe', [goal(main), stand_alone(true)]).
%sur ligne de commande: plcon -o testTP2.exe -c testTP2.pl --goal=main

