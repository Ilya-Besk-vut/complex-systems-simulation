% Funkce modelu Kuramoto na síťových strukturách
function [X1,r] = Kur(T,dt,lambda,A)
% T - počet iterací
% dt - časový krok
% lambda - síla vazby pro síťovou strukturu
% A - interakční struktura
N = length(A);
X1 = normrnd(pi, pi/2, [N,1]); % Počáteční fáze
X2 = normrnd(0, 1, [N,1]); % Počáteční frekvence
% Interakce podle modelu Kuramoto
for t=1:T
    for i=1:N
        s = A(i,:) * sin(X1(:,t) - X1(i,t)); 
        X1(i,t+1) = X1(i,t) + dt * (X2(i) + lambda * s);
    end
    X1(:,t+1) = mod(X1(:,t+1), 2*pi); % Normalizace
    r(t) = abs((1/N) * sum(exp(1i * X1(:,t))));
end
