%% Busco preferencias

%                 1               2            3        4       5     6       7               8                  9       10   
practicasstr =  ["difusividad" "ferro" "leindenfrost" "peltier" "pid" "piezo" "resistividad" "susceptibilidad" "vacio" "young"];

%preferencias de los grupos
PR=table2struct(readtable('preferencias 2022.xlsx'));
prefstr = [string({PR.p1})' string({PR.p2})' string({PR.p3})' string({PR.p4})' string({PR.p5})' string({PR.p6})'];

prefnum = fp_practicas.prefstr2prefnum(practicasstr,prefstr);
mystr = fp_practicas.practnum2str(practicasstr,prefnum );

pref = prefnum;
practicas = 1:length(practicasstr);

% pref = prefstr;
% practicas = practicasstr;


% mejorsol = solgabi;
mejorsol = fp_practicas.generosolrandom(practicas); 
mejorpunt= fp_practicas.puntaje(pref,mejorsol);
cont = 0;
tic

if exist('soluciones.mat','file')
    load soluciones
    for indsol=1:length(sols)%recalculo puntajes
        sols(indsol).puntaje = fp_practicas.puntaje(pref,sols(indsol).sol);
    end
    mejorsol = sols(1).sol;
    mejorpunt = sols(1).puntaje;
    fprintf("Grosooooooooo %d %d \n",0,mejorpunt)
else
    sols=struct([]);
    sols(1).sol = mejorsol;
    sols(1).puntaje = mejorpunt;
    sols(1).cont = 0;
end

while 1    

    sol = fp_practicas.construyosol(pref,practicas);
    punt= fp_practicas.puntaje(pref,sol); %mido su puntaje         
   
    if punt<3100160%mejorpunt%300071 % %mejorpunt
        fprintf("Grosooooooooo %d %d \n",cont,punt)
        
        mejorsol = sol;
        mejorpunt= punt;
        
        sols(end+1).sol = mejorsol;
        sols(end).solstr = fp_practicas.practnum2str(practicasstr,sol);
        sols(end).puntaje = mejorpunt;
        sols(end).cont = cont;
        sols(end).rank = fp_practicas.armorank(mejorsol,pref);
                
        %me quedo con uno solo, si hay repetidos
        for inds=1:length(sols)
            sols(inds).id = num2str(sols(inds).rank(:)');
        end
        [~,ia,ic]=unique({sols.id});
        sols = sols(ia);

        % ordeno para quedarme con la de menos puntaje
        [~,indsorted]=sort([sols.puntaje]);
        sols = sols(indsorted);        
        
        disp("Me falta intercambiar las columnas para que la primera tenga las condiciones de las charlas de tecnicas")
                
        fname = sprintf("soluciones");
        save(fname,'sols')
    end
    cont = cont+1;
    if mod(cont,10000)==0
        fprintf("%d %2.2fs\n",cont,toc)
    end
    
    if punt<0 % solo para que no me moleste el warning de matlab
        break
    end
end

%% busco cu�les de las permutaciones son v�lidas. Un 63%. No pierdo tanto tiempo, lo dejo que intente todos.
practicas = ["nuclear" "conteo" "caminata" "pinzas" "foto" "glow" "esp laser" "esp"];
practicas =  ["difusividad"    "ferro"    "leindenfrost"    "peltier"    "pid"    "piezo"    "resistividad" "susceptibilidad"    "vacio"    "young"];
myperms = perms(1:8);

valid = nan(length(myperms),1);
for i=1:length(myperms)
    sol1g = practicas(myperms(i,1:3));
    valid(i) = check_sol_1_group(sol1g );
end
sum(valid)/length(valid)

%%
load soluciones

[sols(1:7).puntaje]

sols(3).sol
for i=1:5
    [ sols(i).rank sum(sols(i).rank,2)]
end
