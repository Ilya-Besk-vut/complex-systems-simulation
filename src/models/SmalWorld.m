% Program pro generování matice sousednosti sítě typu Malý svět
function [A,Areg] = SmalWorld(N, k, pw)

% N Počet uzlů
% k Počet spojení každého uzlu (sudý)
% pw Pravděpodobnost přepojení hrany

    A = zeros(N, N);

% Vytvoření počáteční kruhové mřížky
    for i = 1:N
        for j = i + 1:i + k / 2
            if j > N
                j = j - N;
            end

            % Создание рёбер
            A(i, j) = 1;
            A(j, i) = 1;
        end
    end

    Areg = A;

    % Přepojení hran s pravděpodobností pw
    for i = 1:N
        for l = i + 1:i + k / 2
            if l > N
                l = l - N;
            end

            chance = rand();

            if pw > chance
                % Výběr náhodného uzlu j, kromě i a sousedů uzlu i
                candidates = setdiff(1:N, [i, find(A(i, :))]);
                % Náhodně vybere uzel, který není spojen s uzlem i
                j = candidates(randi(length(candidates)));
                
                % Odpojení hrany mezi i a l
                A(i, l) = 0;
                A(l, i) = 0;

                % Vytvoření hrany mezi i a j
                A(i, j) = 1;
                A(j, i) = 1;
            end
        end
    end
end