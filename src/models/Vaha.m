function [V] = Vaha(N)
V = rand(N);
V = triu(V) + triu(V,1)';