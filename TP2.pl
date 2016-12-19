%Nabih Hajjar - HAJN07129300
%Jean-Christophe Decary - DEC20119200

:- use_module(library(lists)).
:- ['donneesTp2.pl'].

/* 0) Le predicat listeFilms(L) lie L à la liste (comportant les identifiants) de tous les films. 
Exemple: 
        ?- listeFilms(ListeDesFilms).
        ListeDesFilms = [sica, nuit, coupe, wind, avengers, iron, sherlock, wind2].
*/

listeFilms(L) :- findall(X, film(X,_,_,_,_,_,_,_,_), L).

/* 
1) 0.25pt. Le predicat listeActeurs(L) unifie L à la liste (comportant les identifiants) de tous les acteurs. 
*/

listeActeurs(L):- findall(X, acteur(_,_,_,_,X),L).


/* 2) 0.25pt. Le predicat experience(IdAct,Annee,Ne) unifie Ne au nombre d'années d'expérience à l'année Annee, de l'acteur dont l"identifiant est IdAct. 
precondition: Annee doit être définie. 
*/ 

year(Date, Value) :-
	date_time_stamp(Date, Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(year, DateTime, Value).
	
experience(_,Annee,_) :- var(Annee),!,fail.
experience(IdAct,Annee,Ne) :- 	acteur(_,_,_,DateDebut,IdAct),
								year(DateDebut,X),
								Annee < X,
								Ne is 0,!.	
experience(IdAct,Annee,Ne) :- 	acteur(_,_,_,DateDebut,IdAct),
								year(DateDebut,X),
								Annee >= X,
								Ne is Annee - X,!.
								
/* 
3) 0.75pt. Le predicat filtreCritere unifie ActId à l'identifiant du premier acteur qui verifie tous les criteres de Lc. 
precondition: Lc doit etre defini. */

filtreCritere([],_).
filtreCritere([C1 | Criteres],IdActeur):- is_he_valid(C1,IdActeur), filtreCritere(Criteres, IdActeur),!.
filtreCritere(Critere,IdActeur) :- is_he_valid(Critere,IdActeur),!.

who_is(_,[],[]).
who_is(Criteres,[Acteur|Acteurs],[Acteur|Results]):- filtreCritere(Criteres,Acteur),who_is(Criteres,Acteurs,Results),!.
who_is(Criteres,[_|Acteurs],Results):-who_is(Criteres,Acteurs,Results),!.

is_he_valid(Critere,IdActeur):-critere(Critere,acteur(_,_,_,_,IdActeur)).

/* 
4) 0.75pt. Le predicat totalSalaireMin(LActeur,Total) calcule la somme des salaires minimuns exigés par les acteurs dont la liste (des identifiants) est spécifiée. 
*/

totalSalaireMin([],0).
totalSalaireMin([Acteur|Acteurs], Total) :- acteur(_,_,R,_,Acteur),totalSalaireMin(Acteurs,SubTotal), Total is SubTotal + R.

/* 
5a) 0.75pt. Le prédicat selectionActeursCriteres(Lcriteres,Lacteurs) unifie Lacteurs à la liste formée des identifiants des acteurs qui satisfont tous les critères de Lcriteres.
precondition: la liste de criteres doit être définie. 
*/

selectionActeursCriteres(Criteres,_):- var(Criteres),!,fail.
selectionActeursCriteres(Criteres,Results):- listeActeurs(Acteurs),who_is(Criteres,Acteurs,Results).

/* 
5b) 1pt. Le prédicat selectionActeursCriteresNouvelle(Lcriteres,Lacteurs,LChoisis) unifie LChoisis à la liste formée des identifiants des acteurs sélectionnés parmi les acteurs dans Lacteurs selon 
le principe suivant (jusqu'à concurrence de N acteurs, N correspondant au nombre de critères dans LCriteres: le premier acteur qui satisfait le premier critere de Lcriteres, le premier acteur 
non encore sélectionné et qui satisfait le deuxième critère etc.	
precondition: la liste de criteres (Lcriteres) et la liste des acteurs contenant leurs idenfiants (Lacteurs) doivent être définies. 
*/

selectionActeursCriteresNouvelle([],_,_).
selectionActeursCriteresNouvelle(_,[],_).
selectionActeursCriteresNouvelle([C|Lcriteres], Lacteurs, LChoisis) :- selectionActeur(C, Lacteurs, X), faitPartie(X, L), append(L, X, LChoisis), selectionActeursCriteresNouvelle(Lcriteres,Lacteurs,L).

selectionActeur(_,[],_).
selectionActeur(X,[Y|YS], Y) :- filtreCritere([X], Y); selectionActeur(X, YS, Z), Z = Y.
selectionActeur(X, [_|YS], Z) :- selectionActeur(X, YS, Z).

faitPartie(_,[]).
faitPartie(X,[X|_]) :- !, false.
faitPartie(X, [_|XS]) :- !, faitPartie(X, XS).

/* 
6) 1pt. Le prédicat filmsAdmissibles(ActId,LFilms) unifie LIdFilms à la liste des films (identifiants) satisfaisant les restrictions de l'acteur ActId. 
*/

filmsAdmissibles(ActId,LFilms) :- findall(IdFilm, call(ActId, film(IdFilm,_,_,_,_,_,_,_,_)) ,LFilmsTemp), sansDoublons(LFilmsTemp, LFilms).
sansDoublons(L, R) :- list_to_set(L, R).

/* 
7a) 1pt. Le prédicat selectionActeursFilm(IdFilm,Lacteurs) unifie Lacteurs à la liste formée des identifiants d'acteurs pour lesquels le film de d'identifiant IdFilm satisfait les restrictions.
préconditions: IdFilm doit être défini 
*/

selectionActeursFilm(IdFilm,Lacteurs):- listeActeurs(L), include(estAdmissible(IdFilm),L, Lacteurs).
estAdmissible(F,A) :- call(A, film(F,_,_,_,_,_,_,_,_)).

/* 
7b) 1pt. Le prédicat selectionNActeursFilm2ActeursFilm2(IdFilm,Lacteurs) unifie Lacteurs à la liste formée des identifiants d'acteurs pour lesquels le film de d'identifiant IdFilm satisfait les restrictions.
          Si le nombre total des acteurs qualifiés est inférieur au nombre d'acteurs du film, la liste retournée (Lacteurs) devra contenir l'atome pasAssezDacteur.
préconditions: IdFilm doit être défini 
*/

selectionNActeursFilm2(IdFilm,Lacteurs) :- selectionActeursFilm(IdFilm,LTemp), length(LTemp, NbAct), film(IdFilm,_,_,_,_,_,_,NbActRequis,_), NbAct >= NbActRequis, !,prendN(NbActRequis, LTemp, Lacteurs).
selectionNActeursFilm2(_,[pasAssezDacteur]).

prendN(N, _, XS) :- N =< 0, !, N =:= 0, XS = [].
prendN(_, [], []).
prendN(N, [X|XS], [X|YS]) :- M is N-1, prendN(M, XS, YS).

/* 
8) 1pt. Le prédicat acteurJoueDansFilm(Lacteurs, IdFilm) ajoute dans la base de faits tous les acteurs (identifiants) jouant dans le film de titre spécifié (IdFilm) 
*/

acteurJoueDansFilm([],_).
acteurJoueDansFilm([A|Lacteurs],IdFilm) :- assert(joueDans(A,IdFilm)), acteurJoueDansFilm(Lacteurs,IdFilm).

/* 
9a) 1pt. Le prédicat affectationDesRolesSansCriteres(IdFilm) a pour but de distribuer les rôles à une liste d'acteurs pouvant jouer dans le film identifié par IdFilm (puisque
le film satisfait à ses restrictions). Les N premiers acteurs dont les restructions sont respectées par le film (N correspondant au nombre de rôles du film), sont ajoutés dans
dans la base de faits par des prédicats "joueDans".
Ce prédicat modifie le fait film correspondant à IdFilm par destruction et remplacement par un nouveau fait film égal à l'ancien mais dont le budget a été remplacé par la somme des salaires minimums des acteurs choisis et son coût a été diminué de la différence entre le budget initial et le nouveau budget.
Ce prédicat complète la base de faits joueDans(IdActeur, IdFilm) en fonction des N acteurs sélectionnés et dont la somme des salaires minimums est inférieure ou égale au budget (salarial) du film. Le prédicat doit envisager toutes les combinaisons possibles des N acteurs tirés de la base de faits acteur 
Le prédicat échoue et ne modifie rien si une des conditions suivantes est vérifiée (dans l'ordre):
  0) les rôles ont déjà été distribués por ce film
  1) le réalisateur du film est pasDeRealisateur
  2) le producteur du film est pasDeProducteur
  3) s'il n'y a pas assez d'acteurs,
  4) si le budget du film est insuffisant.
précondition: L'identifiant du film doit être défini.
*/

affectationDesRolesSansCriteres(IdFilm) :- not(atom(IdFilm)), !, fail.
affectationDesRolesSansCriteres(IdFilm) :- joueDans(_, IdFilm), !, fail.
affectationDesRolesSansCriteres(IdFilm) :- validerFilm(IdFilm), !, fail.
affectationDesRolesSansCriteres(IdFilm) :- selectionNActeursFilm2(IdFilm, L), not(L = pasAssezDacteur), affecterRole(IdFilm, L), !.

validerFilm(IdFilm) :- film(IdFilm,_,_,R,P,_,_,Na,_), R = pasDeRealisateur, P = pasDeProducteur, listeActeurs(L), length(L, Ll), Na > Ll.

affecterRole(_, La) :- La = pasAssezDacteur, !, fail.
affecterRole(IdFilm, La) :- film(IdFilm,_,_,_,_,_,_,_,B), totalSalaireMin(La, Total), Total =< B, acteurJoueDansFilm(La, IdFilm), modifierBudgetFilm(IdFilm,Total).

modifierBudgetFilm(IdFilm, Salaires) :- film(IdFilm,Titre,Type,Realisateur,Producteur,Cout,Duree,Nba,Budget), NBudget = Salaires, NCout = Budget - NBudget, retract(film(IdFilm,Titre,Type,Realisateur,Producteur,Cout,Duree,Nba,Budget)), assert(film(IdFilm,Titre,Type,Realisateur,Producteur,NCout,Duree,Nba,NBudget)).

/*
9b) 1pt. Le prédicat affectationDesRolesCriteres(IdFilm,Lcriteres,LChoisis) unifie LChoisis à la liste d'acteurs satisfaisant aux critères de sélection du film, Ce film doit bien entendu satisfaire aux restrictions de 
chacun des acteurs candidat. 
Dans ce prédicat, IdFilm est un identifiant de film et Lcriteres est une liste de critères. 
Pour la satisfaction des critère, on retiendra toujours le premier acteur satisfaisant au 1er critère et on recommensera avec le même principe pour les autres acteurs et les critères restants.
Contrairement au prédicat affectationDesRolesSansCriteres défini à la question 9a, affectationDesRolesCriteres ne modifie pas ba base de faits et se contente de récupérer la liste des acteurs sélectionnés dans Lchoisis.
Le prédicat échoue
  1) si la liste des critère est vide,
  2) si le réalisateur du film est pasDeRealisateur,
  3) si le producteur du film est pasDeProducteur,
  4) s'il n'y a pas assez d'acteurs.
précondition: L'identifiant du film et la liste de critères doivent être définis.
Attention: Il est possible qu'il y ait moins de critère que d'acteurs admissibles. Dans ce cas, la liste des acteurs sélectionnés ne peut dépasser le nombre de critères dans Lcriteres.
           Le nombre maximum d'acteurs choisis est donc égal à la taille de la liste Lcriteres.
*/

affectationDesRolesCriteres(_,[],_) :- !,fail.
affectationDesRolesCriteres(IdFilm,_,_) :- film(IdFilm,_,_,Real,_,_,_,_,_), Real = pasDeRealisateur,!, fail.
affectationDesRolesCriteres(IdFilm,_,_) :- film(IdFilm,_,_,_,Prod,_,_,_,_), Prod = pasDeProducteur,!, fail.
affectationDesRolesCriteres(IdFilm,_,_) :- selectionNActeursFilm2(IdFilm,Lacteurs), Lacteurs = [pasAssezDacteur], !,fail.
affectationDesRolesCriteres(IdFilm,Lcriteres,LChoisis) :- selectionNActeursFilm2(IdFilm,Lacteurs), selectionActeursCriteresNouvelle(Lcriteres,Lacteurs, LChoisis),LChoisis = [], !,fail.
affectationDesRolesCriteres(IdFilm,Lcriteres,LChoisis) :- selectionNActeursFilm2(IdFilm,Lacteurs), selectionActeursCriteresNouvelle(Lcriteres,Lacteurs, LChoisis).

/*
10) 2pts. Le prédicat affectationDesRoles(IdFilm, Lcriteres) a pour but de distribuer les rôles à une liste d'acteurs pouvant jouer dans le film et satisfaisant
aux critères de sélection du film en ajoutant les acteurs choisis dans la base de faits "joueDans".
Dans ce prédicat, IdFilm est un identifiant de film et Lcriteres est une liste de critères. 
Pour la satisfaction des critère, on retiendra toujours le premier acteur satisfaisant au 1er critère et on recommensera avec le même principe pour les autres acteurs et les critères restants.
Ce prédicat modifie le fait film correspondant à IdFilm par destruction et remplacement par un nouveau fait film égal à l'ancien mais dont le budget a été remplacé par la somme des salaires minimums des acteurs choisis et son coût a été diminué de la différence entre le budget initial et le nouveau budget.
Ce prédicat complète la base de faits joueDans(IdActeurActeur, IdFilm) en fonction des n acteurs sélectionnés (où n est le nombre de rôles du film) qui satisfont tous les critères de Lcriteres, pour lesquels le film satisfait leur restrictions et dont la somme des salaires minimums est inférieure ou égale au budget du film. 
Le prédicat doit envisager toutes les combinaisons possibles des n acteurs tirés de la base de faits acteur.
Le prédicat échoue et ne modifie rien 
  1) si le réalisateur du film est pasDeRealisateur,
  2) si le producteur du film est pasDeProducteur,
  3) s'il n'y a pas assez d'acteurs,
  4) si le budget du film est insuffisant pour financer le salaire minimum de tous acteurs sélectionnés.
précondition: L'identifiant du film et la liste de critères doivent être définis.
Attention: 
1) Il est possible qu'il y ait moins de critère que d'acteurs admissibles. Dans ce cas, la liste des acteurs sélectionnés doit être complétée (si possible et à concurrence de nombre de rôles) selon le principe du prédicat affectationDesRolesSansCriteres(IdFilm) de la question 9a.
2) Si la liste Lcriteres est vide, c'est aussi le principe de affectationDesRolesSansCriteres(IdFilm) de la question 9a qui s'applique.
*/

affectationDesRoles(IdFilm, []) :- affectationDesRolesSansCriteres(IdFilm), !.
affectationDesRoles(IdFilm, LCriteres) :- affectationDesRolesCriteres(IdFilm, LCriteres, LChoisis), afftecterRole(IdFilm, LChoisis), !.
affectationDesRoles(IdFilm, _) :- affectationDesRolesSansCriteres(IdFilm), !, fail.

/* 11) 1,25 pts. Le prédicat produire(NomMaison,IdFilm) vérifie si la maison peut produire le film identifié. Il vérifie si le budget de la maison 
est supérieur au cout du film, si le réalisateur n'est pas pasDeRealisateur, et si le producteur n'est pas pasDeProducteur. Si la production est possible,
 on diminue le budget de la maison par le coût du film et on remplace le fait 'film' par un nouveau film égal à l'ancien sauf que la composante producteur 
 est égale à NomMaison. 
 Précondition: le nom de la maison et l'identifiant du film doivent être connus. Le prédicat doit échoué si la maison ne peut pas produire le film. 
*/

produire(NomMaison,IdFilm):- film(IdFilm,Titre,Type,Realisateur,Producteur,Cout,Duree,NActeur,Budget),
                                 Producteur == 'pasDeProducteur',
                                 realisateur(Realisateur,_,_),
                                 maison(NomMaison,BudgetMaison),
                                 BudgetMaison >= Budget,!,
                                 NouveauBudget is BudgetMaison-Cout,
                                 retract(maison(NomMaison,_)),
                                 assert(maison(NomMaison,NouveauBudget)),
                                 retract(film(Id,Titre,Type,Realisateur,Producteur,Cout,Duree,NActeur,Budget)),
                                 assert(film(Id,Titre,Type,Realisateur,NomMaison,Cout,Duree,NActeur,Budget)).
							 
/* 12) 0.75pt. Le prédicat plusieursFilms(N,Lacteurs) unifie Acteurs à la liste des acteurs (comportant leurs NOMS), qui jouent dans au moins N films.
N doit être lié à une valeur au moment de la requête de résolution du but 
*/

%plusieursFilms(_ , []).
%plusieursFilms(N,[Acteur | Acteurs]):- nombreDeFilm(Acteur,N) , plusieursFilms(N,Acteurs).

%nombreDeFilm(ActeurName,N):- acteur(ActeurName,_,_,_,ActeurId),findall(Y, joueDans(ActeurId,Y),L), length(L,N).



plusieursFilms(N,Lacteurs) :- listeActeurs(L), plusieursFilms2(N,L,Lacteurs).
plusieursFilms2(_,[],_).
plusieursFilms2(N,[_|XS],Lacteurs) :- findall(X, joueDans(X,Film), L),
                                        length(L,Length),
                                        Length >= N,
                                        append(N,Lacteurs,Lacteurs),
                                        plusieursFilms2(N,XS,Lacteurs).
plusieursFilms2(N,[_|XS],Lacteurs) :- plusieursFilms2(N,XS,Lacteurs).


/* 13) 1.25pt. Les films réalisés et produits doivent maintenant être distribués dans les cinémas. On vous demande définir le prédicat distribuerFilm(IdFilm,PrixEntree) qui envoie le film identifié par IdFilm à tous les cinémas en spécifiant le prix d'entrée suggéré. 
Ce prédicat doit modifier la base de connaissances en ajoutant le triplet  (IdFilm,0,PrixEntree) dans le répertoire de chacun des cinémas déjà existants.
 */

 listeCinemas(L) :- findall(X, cinema(X,_,_), L).
 distribuerFilm(IdFilm,_):- film(IdFilm,_,_,_,Prod,_,_,_,_), Prod = pasDeProducteur,!, fail.
 distribuerFilm(IdFilm, PrixEntree) :- listeCinemas(L), distribuerFilm(IdFilm, PrixEntree, L). 
 distribuerFilm(_,_,[]) :- !.
 distribuerFilm(IdFilm, PrixEntree, [C|CS]) :- ajouterFilm(C, IdFilm, PrixEntree), distribuerFilm(IdFilm, PrixEntree, CS).
 ajouterFilm(IdCinema, IdFilm, PrixEntree) :- cinema(IdCinema, N, LFilms), retract(cinema(IdCinema, N, LFilms)), append(LFilms, [(IdFilm, 0, PrixEntree)], LFilms2), assert(cinema(IdCinema, N, LFilms2)).


