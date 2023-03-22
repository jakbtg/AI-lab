% Cripto aritmetica
%   S E N D +
%   M O R E =
% -----------
% M O N E Y

cifra(0..9).
lettera(s;e;n;d;m;o;r;y).

% ad ogni lettera associo una e una sola cifra
1 {assegna(L, C) : cifra(C)} 1 :- lettera(L).
% ad ogni cifra associo al più una lettera (perchè ci sono 10 cifre e 8 lettere)
{assegna(L, C) : lettera(L)} 1 :- cifra(C).

sommaok :- cifra(S;E;N;D;M;O;R;Y),
            assegna(s, S), assegna(e, E), assegna(n, N), assegna(d, D),
            assegna(m, M), assegna(o, O), assegna(r, R), assegna(y, Y),
            S*1000 + E*100 + N*10 + D + M*1000 + O*100 + R*10 + E == M*10000 + O*1000 + N*100 + E*10 + Y,
            S > 0, M > 0.

:- not sommaok.

#show assegna/2.

% Risultato in circa 3 minuti e 20 secondi:
% assegna(o,0) assegna(m,1) assegna(s,9) assegna(r,8) assegna(n,6) assegna(e,5) assegna(d,7) assegna(y,2)
% s = 9, e = 5, n = 6, d = 7, m = 1, o = 0, r = 8, y = 2
% 9567 + 1085 = 10652