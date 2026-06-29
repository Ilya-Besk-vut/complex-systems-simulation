% Program pro simulaci vlastního komplexního systému
clear
addpath(fullfile(pwd, 'models'));
% Počáteční parametry systému
N = 100;
T = 200;
%a(1:N,1) = 9* rand(N,1) + 1; % Počáteční bohatství měst
a(1:N,1) = max(0, 2*randn(N,1) + 100);

B = SmalWorld(N,4,0.01); % Matice sousedství měst
A = Vaha(N).* BA(N,3,3); % Matice obchodních cest
M(:,:,1,1) = A;
M(:,:,2,1) = B;
b(:,1) = sum(M(:,:,1,1)>0)'/ (nnz(M(:,:,1,1)) / 2); % Počáteční parametr mírumilovnosti měst

% Vizualizace počátečního stavu systému
subplot(2, 1, 1);
h1 = plot(graph(M(:,:,1,1)));
h1.NodeCData = b(:,1);
h1.MarkerSize = 1+15 * a(:,1)/max(a(:,1));
h1.NodeColor = 'flat';
title('Ma');

subplot(2, 1, 2);
h2 = plot(graph(M(:,:,2,1)));
h2.NodeColor = color(b(:,1),N);
h2.NodeCData = b(:,1);
h2.MarkerSize = 1+15 * a(:,1)/max(a(:,1));
h2.NodeColor = 'flat';
title('Mb');

colormap([linspace(1,0,N)', linspace(0,1,N)', zeros(N,1)]);

linkdata on

% Interakce uvnitř systému
for t=1:T
    pause(0.1)
    u1(1:N,t) = (1 - b(:,t)) > rand(N,1); % Prvky, které chtějí zaútočit
    u2 = a(1:N,t)>a(1:N,t)'; % Matice, ve které je v každém řádku i vektor ukazující, na které prvky má prvek i převahu
    u3 = u1(1:N,t) .* u2 .* M(:,:,2,t); % Kontrola splnění podmínek, touha zaútočit, existují chudší sousedé
    v(:,:,t) = u3.*(sum(u3)==1); % Pokud chce na jedno město zaútočit více měst, útok se neuskuteční
    v(:,:,t) = v(:,:,t) .* (sum(v(:,:,t)')==1)'; % Města, která chtějí zaútočit na více než jedno město, neútočí vůbec
    a(:,t+1) = a(:,t) + v(:,:,t) * a(:,t) - sum(v(:,:,t))' .* a(:,t); % Nové hodnoty bohatství
    M(:,:,2,t+1) = M(:,:,2,t) .* (a(:,t+1)~=0) .* (a(:,t+1)~=0)'; % Zničení sousedských vazeb u dobytých měst
    M(:,:,1,t+1) = M(:,:,1,t) .* (a(:,t+1)~=0) .* (a(:,t+1)~=0)'; % Zničení obchodních vazeb u dobytých měst
    %-------------------------------------------------------------------
    % Město-dobyvatel se stává sousedem všech měst, se kterými
    % bylo sousedem dobyté město
    for i=1:N
        for j=1:N
            if v(i,j,t)==1 && a(j,t+1)==0
                M(i,:,2,t+1) = min(1,(M(i,:,2,t) + M(j,:,2,t)));
                M(:,i,2,t+1) = min(1,(M(:,i,2,t) + M(:,j,2,t)));
                M(i,i,2,t+1) = 0;
                M(i,j,2,t+1) = 0;
                M(j,i,2,t+1) = 0;
            end
        end
    end
    %-------------------------------------------------------------------

    a(:,t+1) = a(:,t+1) + (abs(a(:,t+1).*ones(N)-(a(:,t+1).*ones(N))') .* M(:,:,1,t+1)) * ones(N,1); % Zvýšení blahobytu přeživších měst díky obchodu

    % Změna obchodních cest v důsledku obchodu
    for i=1:N
        for j=i+1:N
            if abs(a(i,t+1) - a(j,t+1)) < 0.3*max(a(i,t+1),a(j,t+1)) && (a(i,t+1)~=0)  
                M(i,j,1,t+1) = min(1, M(i,j,1,t+1) + 0.1);
                M(j,i,1,t+1) = min(1, M(j,i,1,t+1) + 0.1);
            else
                M(i,j,1,t+1) = max(0, M(i,j,1,t+1) - 0.1);
                M(j,i,1,t+1) = max(0, M(j,i,1,t+1) - 0.1);
            end
        end
    end
    
    % Změna mírumilovnosti
    if (nnz(M(:,:,1,t+1)) / 2) ~= 0
        b(:,t+1) = sum(M(:,:,1,t+1)>0)'/ (nnz(M(:,:,1,t+1)) / 2);
    else
        b(:,t+1) = 0.001;
    end

    %----------------------------------------------------------------------
    % Aktualizace grafů

    subplot(2, 1, 1);
    h1 = plot(graph(M(:,:,1,t+1)));
    h1.NodeCData = b(:,t+1);
    h1.MarkerSize = 1+15 * a(:,t+1)/max(a(:,t+1));
    h1.NodeColor = 'flat';
    title('Ma');

    subplot(2, 1, 2);
    h2 = plot(graph(M(:,:,2,t+1)));
    h2.NodeCData = b(:,t+1);
    h2.MarkerSize = 1  + 15 * a(:,t+1)/max(a(:,t+1));
    h2.NodeColor = 'flat';
    title('Mb');

end

attacks = zeros(1, T);
alive_cities = sum(a(:,1:T) > 0, 1);
trade_links = zeros(1, T);
gini_index = zeros(1, T);
mean_wealth_alive = zeros(1, T);
median_wealth_alive = zeros(1, T);

for t = 1:T
  % Výpočet metrik pro zobrazení po dokončení simulace
    total_wealth(t) = sum(a(:,t)); % Celkové bohatství v každém časovém okamžiku
    mean_peace(t) = sum(b(:,t))/nnz(a(:,t));  % Průměrná mírumilovnost v každém časovém okamžiku
    alive = a(:,t) > 0;
    mean_wealth_alive(t) = mean(a(alive,t));
    median_wealth_alive(t) = median(a(alive,t));
    attacks(t) = sum(v(:,:,t), 'all');
end

for t = 1:T
    % Počet nenulových obchodních vazeb (zohledněna symetrie)
    trade_links(t) = nnz(M(:,:,1,t)) / 2;

    % Giniho koeficient
    x = sort(a(a(:,t) > 0, t)); 
    n = length(x);
    if n > 1
        gini_index(t) = (2*sum((1:n)'.*x))/(n*sum(x)) - (n+1)/n;
    else
        gini_index(t) = 0; % Pokud zůstalo jen jedno město, neexistuje žádná nerovnost
    end
end

% Zobrazení dat na grafech

% ------------------------- Graf 1 -------------------------
figure('Name','Sociální dynamika');
subplot(5,1,1);
plot(1:T, trade_links, 'b', 'LineWidth', 2);
ylabel('Počet obchodních spojení');
grid on;

subplot(5,1,2);
plot(1:T, mean_peace, 'g', 'LineWidth', 2); hold on
ylabel('Průměrná mírumilovnost/Nerovnost');
ylim([0 1]);

plot(1:T, gini_index, 'r', 'LineWidth', 2);
xlabel('Čas');
grid on;
legend('Mírumilovnost','Nerovnost','Location','best');

subplot(5,1,3);
semilogy(1:T, total_wealth, 'm', 'LineWidth', 2); hold on;
semilogy(1:T, mean_wealth_alive, 'c--', 'LineWidth', 1.8);
semilogy(1:T, median_wealth_alive, 'k-.', 'LineWidth', 1.8);
ylabel('Bohatství');
legend('Celkové (log)', 'Průměrné (živá města)', 'Medián (živá města)', 'Location', 'best');
grid on;

subplot(5,1,4);
plot(1:T, alive_cities, 'k', 'LineWidth', 2);
ylabel('Živá města');
xlabel('Čas');
grid on;

subplot(5,1,5);
plot(1:T, attacks, 'r', 'LineWidth', 2);
ylabel('Počet útoků');
xlabel('Čas');
grid on;

% ------------------------- Graf 2 -------------------------
figure('Name','Dynamika nerovnosti');
plot(1:T, gini_index, 'r', 'LineWidth', 2);
ylabel('Giniho koeficient');
xlabel('Čas');
title('Nerovnost bohatství');
grid on;




 



    








