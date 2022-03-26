function solu = construyosol(pref)
practicas = ["nuclear" "conteo" "caminata" "pinzas" "foto" "glow" "esp laser" "esp" "fluidos"];
practicas1 = ["nuclear" "conteo" "caminata" "foto" "glow" "esp laser" "esp" "fluidos"];

valid=0;
while valid==0    
    p1 = practicas1(randperm(8));
    valid=1;
    for indg=1:8
        if ~ismember(p1(indg),pref(indg,:))
            valid=0;
            break
        end
    end
end

solu= "";
solu(8,3) = "1";
solu(:,1) = p1;

valid=0;
cont=0;
while valid==0    
    cont=cont+1;
    valid = 1;
    for indg=1:8
        posibles = practicas;
        posibles(posibles==solu(indg,1))=[];

        for indgg=1:indg-1
            posibles(posibles==solu(indgg,2))=[];
        end

        posibles = intersect(posibles,pref(indg,:));

        if isempty(posibles)
            valid=0;
            
            if cont==10
                return
            end
            
            break
        end            

        posible = posibles(randi(length(posibles)));
        solu(indg,2) = posible;
    end
end

valid=0;
cont=0;
while valid==0    
    cont=cont+1;
    valid = 1;
    for indg=1:8
        posibles = practicas;
        posibles(posibles==solu(indg,1))=[];
        posibles(posibles==solu(indg,2))=[];

        for indgg=1:indg-1
            posibles(posibles==solu(indgg,3))=[];
        end    

        posibles = intersect(posibles,pref(indg,:));

        if isempty(posibles)
            valid=0;            

            if cont==10
                return
            end

            
            break
        end

        posible = posibles(randi(length(posibles)));
        solu(indg,3) = posible;
    end
end

end