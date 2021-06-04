function normData = normalised101(data,events)
% fonction permettant de normaliser une mesure sur un cycle de marche de 100%
% events(1) = Foot Strike 1 ; events(2) = Foot Strike 2 (en secondes)
% Version avec events en frames
% data = données sur toute la mesure

%samples de Foot Strike, valeurs non arrondies
FS1 = events(1);
FS2 = events(2);

%incrément en sec de 1% (pour 101 valeurs) => calcul du sample non arrondi
%FS1 = 0%  ;  FS2 = 100%
inc = (FS2 - FS1) / 100;

% Interpolation linéraire
%floor : valeur entière inférieure ; ceil : valeur entière supérieure
for i=1:101
    Sp = FS1 + (i-1) * inc; %sample non arrondi
    flSp = Sp - floor(Sp); %complément de la partie entière inférieure
    normData(i,:) = data(floor(Sp),:) + ( data(ceil(Sp),:) - data(floor(Sp),:) ) * flSp;
end
