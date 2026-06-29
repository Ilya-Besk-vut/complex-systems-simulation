% Program pro simulaci procesu polarizace názorů ve skupině
clear 
addpath(fullfile(pwd, 'models'));

% Parametry modelu
N = 1000; % Počet prvků
MaxIt = 100; % Počet iterací
s = 0.1; % Rychlost aktualizace schématu
kOP = 0.3; % Koeficient změny názoru
deltaOP = 0.2; % Parametr blízkosti názorů
kB = 0.2; % Koeficient změny síly vazeb

% Přiřazení počátečních hodnot

% Počáteční názor (mezi -1 a 1)
OP(1:N,1) = 2* rand(N,1)-1;
% Počáteční struktura vazeb – vážená
B(:,:,1) = SmalWorld(N, 5, 0.01);
A = rand(N);
A = triu(A) + triu(A,1)';
A(1:N+1:end) = 0;
B(:,:,1) = B(:,:,1) .* A;
G = graph(B(:,:,1));

% Počáteční schéma
h = plot(G);
Xcords = h.XData;
Ycords = h.YData;
h.NodeColor = color(OP(:,1),N);
linkdata on

% Simulace MaxIt kroků interakcí

for t = 1:MaxIt
% Rychlost aktualizace schématu
    pause(s);
% Určení, které prvky budou v tomto kroku interagovat
    R = rand(N);
    R = triu(R) + triu(R,1)';
    C = B(:,:,t)>R; % C – matice aktuálních interakcí
% Určení rozdílu názorů mezi interagujícími agenty
    r = (OP(:,t) .* ones(N) - (OP(:,t) .* ones(N))');
    %r – matice, ve které je v každém řádku i vektor rozdílů mezi názorem prvku i a názory ostatních prvků
    r1 = OP(:,t) - C * OP(:,t);
    %r1 – vektor rozdílů názorů prvku i a jeho okolí
% Změna názorů prvků
    OP(:,t+1) = OP(:,t) - kOP*r1;
    % Normalizace OP, -1 < OP < 1
    OP(:,t+1) = OP(:,t+1) - OP(:,t+1).*(OP(:,t+1)>1) + (OP(:,t+1)>1);
    OP(:,t+1) = OP(:,t+1) - OP(:,t+1).*(OP(:,t+1)<-1) - (OP(:,t+1)<-1);
% Změna struktury vazeb
    B(:,:,t+1) = B(:,:,t) + kB*(abs(r) < deltaOP) .*C - kB*(abs(r) > deltaOP).*C;
    % Normalizace B, 0 < B < 1
    B(:,:,t+1) = B(:,:,t+1) - B(:,:,t+1).*(B(:,:,t+1)>1) + (B(:,:,t+1)>1);
    B(:,:,t+1) = B(:,:,t+1) - B(:,:,t+1).*(B(:,:,t+1)<0);
% Aktualizace schématu
    G=graph(B(:,:,t+1));
    h=plot(G);
    h.NodeColor = color(OP(:,t+1),N);
end
% Histogram počátečního rozdělení názorů
figure;
title('Start') 
histogram(OP(:,1),20);
% Histogram rozdělení názorů v polovině procesu
figure;
title('50 It')
histogram(OP(:,MaxIt/2),20);
% Histogram rozdělení názorů na konci procesu
figure;
title('Finish')
histogram(OP(:,MaxIt),20);