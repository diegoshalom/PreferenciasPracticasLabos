function out = puntaje(pref,sol)
ng= size(sol,1);
np = size(sol,2);
out=0;
for indg=1:ng 
    for indp=1:np
        [tf,loc]=ismember(sol(indg,indp),pref(indg,:));
        if tf
            out = out+loc;
        else
            out = out+10000;
        end
    end

    valid = check_sol_1_group(sol(indg,:));
    out = out + (1-valid)*1000;
       
end


%si hay practicas repetidas 
for indp=1:np
    pn = sol(:,indp);
    if length(unique(pn))<length(pn)
        out = out+1000;
    end
end

