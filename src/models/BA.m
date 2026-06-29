% Program pro generování matice sousednosti BA sítě
function [A] = BA(N,m0,m)
% N - Počet uzlů
% m0 - Počet vrcholů pro počáteční souvislý graf
% m - Počet nových spojení
% m < m0

A = zeros(N);
% Vytvoření souvislého grafu ze m0 uzlů
for i=1:m0
    for j=i+1:m0
        A(i,j) = 1;
        A(j,i) = 1;
    end
end

% Přidávání nových uzlů
for i=m0+1:N
    cd = 0;
    while cd < m
        j = randi(i-1);
        p = sum(A(j,:))/sum(A,'all');
        b = randn;
        if p>b
            cd = cd + 1;
            A(i,j) = 1;
            A(j,i) = 1;
        end
    end
end
