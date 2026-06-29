% Ověření vlastností bezškálové sítě vytvořené pomocí algoritmu BA 
clear 
addpath(fullfile(pwd, 'models'));
N = 100;

% Vytvoření bezškálové sítě
G = BA(N,10,1);
% Seřazení uzlů podle jejich stupně
D = sort(G * ones(N,1));
j = 1;
for i=D(1):D(end)
    X(1,j) = i;
    X(2,j) = sum(D==i)/N;
    j = j+1;
end

x = linspace(1, D(end), 100);
y = x.^(-3);

% Zobrazení teoretického a skutečného rozdělení stupňů uzlů
figure(1)
plot(X(1,:), X(2,:), 'ro',x,y,'b')
xlabel('k');
ylabel('P(k)');
legend('Experimentální body', '$k^{-3}$', 'Interpreter', 'latex');

figure(2)
plot(graph(G))



