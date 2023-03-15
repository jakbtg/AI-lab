% ! : predicato cut (predicato come member, gatto, etc), è sempre vero.
% il cut ha un side effect: tutte le scelte fatte fino a quel punto vengono considerate definitive,
% ovvero vengono buttati via tutti i punti di backtracking precedenti.
% data una lista voglio contare quanti sono gli elementi positivi.
contaPositivi([],0).
contaPositivi([Head|Tail], Tot) :- 
    Head > 0,
    !, % cut: da qui vengono tagliate tutte le altre strade aperte
    % ovvero non passerà per il secondo caso di contaPositivi
    % e nemmeno per atre instanzazioni di Head (o altre variabili coinvolte)
    % influisce comunque solo sulle scelte già fatte, non su quelle future
    % se ci fossero altre variabili o altre alternative quelle continueranno ad esserci
    contaPositivi(Tail, N), 
    Tot is N + 1.
% si applica il cut perché abbiamo visto che passare da questo caso qui lascerebbe aperte strade sbagliate
contaPositivi([_|Tail], Tot) :- contaPositivi(Tail, Tot).