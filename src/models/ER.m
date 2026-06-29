% Program pro generování matice sousednosti ER sítě
function A = ER(N,p)
  R = zeros(N);
  for i=1:N
      for j=i+1:N
          c = rand;
          if p>c
              R(i,j) = 1;
              R(j,i) = 1;
          end
      end
  end
  A = R;

end
