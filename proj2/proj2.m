%% GRAFIKA KOMPUTEROWA - PROJEKT 2
%% *Joanna Dagil 231008*
%
%
%% OPIS PROJEKTU
%
% Celem projektu bylo zaprojektowanie litery P za pomoca krzywych b-sklejanych 
% stopnia drugiego oraz wykonanie animacji modyfikujacej jej ksztalt i kolor w czasie.
%
% Projekt zostal podzielony na dwie czesci:
%
% CZESC 1 - Utworzenie statycznego obrazu litery P na czarnym tle.
% CZESC 2 - Wygenerowanie animacji, w ktorej litera P zmienia swoj ksztalt
%           oraz jest przedstawiona w kolorze.
%
% Litera zostala opisana za pomoca dwoch zamknietych konturow:
% - zewnetrznego konturu litery,
% - wewnetrznego konturu odpowiadajacego "dziurze" w literze P.
%
% Oba kontury zostaly utworzone na podstawie punktow kontrolnych,
% a nastepnie aproksymowane krzywymi b-sklejanymi stopnia drugiego.
%
%% REALIZACJA PROJEKTU
%
% Zrealizowane rozwiazanie sklada sie z kilku etapow:
%
% 1. Zdefiniowanie punktow kontrolnych litery P:
%    Funkcja points(change) zwraca wspolrzedne punktow kontrolnych
%    konturu zewnetrznego oraz wewnetrznego. Parametr "change"
%    pozwala modyfikowac ksztalt litery w animacji.
%
% 2. Wyznaczenie krzywych b-sklejanych stopnia drugiego:
%    Funkcje bspline0, bspline1 i bspline2 obliczaja kolejne funkcje
%    bazowe B-spline. Na ich podstawie funkcja curves(points)
%    generuje punkty krzywej odpowiadajacej danemu konturowi.
%
% 3. Rasteryzacja konturu:
%    Funkcja drawCurve rysuje kolejne punkty krzywej na obrazie
%    monochromatycznym.
%
% 4. Wypelnienie wnetrza litery:
%    Funkcja floodfill wypelnia obszar ograniczony konturem.
%    Punkt startowy wybierany jest wewnatrz nogi litery P.
%
% 5. Zapis wyniku statycznego:
%    Obraz z pierwszej czesci projektu zapisywany jest do pliku
%    "czesc1.png".
%
% 6. Generowanie animacji:
%    W drugiej czesci dla kolejnych klatek zmieniany jest parametr
%    "change", co powoduje deformacje litery. Dodatkowo wynik jest
%    zapisywany jako obraz RGB, co pozwala uzyskac kolorowa animacje.
%    Kolejne klatki sa zapisywane do pliku AVI za pomoca VideoWriter.
%
%
%% UZYSKANE WYNIKI
%
% Wynikiem projektu sa:
%
% W CZESCI 1 statyczny obraz litery P na obrazie o rozdzielczosci 640x480.
% Litera jest wypelniona i umieszczona centralnie.
%
% W CZESCI 2 animacja zmieniającego sie ksztaltu litery w kolejnych kratkach, 
% deformacja dotyczy szerokosci "pionowych" części litery - 
% tak jakby ktoś pisał stalówka o różnej grubości
%
% W trakcie realizacji pojawily sie problemy zwiazane z:
% - generowaniem niepoprawnych punktow krzywej w poblizu (0,0),
% - doborem punktu startowego dla floodfill,
% - zbytniego zbliżnia sie ruchomych punktów litery do stacjonarnych punktów
%
% Problemy te zostaly rozwiazane przez:
% - normalizacje wag funkcji bazowych w funkcji curves,
% - dobor punktu startowego lezacego wewnatrz nogi litery,
% - zmniejszenie zmiany litery i przeniesienie nieruchomych punktów dalej od ruchomych.
%
%
%% INSTRUKCJA URUCHOMIENIA
%
% 1. Umiescic plik skryptu w katalogu roboczym MATLAB-a.
% 2. Uruchomic skrypt.
% 3. W wyniku dzialania programu zostana utworzone:
%    - obraz "czesc1.png",
%    - animacja "czesc2.avi".
%
%% CZESC 1
%
% Projekt literę P o dość typowym kształcie za pomocą krzywych b-sklejanych stopnia drugiego.
% Litera powinna być umieszczona centralnie, a jej rozmiar ma wynosić ok. 200x300 pixeli (jak na obrazie P640.bmp).

clear; close all; clc;

% Obraz otrzymany z kamery ma rozdzielczosc 
X = 640;
Y = 480;

% Tlo ma kolor czarny
Im = uint8(zeros(Y, X));


% Punkty kontrolne litery
[outer_points, inner_points] = points(0);

outer_curve = curves(outer_points);
inner_curve = curves(inner_points);

Im = drawCurve(Im, outer_curve, 255);
Im = drawCurve(Im, inner_curve, 255);
y_mid = round((outer_points(18,2) + outer_points(8,2))/2); 
x_mid = round((outer_points(18,1) + outer_points(8,1))/2); 
Im = floodfill(Im, y_mid, x_mid, 0, 255);

imwrite(Im, 'czesc1.png');

figure(1);imshow(Im);
title('Litera P z dwoch krzywych b-sklejanych stopnia drugiego');


%% CZESC 2
%
% Kolorowa animacja modyfikująca wygląd litery P z pierwszej części.
%

video = VideoWriter('czesc2.avi');
video.FrameRate = 20;
open(video);

frames = 200;
for frame = 1:frames

    Im = uint8(zeros(Y, X));

    change = 25*sin(10*pi*(frame-1)/frames);

    [outer_points, inner_points] = points(change);

    outer_curve = curves(outer_points);
    inner_curve = curves(inner_points);

    Im = drawCurve(Im, outer_curve, 1);
    Im = drawCurve(Im, inner_curve, 1);

    R = 222; G = 184; B = 135;
    Im3D = uint8(zeros(Y, X, 3));
    Im3D(:,:,1) = floodfill(Im * R, 300, 250, 0, R);
    Im3D(:,:,2) = floodfill(Im * G, 300, 250, 0, G);
    Im3D(:,:,3) = floodfill(Im * B, 300, 250, 0, B);

    writeVideo(video, Im3D);
end

close(video);




%% FUNKCJE POMOCNICZE
%
%% FUNKCJE B-SPLINE KOLEJNYCH STOPNI
%
% T - wektor wspolrzednych M+1 wezlow pomiedzy 0 i 1 (T(1) = 0 i T(M+1) = 1)
% t - N-elementowy wektor reprezentujacy odcinek <0;1>, np. z krokiem 0.001
% poly0 tablica dyskretnej reprezentacja M "wielomianow" stopnia 0 
% wektorami o dlugosci takiej samej jak wektor t 
% kolejne kolumny poly0 reprezentuja kolejne "wielomiany" stopnia 0
function poly0 = bspline0(T,t,M)
    N = numel(t);
    poly0 = zeros(N,M);
    for j = 1:M
        for i = 1:N
            poly0(i,j) = (t(i)>=T(j) && t(i)<T(j+1));
        end
    end
end

% j.w. stopnia 1 i 2.

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

%% Funkcja gererujaca punkty kontrolne
function [outer, inner] = points(change)
% Litera jest zaprojektowana jako dwie zamkniete krzywe b-sklejane:
% - outer opisuje zewnetrzny kontur litery,
% - inner opisuje wewnetrzna dziure brzuszka litery P.  
    outer = [
        200 - change, 400; % 1 bottom left
        200 - change, 400; % 2 bottom left
        200 - change, 340; % 3
        200 - change, 285; % 4
        200 - change, 240; % 5
        200 - change, 190; % 6
        200 - change, 115; % 7
        200 - change, 80; % 8 top left
        200 - change, 80; % 9 top left
        300, 80; % 10
        430 + 2*change, 80; % 11
        500 + 2*change, 145; % 12
        500 + 2*change, 215; % 13
        430 + 2*change, 270; % 14
        330, 270; % 15 
        300, 270; % 16 mid inflection
        300, 270; % 17 mid inflection
        300, 400; % 18 bottom right
        300, 400; % 19 bottom right
        200 - change, 400  % 20 bottom left
    ];

    inner = [
        300, 210; % 1 bottom left
        300, 210; % 2 bottom left
        300, 140; % 3 top left
        300, 140; % 4 top left
        320, 140; % 5
        370 + change, 140; % 6
        400 + change, 160; % 7
        400 + change, 190; % 8
        370 + change, 210; % 9
        320, 210; % 10
        300, 210  % bottom left
    ];
end


%% Funkcja generujaca punkty krzywej b-sklejanej
% Funkcja wyznacza punkty zamknietej krzywej b-sklejanej stopnia drugiego
% na podstawie zadanych punktow kontrolnych.
%
% W celu uzyskania zamknietej krzywej do tablicy punktow kontrolnych
% dopisywane sa dwa pierwsze punkty. Nastepnie wyznaczane sa funkcje
% bazowe stopnia 0, 1 i 2, a na ich podstawie wspolrzedne punktow krzywej.
%
% Dodatkowo zastosowano normalizacje wag funkcji bazowych, co pozwala
% uniknac blednych punktow krzywej w poblizu (0,0).
function curve = curves(points)
    % points - punkty kontrolne [n x 2]
    % samples - liczba probek na calej krzywej

    % domkniecie krzywej dla stopnia 2
    points = [points; points(1:2,:)];

    n = size(points,1);      % liczba punktow kontrolnych uzytych w sumie
    M = n + 2;               % bo poly2 ma M-2 funkcji bazowych

    % jednostajny wektor wezlow w [0,1]
    T = linspace(0,1,M+1);

    % probkowanie parametru
    t = 0:0.00015:1;

    % baza stopnia 0,1,2
    B0 = bspline0(T,t,M);
    B1 = bspline1(T,t,M,B0);
    B2 = bspline2(T,t,M,B1);

    % normalizacja wierszy przez sumę wag aby wyeliminować linie do punktu (0,0)

    % suma wag w kazdym punkcie parametru
    s = sum(B2,2);

    % usuniecie wierszy zerowych / bardzo malych
    valid = s > 1e-12;
    B2 = B2(valid,:);
    s = s(valid);

    % normalizacja - to usuwa "ciagniecie" do (0,0)
    x = (B2 * points(:,1)) ./ s;
    y = (B2 * points(:,2)) ./ s;

    curve = [x y];
end

%% Funkcja rysujaca krzywa na obrazie
% Funkcja nanosi na obraz kolejne punkty wyznaczonej krzywej.
% Kazdy punkt krzywej jest zaokraglany do najblizszego piksela,
% a nastepnie zapisywany na obrazie zadanym kolorem.
function Im = drawCurve(Im, curve, color)
    % Im    - obraz wejsciowy
    % curve - tablica punktow krzywej [x y]
    % color - wartosc jasnosci / koloru rysowanego punktu
    n = size(curve,1);
    for k = 1:n
        x = round(curve(k,1));
        y = round(curve(k,2));

        if x >= 1 && x <= size(Im,2) && y >= 1 && y <= size(Im,1)
            Im(y,x) = color;
        end
    end
end


%% Funkcja wypelnia zamkniety obszar obrazu metoda floodfill.
function Im = floodfill(Im, y, x, T, color)
    % Im - obraz
    % (y,x) - punkt startowy
    % T - jasnosc do zamiany
    % color - nowy kolor

    [Y, X] = size(Im);

    % sprawdzenie zakresu
    if y < 1 || y > Y || x < 1 || x > X
        error('Punkt startowy (y,x) jest poza obrazem.');
    end

    % sprawdzenie jasnosci piksela startowego
    if Im(y,x) ~= T
        %disp('Piksel startowy ma zla jasnosc.'); 
        return;
        % w naszym kodzie oznacza to ze trafilismy na krawedz - a wiec trojkat jest obrocony do nas bokiem.
    end

    % jesli nowa jasnosc taka sama jak stara, nic nie trzeba robic
    if T == color
        return;
    end

    % kolejka pikseli do odwiedzenia
    Q = zeros(Y*X, 2);
    head = 1;
    tail = 1;

    Q(tail,:) = [y, x];
    Im(y,x) = color;

    while head <= tail
        cy = Q(head,1);
        cx = Q(head,2);
        head = head + 1;
        % gora
        ny = cy - 1;
        nx = cx;
        if ny >= 1 && Im(ny,nx) == T
            tail = tail + 1;
            Q(tail,:) = [ny, nx];
            Im(ny,nx) = color;
        end
        % dol
        ny = cy + 1;
        nx = cx;
        if ny <= Y && Im(ny,nx) == T
            tail = tail + 1;
            Q(tail,:) = [ny, nx];
            Im(ny,nx) = color;
        end
        % lewo
        ny = cy;
        nx = cx - 1;
        if nx >= 1 && Im(ny,nx) == T
            tail = tail + 1;
            Q(tail,:) = [ny, nx];
            Im(ny,nx) = color;
        end
        % prawo
        ny = cy;
        nx = cx + 1;
        if nx <= X && Im(ny,nx) == T
            tail = tail + 1;
            Q(tail,:) = [ny, nx];
            Im(ny,nx) = color;
        end
    end
end