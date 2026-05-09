%% GRAFIKA KOMPUTEROWA LAB_6
% *Joanna Dagil 231008*

%% 1. CEL CWICZENIA
% Kreślenie krzywych i minimalizacja średniokwadratowa.

%% 2. ZADANIA


%% 2.1 ZADANIE 1 

% Wykreślanie krzywej o równaniu y = A * x^(1/2), dla x = 0..X-1 i A w [5, 30], za pomocą algorytmu Bresenhama.

function Im = Bresenham(A,M,N)
    Im = uint8(255 * ones(M, N));
    A = int32(A);   % praca na liczbach całkowitych
    Asq = A*A;

    y_switch = idivide(Asq,2); % oblicznie miejsca, w ktorym pochodna spada ponizej 1 
    if y_switch > M-1
        y_switch = M-1;
    end

    % Pierwsza część krzywej, gdzie pochodna jest większa od 1
    x = 0;

    for y = 0:y_switch
        xt = y*y;
        if abs(xt - Asq*x) > abs(xt - Asq*(x+1))
            x = x+1;
        end
        Im(M-y,x+1) = 0;
    end

    % Druga część krzywej, gdzie pochodna jest mniejsza od 1
    xp = x;
    y = y_switch;

    for x = xp:N-1
        yt = Asq*x;
        if abs(yt - y*y) > abs(yt - (y+1)^2)
            y = y+1;
        end
        if y > M-1
            break;
        end
        Im(M-y,x+1) = 0;
    end
end


A = 10;
Im = Bresenham(A, 480, 640);
figure(1); imshow(Im);






%% 2.2 ZADANIE 2

% Wyznaczanie aproksymacji dla zbioru punktów metodą najmniejszych kwadratów
% Krzywą o równaniu y = a + b * sin(x) + cx^2
% Dla uporządkowanego zbioru punktów o współrzędnych (x_i, y_i), dla i = 1..N

% BETA = (V' * V)^(-1) *V' * Y
% V = [1, sin(x_i), x_i^2], dla i w [1, N]

function [a, b, c] = LSM_2(x, y, m)
    V = zeros(m,3);
    for i = 1:m
        V(i,1) = 1;
        V(i,2) = sin(x(i));
        V(i,3) = x(i).^2;
    end
    beta = inv(V' * V) * V' * y';
    a = beta(1); b = beta(2); c = beta(3);
end



xy = [1, 2;    3, 8;    7, 13;    12, 12;   56, 2];
% xy = [1,2;    13, 18;    27, 23;   32, 12;    56, 42];

[m, ~] = size(xy);
x2(1:m) = xy(1:m,1);
y2(1:m) = xy(1:m,2);

[a2, b2, c2] = LSM_2(x2,y2,m);

t = x2(1):0.01:x2(m);
wykres = a2 + b2 * sin(t) + c2 * t.^2;
figure(2); plot(t,wykres); hold on;
stem(x2,y2);
hold off;








%% 2.3 ZADANIE 3

% j. w. dla funkcji y = a * sin(x)^2 + b * cos(x) + c * x^(1/3)

function [a, b, c] = LSM_3(x, y, m)
    V = zeros(m,3);
    for i = 1:m
        V(i,1) = sin(x(i)).^2;
        V(i,2) = cos(x(i));
        V(i,3) = x(i).^(1/3);
    end
    beta = inv(V' * V) * V' * y';
    a = beta(1); b = beta(2); c = beta(3);
end


%xy = [1, 2;    3, 8;    7, 13;    12, 12;   56, 2];
xy = [1,2;    13, 18;    27, 23;   32, 12;    56, 42];

[m, ~] = size(xy);
x3(1:m) = xy(1:m,1);
y3(1:m) = xy(1:m,2);

[a3, b3, c3] = LSM_3(x3, y3, m);
t = x3(1):0.01:x3(m);
wykres = a3*(sin(t)).^2 + b3*cos(t) + c3*t.^(1/3);
figure(3); plot(t,wykres); hold on;
stem(x3,y3);
hold off;






%% 2.4 ZADANIE 4

% j. w. dla funkcji y = a * x^2 + b * x + c
% dla wygenerowanego zbioru punktów (x_i, y_i), dla i = 1..30 


function [a, b, c] = LSM_4(x, y, m)
    V = zeros(m,3);
    for i = 1:m
        V(i,1) = x(i).^2;
        V(i,2) = x(i);
        V(i,3) = 1;
    end
    beta = inv(V' * V) * V' * y';
    a = beta(1); b = beta(2); c = beta(3);
end

for J = 1:5
    x4 = zeros(1,30);
    y4 = zeros(1,30);
    t = -10:0.01:10;
    ff = -0.5*t.^2 + 2.*t;

    figure(10); plot(t,ff);
    hold on;

    for i = 1:30
        x4(i) = 20*rand - 10;
        y4(i) = -0.5.*x4(i).^2 + 2*x4(i) + 6*rand-3;
        stem(x4(i),y4(i));
    end

    [a(J), b(J), c(J)] = LSM_4(x4, y4, 30);
end

A = mean(a)
B = mean(b)
C = mean(c)

ffA = A*t.^2 + B.*t + C;
plot(t,ffA);
hold off;


%% Typowy koniec skryptu

% clear all; % usuniecie wszystkich zmiennych
% close all; % zamkniecie wszystkich wykresow
% clc % zresetowanie okna komend
