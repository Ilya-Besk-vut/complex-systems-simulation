% Porovnání závislosti řádového parametru na síle vazby
% mezi oscilátory v sítích ER a BA. (Spuštění kódu trvá poměrně dlouho).
clear 
addpath(fullfile(pwd, 'models'));
% Počáteční parametry
T = 250; 
dt = 0.1;
N = 1000;
A = ER(N,0.006);
B = BA(N,50,3);
i = 1;
% Výpočet řádových parametrů pro každou hodnotu lambda. Pro síť ER – R1,
% pro síť BA – R2. 
 for lambda = 0:0.01:1
     [X1,r1] = Kur(T,dt,lambda,A);
     [X2,r2] = Kur(T,dt,lambda,B);
     R1(i) = sum(r1(50:end))/(T-50);
     R2(i) = sum(r2(50:end))/(T-50);
     l(i) = lambda;
     i = i+1;
 end

% Aproximace R1(l) a R2(l)
p1 = polyfit(l, R1, 9);
lq = linspace(min(l), max(l), 100);
R1q = polyval(p1, lq);

p2 = polyfit(l, R2, 3);
R2q = polyval(p2, lq);

% Vykreslení grafu
figure;
plot(l, R1, 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'b'); % Body R1
hold on;
plot(l, R2, 'bo', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); % Body R2
plot(lq, R1q, 'b-', 'LineWidth', 1); % Aproximace R1
plot(lq, R2q, 'r-', 'LineWidth', 1); % Aproximace R2
hold off;


 xlabel('l');
 ylabel('R1, R2');
 title('Aproximace závislostí R1(l) a R2(l)');
 grid on;
 legend('Body R1', 'Body R2', 'Aproximace R1 pro ER-sít', 'Aproximace R2 pro Bezškálovou sít');