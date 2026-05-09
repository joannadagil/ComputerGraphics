%% GRAFIKA KOMPUTEROWA LAB_7
% *Joanna Dagil 231008*

%% 1. CEL CWICZENIA
% Kreślenie krzywych i krzywe b-sklejane.

%% 2. ZADANIA

%% 2.1 ZADANIE 1 

% Rysowanie wielomianów stopnia 0 dla różych zestawów węzłów

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


t = 0:0.001:1;

%% (a)

M = 10;
for i = 1:(M+1) T(i) = 0.1*(i-1); end

poly0 = bspline0(T,t,M);
figure(11); plot(t,poly0);

%% (b)

MM = 9;
TT = [0, 0.1, 0.3, 0.4, 0.6, 0.65, 0.8, 0.9, 0.95, 1];

poly00 = bspline0(TT,t,MM);
figure(12); plot(t,poly00);

%% (c)

t = 0:0.001:1;
M = 10;
TTT = [0, sort(rand(1,M-1)), 1];

poly000 = bspline0(TTT,t,M);
figure(13); plot(t,poly000);



%% 2.2 ZADANIE 2

% j.w. stopnia 1, 2 i 3.

function poly1 = bspline1(T,t,M,poly0)
    N = numel(t);
    poly1 = zeros(N,M-1);
    for j=1:M-1
        A = T(j+1)-T(j);
        B = T(j+2)-T(j+1);
        for i=1:N
            poly1(i,j) = (t(i)-T(j))*poly0(i,j)/A + (T(j+2)-t(i))*poly0(i,j+1)/B;
        end
    end
end

function poly2 = bspline2(T,t,M,poly1)
    N = numel(t);
    poly2 = zeros(N,M-2);
    for j=1:M-2
        A = T(j+2)-T(j);
        B = T(j+3)-T(j+1);
        for i=1:N
            poly2(i,j) = (t(i)-T(j))*poly1(i,j)/A + (T(j+3)-t(i))*poly1(i,j+1)/B;
        end
    end
end

function poly3 = bspline3(T,t,M,poly2)
    poly3 = zeros(1001,M-3);
    for j=1:M-3
        A = T(j+3)-T(j);
        B = T(j+4)-T(j+1);
        for i=1:1001
            poly3(i,j) = (t(i)-T(j))*poly2(i,j)/A + (T(j+4)-t(i))*poly2(i,j+1)/B;
        end
    end
end


%% (a)

poly1 = bspline1(T,t,M,poly0);
figure(21); plot(t,poly1);

poly2 = bspline2(T,t,M,poly1);
figure(22); plot(t,poly2);

poly3 = bspline3(T,t,M,poly2);
figure(23); plot(t,poly3);

%% (b)

poly11 = bspline1(TT,t,MM,poly00);
figure(24); plot(t,poly11);

poly22 = bspline2(TT,t,MM,poly11);
figure(25); plot(t,poly22);

poly33 = bspline3(TT,t,MM,poly22);
figure(26); plot(t,poly33);

%% (c)

poly111 = bspline1(TTT,t,M,poly000);
figure(27); plot(t,poly111);

poly222 = bspline2(TTT,t,M,poly111);
figure(28); plot(t,poly222);

poly333 = bspline3(TTT,t,M,poly222);
figure(29); plot(t,poly333);






%% 2.3 ZADANIE 3

% Rysowanie krzywych b-sklejanych stopnia 2 dla zestawów węzłów z powyższych zadań.

function plotBspline2D(poly2,X,Y)
    [N, kk] = size(poly2);
    
    xx = zeros(N,1);
    yy = zeros(N,1);
    
    for i = 1:N
        for j = 1:kk
            xx(i) = xx(i) + X(j)*poly2(i,j);
            yy(i) = yy(i) + Y(j)*poly2(i,j);
        end
    end
    
    plot(xx,yy,'LineWidth',2); hold off;
end

function plotBspline2Dmod(poly2,X,Y,T,M)
    [N, kk] = size(poly2);

    xx = zeros(N,1);
    yy = zeros(N,1);
    suma = zeros(N,1);

    for i = 1:N
        for j = 1:kk
            xx(i) = xx(i) + X(j)*poly2(i,j);
            yy(i) = yy(i) + Y(j)*poly2(i,j);
            suma(i) = suma(i) + poly2(i,j);
        end
    end

    for i = 1:N
        if suma(i) ~= 0
            xx(i) = xx(i)/suma(i);
            yy(i) = yy(i)/suma(i);
        else
            xx(i) = NaN;
            yy(i) = NaN;
        end
    end

    plot(xx,yy,'LineWidth',2); hold off;
end



% przykładowe punkty kontrolne
X = [1,1,0,-1,-1,-1,0,1];
Y = [0,1,1,1,0,-1,-1,-1];

% aproksymacja
figure(31);
plotBspline2D(poly2,X,Y); hold on
stem(X,Y); hold off;

figure(32);
plotBspline2Dmod(poly2,X,Y,T,M); hold on
stem(X,Y); hold off;



% przykładowe punkty kontrolne
X = [1,1,0,-1,0,-1,0,1];
Y = [0,1,1,1,0,-1,-1,-1];

% aproksymacja
figure(33);
plotBspline2D(poly2,X,Y); hold on
stem(X,Y); hold off;

figure(34);
plotBspline2Dmod(poly2,X,Y,T,M); hold on
stem(X,Y); hold off;



% przykładowe punkty kontrolne
X_b = [1,1,0,-1,-1,-1,0];
Y_b = [0,1,1,1,0,-1,-1];

% aproksymacja
figure(37);
plotBspline2D(poly22,X_b,Y_b); hold on
stem(X_b,Y_b); hold off;

figure(38);
plotBspline2Dmod(poly22,X_b,Y_b,TT,MM); hold on
stem(X_b,Y_b); hold off;


%% 2.4 ZADANIE 4

% Rysowanie krzywej b-sklejanej w 3D.

function plotBspline3D(poly2,X,Y,Z)
    [N, kk] = size(poly2);

    xx = zeros(N,1);
    yy = zeros(N,1);
    zz = zeros(N,1);

    for i = 1:N
        for j = 1:kk
            xx(i) = xx(i) + X(j)*poly2(i,j);
            yy(i) = yy(i) + Y(j)*poly2(i,j);
            zz(i) = zz(i) + Z(j)*poly2(i,j);
        end
    end

    plot3(xx,yy,zz,'LineWidth',2);
    hold on;
    stem3(X,Y,Z,'filled');
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    view(3);
    hold off;
end

function plotBspline3Dmod(poly2,X,Y,Z,T,M)
    [N, kk] = size(poly2);

    xx = zeros(N,1);
    yy = zeros(N,1);
    zz = zeros(N,1);
    suma = zeros(N,1);

    for i = 1:N
        for j = 1:kk
            xx(i) = xx(i) + X(j)*poly2(i,j);
            yy(i) = yy(i) + Y(j)*poly2(i,j);
            zz(i) = zz(i) + Z(j)*poly2(i,j);
            suma(i) = suma(i) + poly2(i,j);
        end
    end

    for i = 1:N
        if suma(i) ~= 0
            xx(i) = xx(i)/suma(i);
            yy(i) = yy(i)/suma(i);
            zz(i) = zz(i)/suma(i);
        else
            xx(i) = NaN;
            yy(i) = NaN;
            zz(i) = NaN;
        end
    end

    plot3(xx,yy,zz,'LineWidth',2);
    hold on;
    stem3(X,Y,Z,'filled');
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    view(3);
    hold off;
end



% przykładowe punkty kontrolne
X = [0,1,1,0,0,1,1,0];
Y = [0,0,1,1,1,1,0,0];
Z = [0,0,0,0,1,1,1,1];

% aproksymacja

figure(41);
plotBspline3D(poly2,X,Y,Z);

figure(42);
plotBspline3Dmod(poly2,X,Y,Z,T,M);

% Zmieniony punkt p3

X2 = X;
Y2 = Y;
Z2 = Z;

X2(4) = 0.5;
Y2(4) = 0.5;
Z2(4) = 0;

figure(43);
plotBspline3D(poly2,X2,Y2,Z2);

figure(44);
plotBspline3Dmod(poly2,X2,Y2,Z2,T,M);


%% Typowy koniec skryptu

% publish('lab07.m', 'pdf')

% clear all; % usuniecie wszystkich zmiennych
% close all; % zamkniecie wszystkich wykresow
% clc % zresetowanie okna komend