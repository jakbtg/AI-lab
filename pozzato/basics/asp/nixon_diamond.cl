pacifist(X) :- quaker(X), not -pacifist(X).
-pacifist(X) :- republican(X), not pacifist(X).
republican(nixon).
quaker(nixon).

% in questo modo ottengo due modelli di risultati possibili:
% 1) quaker(nixon), republican(nixon), pacifist(nixon)
% 2) quaker(nixon), republican(nixon), -pacifist(nixon)
% in questo caso ci sono due forme di ragionamento:
% - scettico: credo solo ciò che è vero in tutti i modelli
% - credulone: credo a tutto, come se ci fossero giorni in cui nixon è pacifista e giorni in cui non lo è 