%% Busco preferencias

%preferencias de los grupos
PR=table2struct(readtable('preferencias.xlsx'));
pref = [string({PR.p1})' string({PR.p2})' string({PR.p3})' string({PR.p4})' string({PR.p5})' string({PR.p6})'];

%Una buena  solucion de Gabi P
SOL=table2struct(readtable('solmanual.xlsx'));
solgabi = [string({SOL.p1})' string({SOL.p2})' string({SOL.p3})'];
punt= puntaje(pref,solgabi);
fprintf("Puntaje de la sol de Gabi: %d !!\n",punt)

% mejorsol = solgabi;
mejorsol = generosolrandom(); 
mejorpunt= puntaje(pref,mejorsol);
cont = 0;
tic

if exist('soluciones.mat','file')
    load soluciones
else
    sols=struct([]);
    sols(1).sol = mejorsol;
    sols(1).puntaje = mejorpunt;
    sols(1).cont = 0;
end

while 1

    %     if rand>0.5
%         cant = randi(3);
%         sol = generopermutacion(mejorsol ,cant);
%         punt= puntaje(pref,sol); %mido su puntaje         
%     else
%         sol = generosolrandom(); %genero una solucion random
%         punt= puntaje(pref,sol); %mido su puntaje         
%         if punt<150
%             disp(punt)
%             disp(sol)
%         end
%     end

    sol = construyosol(pref);
    punt= puntaje(pref,sol); %mido su puntaje         
   
    if punt<72
        fprintf("Grosooooooooo %d %d \n",cont,punt)
        
        mejorsol = sol;
        mejorpunt= punt;
        
        sols(end+1).sol = mejorsol;
        sols(end).puntaje = mejorpunt;
        sols(end).cont = cont;
        sols(end).rank = armorank(mejorsol,pref);
                
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

%% busco cuáles de las permutaciones son válidas. Un 63%. No pierdo tanto tiempo, lo dejo que intente todos.
practicas = ["nuclear" "conteo" "caminata" "pinzas" "foto" "glow" "esp laser" "esp"];

myperms = perms(1:8);

valid = nan(length(myperms),1);
for i=1:length(myperms)
    sol1g = practicas(myperms(i,1:3));
    valid(i) = check_sol_1_group(sol1g );
end
sum(valid)/length(valid)

%%
load soluciones

%me quedo con uno solo, si hay repetidos
for inds=1:length(sols)
    sols(inds).id = num2str(sols(inds).rank(:)');
end
[~,ia,ic]=unique({sols.id});
sols = sols(ia);

[~,indsorted]=sort([sols.puntaje]);
sols = sols(indsorted);

[sols(1:15).puntaje]

sols(2).rank
sols(3).rank
