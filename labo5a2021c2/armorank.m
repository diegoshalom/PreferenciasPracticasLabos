function rank = armorank(sol,pref)
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