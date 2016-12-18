% joueDans est un prédicat dynamique dont les clauses sont créées à mesure que les rôles sont attribués aux acteurs.
% format: joueDanns(identifianfActeur, identifiantFilm)
% Exemple: joueDans(merryl, wind2).
:- dynamic joueDans/2. %prédicat dynamique d'ariété 2 

% les réalisateurs
% format: realisateur(Identifiant, Nom, Adresse)
realisateur(woody, 'Allen Woody', 'New York, New York').
realisateur(arcan, 'Arcan Denis', 'Montréal, Québec').
realisateur(villeneuve, 'Denis Villeneuve', 'Montréal, Québec').
realisateur(silver, 'Guy Silver', 'Boston, MA').
realisateur(joss, 'Joss Marvel', 'Hollywood, CA').
realisateur(jon, 'Jon Marvel', 'Los Angeles, CA').

% les acteurs	
% format: acteur(Nom,Sexe,RevenuMin,DateDebut,Restriction).						 
acteur('Schawrznnegger Arnold',ma,1000,date(1978,4,1),arnold).
acteur('Streep Meryll',fe,1500,date(1984,9,1),merryl).
acteur('Farfelu Maximo',ma,1, date(2015,1,1),maxi).
acteur('Roberts Julia',fe,2000,date(1985,4,12),julia).
acteur('Reno Jean',ma,100, date(1975,8,15),reno).
acteur('Stone Sharon',fe,500,date(1990,8,15),sharon).
acteur('Downey Jr Robert',ma,4500,date(1997,10,1),robert).

% les restrictions des acteurs
% format: identifiantActeurConcern(predicatFilm).
arnold(film(F,_,_,_,_,_,_,_,_)) :- film(F,_,_,Realisateur,Producteur,Cout,_,_,_),
                         \+ Realisateur = pasDeRealisateur,
                         \+ Producteur = pasDeProducteur, Cout > 100000.
merryl(film(F,_,_,_,_,_,_,_,_)) :- film(F,_,Type,Realisateur,_,_,Duree,NombreActeurs,_),
                         \+ Type = action, \+ Realisateur = pasDeRealisateur,
                         (Duree > 90; NombreActeurs = 2).
maxi(film(F,_,_,_,_,_,_,_,_)) :- film(F,_,_,Realisateur,_,_,_,_,_),
                                 realisateur(Realisateur,_,Adr), (Realisateur = woody; sub_string(Adr, _, _, _, 'Québec')).
julia(film(F,_,_,_,_,_,_,_,_)) :- film(F,_,Type,_,_,_,_,_,Budget), (Type = drame; Type = humour),Budget < 4000.
reno(film(F,_,_,_,_,_,_,_,_)) :- film(F,_,drame,_,_,_,_,_,_).
sharon(film(F,_,_,_,_,_,_,_,_)) :- film(F,Titre,_,Realisateur,_,_,_,_,_),
                             name(Titre,Tl),length(Tl,Lt), Lt> 4, Lt<15, \+ Realisateur = woody.
robert(film(F,_,_,_,_,_,_,_,_)) :- film(F,_,action,_,_,_,_,_,_).


% les producteurs
% format: maison(Nom, Budget)
% dymanique car le budget changera après une décision de production.
:- dynamic maison/2.
maison('Flash Films', 100000).
maison('United Artists',1000000).
maison('Flop Films', 50).
maison('Black Label Media',1000000).
maison('Fox',1000000).
maison('Vivendi',1000000).

% les films
% format: film(IdFilm,TitreFilm,TypeFilm,RealisateurFilm,ProducteurFilm,CoutFilm,DureeFilm,NbaFilm,BudgetFilm)
% dymanique car plusieurs aspects du film peuvent changés. Exemples: RealisateurFilm, ProducteurFilm, BudgetFilm, CoutFilm
:- dynamic film/9.
film(sica, 'Sicaire', action, villeneuve, 'Black Label Media', 100000, 95, 150, 60000).
film(nuit, 'Une nuit a Casablanca', humour, woody, pasDeProducteur,2000,100,3,1000).
film(coupe, 'Coup de coupe !', horreur, arcan,'Flop Films', 45000,45,1,10000).
film(wind, 'Gone with the wind !', drame, woody, 'Flash Films',450,120,4,100).
film(wind2, 'Gone with the wind, the sequell !','drame',woody,'Flash Films',4500,120,2,3999). 
film(avengers, 'The Avengers', action, joss,'Fox', 200000, 143, 2, 110000 ).
film(iron, 'Iron Man', action, jon, 'Vivendi', 16000, 126, 3, 100000).
film(sherlock, 'Sherlock Holmes', policier, silver, 'Vivendi', 90000, 128, 1, 90000 ).
	
/* les cinemas
format: cinema/3(identifiant, addresse, repertoireDesFilms)
        repertoireDesFilms est une liste de triplets de forme (identifiantFilm, NbreEntrees, PrixEntree).
		Exemple: cinema(cineparc, 'Montreal Quebec', [(sherlock, 25500, 8), (iron, 36300, 11), (avengers, 40020, 10)]).
*/
:- dynamic cinema/3.
cinema(starcite, 'Montreal Quebec', []).
cinema(cineparc, 'Montreal Quebec', []).
cinema(theatreoutremont, 'laval', []).
cinema(centrephi, 'Longueuil', []).

/* les critères de rôle pour un acteur...
format: critere/2(IdentifiantDuCritere, But) suivi d'une définion, soit la condition dans lesquelles But est prouvé.
        Exemple de but: acteur(_,Sexe,_,_,IdAct)
		Exemple de critère: critere(masculin,(acteur(_,Sexe,_,_,IdAct))) :- Sexe = ma, acteur(_,Sexe,_,_,IdAct).
*/
critere(masculin,(acteur(_,Sexe,_,_,IdAct))) :- Sexe = ma, acteur(_,Sexe,_,_,IdAct).
critere(feminin,(acteur(_,Sexe,_,_,IdAct))):- Sexe = fe, acteur(_,Sexe,_,_,IdAct).
critere(experienceMin,(acteur(NA,_,_,_,IdAct))) :- acteur(NA,_,_,date(Adebut,_,_),IdAct), (2016-Adebut) > 5. %acteurs ayant au moins 5 ans d'expérience au 1er janvier 2015
critere(experienceMax,(acteur(NA,_,_,_,IdAct))) :- acteur(NA,_,_,date(Adebut,_,_),IdAct), (2016-Adebut) =< 25. %acteurs avec au plus 25 ans d'expérience au 1er janvier 2015
critere(revenuMin,(acteur(NA,_,R,_,IdAct))) :- acteur(NA,_,R,_,IdAct), R > 1000. % acteurs avec au moins 1000$ pour revenuMin 
critere(revenuMax,(acteur(NA,_,R,_,IdAct))) :- acteur(NA,_,R,_,IdAct), R >= 10000. %acteurs avec au moins 10000$ pour revenuMin
