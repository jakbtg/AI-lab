% Risolvere un indovinello con ASP
% onesti: dicono sempre il vero
% bugiardi: dicono sempre il falso
% 3 persone: a, b, c
% a dice che sia b che c sono onesti
% b dice che a è bugiardo, ma c è onesto
% c non dice niente
% chi è onesto e chi è bugiardo?

persona(a; b; c).
tipo(onesto; bugiardo).

% ad ogni persona associamo un tipo
1 {ha_tipo(P, T) : tipo(T)} 1 :- persona(P).

% informazioni aggiuntive dell'indovinello:
% a dice che sia b che c sono onesti, ovvero che se b e c sono onesti, allora a dice il vero
dice_il_vero(a) :- ha_tipo(b, onesto), ha_tipo(c, onesto).
% b dice che a è bugiardo, ma c è onesto
dice_il_vero(b) :- ha_tipo(a, bugiardo), ha_tipo(c, onesto).

% Integrity constraints
% P è bugiardo e P dice il vero non possono essere entrambi veri 
:- ha_tipo(P, bugiardo), dice_il_vero(P).
% P è onesto e P not dice il vero non possono essere entrambi veri
:- ha_tipo(P, onesto), not dice_il_vero(P).