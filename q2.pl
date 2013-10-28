% Capture the road data
% ---------------------------
road(wellington, palmerston_north, 143).
road(palmerston_north, wanganui, 74).
road(palmerston_north, napier, 178).
road(palmerston_north, taupo, 259).
road(wanganui, taupo, 231).
road(wanganui, new_plymouth, 163).
road(wanganui, napier, 252).
road(napier, taupo, 147).
road(napier, gisborne, 215).
road(new_plymouth, hamilton, 242).
road(new_plymouth, taupo, 289).
road(taupo, hamilton, 153).
road(taupo, rotorua, 291).
road(taupo, gisborne, 334).
road(gisborne, rotorua, 291).
road(rotorua, hamilton, 109).
road(hamilton, auckland, 126).
% ---------------------------


% Find paths between Start and Finish, by using road/3 to add adjacent towns to the list
% If an adjacent town is a subset of the current path (ie it has already been visited) then
% don't visit it again
route(Finish, Finish, [Finish]).
route(Start, Finish, [Start | Path]) :- road(Start, X, _), route(X, Finish, Path), \+ subset(X, Path).

% Same as route/3, but also adds up the distances along each path. Again, uses road/3 to get adjacent towns and distances to them
% If an adjacent town is a subset of the current path (ie it has already been visited) then
% don't visit it again
route(Finish, Finish, [Finish], 0).
route(Start, Finish, [Start | Path], Dist) :- road(Start, X, D), route(X, Finish, Path, DistP), \+ subset(X, Path), Dist is (DistP + D).


% Use the findall/3 predicate to create a list of tuples where the path from Start to Finish is the in first slot
% of the tuple, and the distance along that path is in the second slot. Use route/4 to calculate the Path and the Distance
choice(Start, Finish, RoutesAndDistances) :- findall((Path, Dist), route(Start, Finish, Path, Dist), RoutesAndDistances).


% Same as the choice/3 predicate, except instead of directly using route/4 to calculate Path and Dist, it calls a sub-predicate
% via_ that uses route/4 and also makes sure that Via is a subset of each Path.
via(Start, Finish, Via, RoutesAndDistances) :- findall((Path, Dist), via_(Start, Finish, Via, Path, Dist), RoutesAndDistances).
via_(Start, Finish, Via, Path, Dist) :- route(Start, Finish, Path, Dist), subset(Via, Path).


% Same as the choice/3 predicate, except instead of directly using route/4 to calculate Path and Dist, it calls a sub-predicate
% avoid_ that uses route/4 and also makes sure that Avoiding is NOT a subset of each Path.
avoiding(Start, Finish, Avoiding, RoutesAndDistances) :- findall((Path, Dist), avoiding_(Start, Finish, Avoiding, Path, Dist), RoutesAndDistances).
avoiding_(Start, Finish, Avoiding, Path, Dist) :- route(Start, Finish, Path, Dist), \+ subset(Avoiding, Path).


% Testing:

?- nl, write('A path from Wellington to Napier, with distance:'), nl.
?- route(wellington, napier, Path, Dist), nl, write(Path), nl, write(Dist), nl, nl, nl.

?- write('List of all paths and their distances from Wellington to Napier:'), nl.
?- choice(wellington, napier, Paths), write(Paths), nl, nl, nl.

?- write('List of all paths and their distances from Wellington to Napier, via Wanganui:'), nl.
?- via(wellington, napier, [wanganui], Paths), nl, write(Paths), nl, nl, nl.

?- write('List of all paths and their distances from Palmerston North to Rotorua, via Taupo and Gisborne:'), nl.
?- via(palmerston_north, rotorua, [taupo, gisborne], Paths), nl, write(Paths), nl, nl, nl.

?- write('List of all paths and their distances from Wellington to Napier, avoiding Wanganui:'), nl.
?- avoiding(wellington, napier, [wanganui], Paths), nl, write(Paths), nl, nl, nl.

?- write('List of all paths and their distances from Palmerston North to Rotorua, avoiding Gisborne:'), nl.
?- avoiding(palmerston_north, rotorua, [gisborne], Paths), nl, write(Paths), nl, nl, nl.