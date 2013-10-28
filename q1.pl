% Print the input list of atoms, with a space printed between each atom 
% and qutotaion marks at the start and end
printSentence([W | Rest]) :- write('"'), write(W), printSentence_(Rest), !, write('"'), nl, nl.

printSentence_([]).
printSentence_([qm]) :- write('?').
printSentence_([W | Rest]) :- write(' '), write(W), printSentence_(Rest). 


% Every pronoun in the left argument list will be the inverted pronoun in the right argument list
transform([], []).
transform([P | PRest], [D | DRest])   :- inversePronoun(P, D), !, transform(PRest, DRest).
transform([Eq | PRest], [Eq | DRest]) :- transform(PRest, DRest).

% Facts that define which pronouns to invert
inversePronoun(P, D) :- inversePronoun_(P, D), !.
inversePronoun(P, D) :- inversePronoun_(D, P).

inversePronoun_(i, you).
inversePronoun_(me, you).
inversePronoun_(am, are).
inversePronoun_(my, your).
inversePronoun_(we, you).
inversePronoun_(these, those).
inversePronoun_(myself, yourself).

% Match keywords then give the doctor the appropriate response with a qm appended, or the default one if no keywords are found.
match([Pronoun, know          | Rest], Doctor) :- append([are, Pronoun, sure, Pronoun, know, that    | Rest], [qm], Doctor).
match([Pronoun, feel          | Rest], Doctor) :- append([what, makes, Pronoun, feel                 | Rest], [qm], Doctor).
match([Pronoun, fantasised    | Rest], Doctor) :- append([have, Pronoun, ever, fantasised            | Rest], [before, qm], Doctor).
match([Pronoun, enjoy         | Rest], Doctor) :- append([why, do, Pronoun, enjoy                    | Rest], [qm], Doctor).
match([Pronoun, want          | Rest], Doctor) :- append([have, Pronoun, ever, wanted                | Rest], [before, qm], Doctor).

match(_, [i, cannot, respond, to, that, unfortunately]). 


% First invert all pronouns in the patient's argument, then match keywords and assign the doctor's response.
answer(Patient, Doctor) :- transform(Patient, X), match(X, Doctor), !.

% To be able to construct the patient's statement from the doctor's answer, you must change the order in
% which the arguments of the predicates are written: 

statement(Patient, Doctor) :- transform(Doctor, X), match(Patient, X), !.



printReply(Statement) :- answer(Statement, Reply), printSentence(Reply).

% Testing:
?- write('Tests:'), nl.

% know -----------
?- write('"i know i have super powers."'), nl.
?- printReply([i, know, i, have, super, powers]), nl.

?- write('i know that unicorns exist.'), nl.
?- printReply([i, know, that, unicorns, exist]), nl, nl.
% ----------------


% feel -----------
?- write('i feel that the force is strong with this one'), nl.
?- printReply([i, feel, that, the, force, is, strong, with, this, one]), nl.

?- write('i feel good when eating cereal and programming.'), nl.
?- printReply([i, feel, good, when, eating, cereal, and, programming]), nl, nl.
% ----------------


% fantasised -----
?- write('i fantasised about fast cars.'), nl.
?- printReply([i, fantasised, about, fast, cars]), nl.

?- write('i fantasised that gravity spontaneously changed direction every hour.'), nl.
?- printReply([i, fantasised, that, gravity, spontaneously, changed, direction, every, hour]), nl, nl.
% ----------------


% enjoy ----------
?- write('i enjoy running'), nl.
?- printReply([i, enjoy, running]), nl.

?- write('i enjoy drawing pictures of strange doctors'), nl.
?- printReply([i, enjoy, drawing, pictures, of, strange, doctors]), nl, nl.
% ----------------


% want ----------
?- write('i want to eat cereal'), nl.
?- printReply([i, want, to, eat, cereal]), nl.

?- write('i want to be a jedi master'), nl.
?- printReply([i, want, to, be, a, jedi, master]), nl, nl.
% ----------------


% No response ----
?- write('talk to me!'), nl.
?- printReply([talk, to, me]), nl.

?- write('are you a real doctor?'), nl.
?- printReply([are, you, a, real, doctor]), nl.
% ----------------