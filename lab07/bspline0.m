function poly0 = bspline0(T,t,M)
% T - wektor wspolrzednych M+1 wezlow pomiedzy 0 i 1 (T(1) = 0 i T(M+1) = 1)
% t - N-elementowy wektor reprezentujacy odcinek <0;1>, np. z krokiem 0.001
% poly0 tablica dyskretnej reprezentacja M "wielomianow" stopnia 0 
% wektorami o dlugosci takiej samej jak wektor t 
% kolejne kolumny poly0 reprezentuja kolejne "wielomiany" stopnia 0
N = numel(t);
poly0 = zeros(N,M);
for j = 1:M
    for i = 1:N
        poly0(i,j) = (t(i)>=T(j) && t(i)<T(j+1));
    end
end
end
