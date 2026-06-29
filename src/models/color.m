% Funkce pro obarvení uzlů
function Colors = color(X,N)
    %norma = (X + 4*ones(N,1))/8;
    norma = (X + ones(N,1))/2;
    red = ones(N,1)- norma;
    green = norma;
    blue = zeros(N,1);
    Colors = [red, green, blue];
end