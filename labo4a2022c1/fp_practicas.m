classdef fp_practicas
    methods (Static)

        function sol = ordenoprimerotecnicas(sol)
            %ordeno para que la primera practica quede compatible con las tecnicas
            practP1a =  ["young" "vacio" "pid" "ferro" ];%En P1 tienen que estar estas 4 
            practP1b =  ["peltier" "leidenfrost" ];% y una de estas dos tambien
            practP1a =  [10 9 5 2 ];%En P1 tienen que estar estas 4 
            practP1b =  [4 3 ];% y una de estas dos tambien        
            l1 = length(intersect(sol(:,1),practP1a))==4 & length(intersect(sol(:,1),practP1b))>=1;
            l2 = length(intersect(sol(:,2),practP1a))==4 & length(intersect(sol(:,2),practP1b))>=1;
            l3 = length(intersect(sol(:,3),practP1a))==4 & length(intersect(sol(:,3),practP1b))>=1;
            while 1
                if l1
                    break
                end
                if l2
                    sol(:,[1 2 3])=sol(:,[2 1 3]);
                    break
                end
                if l3
                    sol(:,[1 2 3])=sol(:,[3 1 2]);
                    break
                end
                break
            end                
        end
        function prefnum = prefstr2prefnum(practicas,pref)
            prefnum = nan(size(pref));
            for i=1:numel(pref)
                [tf,loc]=ismember(pref(i),practicas);
                if tf
                    prefnum(i) = loc;
                else
                    prefnum(i) = nan;
                end
            end
        end
        
        function mystr = practnum2str(practicasstr,mynum)
            mystr = strings(size(mynum));
            for i=1:numel(mynum)
                if ~isnan(mynum(i)) && mynum(i)>0
                    mystr(i) = practicasstr(mynum(i));
                end
            end
        end
        
        function solu = generosolrandom(practicas)
            % genero una solucion puramente random, sólo pido que cada 
            %  grupo haga 3 practicas validas (no repetidas, y una
            %  con lockin). No importa los otros grupos
            ng = 8;
            
%             solu="";
            solu(ng,3) = nan;
            for indg=1:ng

                valid = 0;
                while valid==0
                    index = randperm(length(practicas));    
                    sol1g = practicas(index(1:3));
                    valid = fp_practicas.check_sol_1_group(sol1g);
                end
                solu(indg,:) = sol1g;

            end
        end        
        
        function solu = construyosol(pref,practicas)

            ng = size(pref,1);
            ngeleccion = ng-1; % un grupo que no eligió, porque aun no eligio

            %inicializo
%             solu= "";
            solu(ng,3) = nan;

            % P1, practica de la primera ronda
            for indg=1:ngeleccion 
                %me aseguro de asignar a cada grupo una practica que eligio
                posibles = pref(indg,:);
                %descarto strings vacios
%                 posibles(arrayfun(@(x) isempty(x{1}),posibles))=[];
                posibles(isnan(posibles))=[];
                %elijo aleatorio entre las que eligio
                solu(indg,1) = posibles(randi(length(posibles)));                    
            end
            
            % P2, practica de la segunda ronda
            valid=0;
            cont=0;
            while valid==0    
                cont=cont+1;
                valid = 1;
                for indg=1:ngeleccion                    
                    posibles = practicas;
                    %descarto la que ya hizo en primera ronda
                    posibles(posibles==solu(indg,1))=[];

                    %descarto la que ya asigné a otros grupos en esta ronda
                    for indgg=1:indg-1
                        posibles(posibles==solu(indgg,2))=[];
                    end

                    %si ya no me quedan practicas, salgo. Creo que no pasa
                    posibles = intersect(posibles,pref(indg,:));
                    if isempty(posibles)
                        valid=0;
                        if cont==10
                            return
                        end
                        break
                    end            

                    % elijo para la una aleatoria de las que quedan
                    posible = posibles(randi(length(posibles)));
                    solu(indg,2) = posible;
                end
            end

            % P3, practica de la tercera ronda
            valid=0;
            cont=0;
            while valid==0    
                cont=cont+1;
                valid = 1;
                for indg=1:ngeleccion
                    posibles = practicas;
                    
                    %descarto la que ya hizo en 1ra  y 2da rondas
                    posibles(posibles==solu(indg,1))=[];
                    posibles(posibles==solu(indg,2))=[];

                    %descarto la que ya asigné a otros grupos en esta ronda
                    for indgg=1:indg-1
                        posibles(posibles==solu(indgg,3))=[];
                    end    

                    %si ya no me quedan practicas, salgo. Creo que no pasa
                    posibles = intersect(posibles,pref(indg,:));
                    if isempty(posibles)
                        valid=0;            
                        if cont==10
                            return
                        end
                        break
                    end
                    
                    % elijo para la una aleatoria de las que quedan
                    posible = posibles(randi(length(posibles)));
                    solu(indg,3) = posible;
                end
            end
            
        end        
        
        function valid = check_sol_1_group(sol)
            valid = 1;

            % todos tienen que ser diferentes
            if length(unique(sol))<length(sol)
                valid = 0;
                return
            end

            % 1- Todos hagan una practica que incluya lockin
            practlockin=["susceptibilidad" "resistividad" "piezo"];
            practlockin=[8 7 6];
            interse = intersect(sol,practlockin);
            if length(interse)~=1
                valid = 0;
                return
            end        

        end        
        
        function out = puntaje(pref,sol)
            
            ng= size(sol,1);
            np = size(sol,2);
            
            %si la practica fue elegida, sumo el rank, para minimizar
            %si alguna practica no fue elegida por el grupo, sumo 100000
            out=0;
            for indg=1:ng 
                for indp=1:np
                    [tf,loc]=ismember(sol(indg,indp),pref(indg,:));
                    if tf
                        out = out+loc;
                    else
                        out = out+1000000;
                    end
                end
            end
            
            % si alggun grupo tiene una practica no valida, sumo
            % (no deberia pasar, porque ya chequee esto al construir)
            for indg=1:ng                
                valid = fp_practicas.check_sol_1_group(sol(indg,:));
                if valid ==0
                    out = out + 100000;
                end
            end

            %si hay practicas repetidas en cada ronda
            for indp=1:np
                pn = sol(:,indp);
                if length(unique(pn))<length(pn)
                    out = out+10000;
                    break
                end
            end

            % hay ciertas practicas que tienen que estar en la primera
            % ronda (o en cualquiera de las 3 rondas, si las intercambio)
            practP1a =  ["young" "vacio" "pid" "ferro" ];%En P1 tienen que estar estas 4 
            practP1b =  ["peltier" "leidenfrost" ];% y una de estas dos tambien
            practP1a =  [10 9 5 2 ];%En P1 tienen que estar estas 4 
            practP1b =  [4 3 ];% y una de estas dos tambien
            
            %(en realidad pueden estar juntas en P1 o P2 o P3)
            l1 = length(intersect(sol(:,1),practP1a))==4 & length(intersect(sol(:,1),practP1b))>=1;
            l2 = length(intersect(sol(:,2),practP1a))==4 & length(intersect(sol(:,2),practP1b))>=1;
            l3 = length(intersect(sol(:,3),practP1a))==4 & length(intersect(sol(:,3),practP1b))>=1;
            if ~any([l1,l2,l3])
                out = out+1000;
            end
            
            % Todos tienen que pasar por alguna de termo:
            practtermo = ["ferro", "difusividad", "leidenfrost", "peltier", "vacio"];
            practtermo = [2,1,3,4,9];
            for indg=1:ng                
                if isempty(intersect(sol(indg,:),practtermo))
                    out = out + 100;
                end
            end
        end

        function rank = armorank(sol,pref)
            %armo la matriz de rank de la solucion, con las preferencias de
            %cada grupo.
            ng= size(sol,1);
            np = size(sol,2);
            rank = nan(size(sol));
            for indg=1:ng 
                for indp=1:np
                    [~,loc]=ismember(sol(indg,indp),pref(indg,:));        
                    rank(indg,indp) = loc;
                end
            end
        end        
    end
end