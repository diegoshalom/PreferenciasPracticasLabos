function sol = generopermutacion(sol,cant)
practicas = ["nuclear" "conteo" "caminata" "pinzas" "foto" "glow" "esp laser" "esp" "fluidos"];


for i=1:cant
    index1 = randi(8*3);
    index2 = randi(8);
    sol(index1) = practicas(index2);   
end
    


end