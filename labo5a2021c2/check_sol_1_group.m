function valid = check_sol_1_group(sol)
    valid = 1;

    % todos tienen que ser diferentes
    if length(unique(sol))<length(sol)
        valid = 0;
        return
    end        
    
    % 1- Todos hagan una practica que incluya algo de estocasticos o correlaciones  (nuclear, conteo, caminata, pinzas).
    practestoc=["nuclear" "conteo" "caminata" "pinzas"];
    interse = intersect(sol,practestoc);
    if isempty(interse)
        valid = 0;
        return
    end
    
    % 2- nadie haga (conteo y nuclear)  o (caminatas y pinzas) 
    conteonuc=["nuclear" "conteo"];
    interse = intersect(sol,conteonuc);
    if length(interse)>1
        valid = 0;
        return
    end
    
    % 2- nadie haga (conteo y nuclear)  o (caminatas y pinzas) 
    campinzas=["caminata" "pinzas"];
    interse = intersect(sol,campinzas);
    if length(interse)>1
        valid = 0;
        return
    end        
    
    % 3- Pinzas no está en primera ronda
    if sol(1)=="pinzas"
        valid = 0;
        return
    end
end