function normData = normalised101(data,events)
% fonction permettant de normaliser une mesure sur un cycle de marche de 100%
% events(1) = Foot Strike 1 ; events(2) = Foot Strike 2 (en secondes)
% Version avec events en frames
% data = donn�es sur toute la mesure

%samples de Foot Strike, valeurs non arrondies
FS1 = events(1);
FS2 = events(2);

%incr�ment en sec de 1% (pour 101 valeurs) => calcul du sample non arrondi
%FS1 = 0%  ;  FS2 = 100%
inc = (FS2 - FS1) / 100;

% Interpolation lin�raire
%floor : valeur enti�re inf�rieure ; ceil : valeur enti�re sup�rieure
for i=1:101
    Sp = FS1 + (i-1) * inc; %sample non arrondi
    flSp = Sp - floor(Sp); %compl�ment de la partie enti�re inf�rieure
    normData(i,:) = data(floor(Sp),:) + ( data(ceil(Sp),:) - data(floor(Sp),:) ) * flSp;
end
