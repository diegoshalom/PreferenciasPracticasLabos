function solu = generosolrandom()
practicas = ["nuclear" "conteo" "caminata" "pinzas" "foto" "glow" "esp laser" "esp" "fluidos"];

solu(8,3) = "1";
for indg=1:8

    valid = 0;
    while valid==0
        index = randperm(9);    
        sol1g = practicas(index(1:3));
        valid = check_sol_1_group(sol1g);
    end
    solu(indg,:) = sol1g;
    
end
end