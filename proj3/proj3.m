%% GRAFIKA KOMPUTEROWA - PROJEKT 3
% *Joanna Dagil 231008*
%
clear; close all; clc;
%
%% OPIS PROJEKTU
%
% Celem projektu jest wygenerowanie obrazow oraz animacji trzech trojkatow
% umieszczonych w przestrzeni 3D i rzutowanych rownolegle na plaszczyzne OXY.
% Trojkaty maja rozne wspolczynniki odbicia w skladowych RGB, dlatego kazdy
% z nich widoczny jest w innym kolorze. W projekcie nalezy uwzglednic
% oswietlenie tla, punktowe zrodlo swiatla, spadek natezenia wraz z
% odlegloscia, wzajemne zaslanianie sie trojkatow oraz rzucanie cieni.
%
% W czesci pierwszej generowane sa dwa statyczne obrazy sceny: pierwszy z
% wykorzystaniem modelu Lamberta, a drugi z wykorzystaniem modelu Phonga.
% W czesci drugiej generowane sa dwie animacje, rowniez dla modeli Lamberta
% i Phonga, w ktorych polozenie trojkatow pozostaje stale, natomiast zrodlo
% swiatla porusza sie po okregu zgodnie z rownaniami podanymi w tresci
% projektu.
%
% Obraz ma rozdzielczosc 640x480, a pojedynczy piksel odpowiada obszarowi
% 0.1x0.1 w ukladzie wspolrzednych matematycznych. Wynikiem dzialania kodu
% sa dwa pliki PNG z obrazami statycznymi oraz dwa pliki AVI z animacjami.
%
%% REALIZACJA PROJEKTU
%
% Rozwiazanie zostalo przygotowane w Matlabie, w stylu zgodnym z kodem z
% laboratorium 10. Punkty wierzcholkow trojkatow sa zapisane jako wektory
% jednorodne, natomiast samo rzutowanie wykonano rownolegle na plaszczyzne
% OXY. Oznacza to, ze do utworzenia obrazu wykorzystuje sie wspolrzedne x i
% y punktow, a wspolrzedna z sluzy do rozstrzygania widocznosci.
%
% Dla kazdego trojkata tworzona jest osobna maska binarna. Najpierw
% wspolrzedne matematyczne wierzcholkow sa zamieniane na wspolrzedne
% pikselowe funkcja mat_to_pix. Nastepnie krawedzie trojkata sa rysowane
% funkcja line, a jego wnetrze wypelniane funkcja floodfill. Dzieki masce
% wiadomo, ktore piksele obrazu naleza do danego trojkata.
%
% Dla kazdego piksela lezacego wewnatrz maski wyznaczany jest odpowiadajacy
% mu punkt na plaszczyznie trojkata. W tym celu obliczane jest rownanie
% plaszczyzny Ax+By+Cz+D=0 funkcja plane, a nastepnie punkt przeciecia
% prostej rownoleglej do osi OZ z ta plaszczyzna funkcja dist_to_plane.
% Wektor normalny do plaszczyzny jest normalizowany i ustawiany zgodnie z
% przyjeta konwencja obserwacji.
%
% W modelu Lamberta jasnosc punktu zalezy od kata pomiedzy normalna do
% powierzchni a wektorem skierowanym do zrodla swiatla. Uzywana jest tylko
% skladowa rozproszona, dlatego powierzchnie maja wyglad matowy. Natezenie
% swiatla punktowego jest dodatkowo tlumione wraz z odlegloscia zgodnie ze
% wzorem podanym w tresci zadania. Otrzymane natezenie RGB jest mnozone
% przez kolor bazowy danego trojkata.
%
% W modelu Phonga do skladowej rozproszonej dodawany jest efekt odbicia
% zwierciadlanego. Dla kazdego punktu obliczany jest wektor odbicia swiatla
% oraz wektor prowadzacy od punktu do oka obserwatora. Iloczyn skalarny tych
% wektorow, podniesiony do potegi m=15, odpowiada za widoczne rozblyski.
% Dzieki temu obraz z modelem Phonga powinien miec bardziej punktowe,
% blyszczace fragmenty niz obraz z modelem Lamberta.
%
% Cienie obliczane sa przez sprawdzenie, czy odcinek laczacy dany punkt
% trojkata ze zrodlem swiatla przecina inny trojkat. Jezeli przeciecie lezy
% pomiedzy punktem a lampa oraz znajduje sie wewnatrz maski drugiego
% trojkata, punkt uznawany jest za zacieniony i pozostaje oswietlony tylko
% skladowa tla.
%
% Widocznosc trojkatow jest rozstrzygana za pomoca z-bufora. Dla kazdego
% piksela porownywana jest odleglosc do plaszczyzn wszystkich trojkatow,
% ktorych maski obejmuja ten piksel. Do obrazu wynikowego trafia kolor tego
% trojkata, ktory znajduje sie najblizej kamery w przyjetym rzucie
% rownoleglym. Pozwala to poprawnie uwzglednic przecinanie i wzajemne
% zaslanianie trojkatow.
%
% W czesci animacyjnej geometria trojkatow jest stala, dlatego parametry ich
% plaszczyzn sa wyznaczane raz przed petla animacji. W kazdej klatce zmienia
% sie tylko polozenie zrodla swiatla: x(tk)=-5cos(tk), y(tk)=-5+5sin(tk),
% z(tk)=-28, gdzie tk=0.0315*k. Dla kazdej klatki ponownie wyznaczane sa
% oswietlenie, cienie i z-buffer, a gotowa klatka zapisywana jest do pliku
% AVI funkcja VideoWriter. Zeby ograniczyc niepotrzebne powtarzanie obliczen,
% stale elementy sceny, takie jak wspolrzedne trojkatow i rownania ich
% plaszczyzn, nie sa wyznaczane od nowa tam, gdzie nie jest to potrzebne.
%
%% UZYSKANE WYNIKI
%
% Program zapisuje cztery glowne wyniki:
%
% 1. proj3_lambert.png - statyczny obraz sceny w modelu Lamberta,
% 2. proj3_phong.png   - statyczny obraz sceny w modelu Phonga,
% 3. proj3_lambert.avi - animacja sceny z ruchomym zrodlem swiatla w modelu Lamberta,
% 4. proj3_phong.avi   - animacja sceny z ruchomym zrodlem swiatla w modelu Phonga.
%
% Na obrazie Lamberta powierzchnie trojkatow sa oswietlone w sposob
% rozproszony. Widoczne sa roznice jasnosci wynikajace z polozenia zrodla
% swiatla, orientacji powierzchni oraz tlumienia natezenia wraz z odlegloscia.
% Model ten nie tworzy wyraznych blyskow, dlatego efekt jest bardziej matowy.
%
% Na obrazie Phonga pojawia sie dodatkowa skladowa zwierciadlana zalezna od
% polozenia oka obserwatora i parametru m. Powoduje to powstanie jasniejszych
% fragmentow w miejscach, w ktorych kierunek odbicia swiatla jest zblizony do
% kierunku obserwacji.
%
% W animacjach trojkaty pozostaja nieruchome, natomiast zrodlo swiatla
% porusza sie po okregu. W kolejnych klatkach zmieniaja sie jasnosci
% powierzchni oraz polozenia obszarow zacienionych. Animacja Lamberta
% pokazuje zmiane oswietlenia rozproszonego, a animacja Phonga dodatkowo
% pokazuje przemieszczanie sie refleksow zwierciadlanych.
%
%% INSTRUKCJA URUCHOMIENIA
%
% 1. Otworzyc Matlab i ustawic jako Current Folder katalog zawierajacy plik
%    proj3.m.
% 2. Uruchomic skrypt poleceniem:
%
%       run('proj3.m')
%
%    albo nacisnac przycisk Run w edytorze Matlaba.
% 3. Program wygeneruje dwa okna z obrazami statycznymi oraz dwa pliki AVI
%    z animacjami. Pliki PNG i AVI zostana zapisane w aktualnym katalogu
%    roboczym Matlaba.
% 4. Pelna wersja animacji ma 200 klatek. Aby przygotowac krotki wariant
%    kontrolny wymagany do oceny, nalezy w czesci animacyjnej zmienic:
%       frames = 200;
%    na:
%       frames = 20;
%
% 5. Obliczenia moga trwac kilka minut, poniewaz oswietlenie, cienie i
%    z-buffer sa liczone piksel po pikselu dla kazdej klatki animacji.
%
%
%% OPIS PROBLEMU
%
% Dane sa trzy trojkaty A, B i C o współrzędnych:

% Trojkat A (zapisane od razu we wspolrzednych jednorodnych)
tri(1).A = [ -22;   0;  58; 1]; 
tri(1).B = [  11;  19;  58; 1];
tri(1).C = [   0;   0;  26; 1];

% Trojkat B
tri(2).A = [ -22;   0;  58; 1]; 
tri(2).B = [  11; -19;  58; 1];
tri(2).C = [   0;   0;  26; 1];

% Trojkat C
tri(3).A = [   3;  19;  48; 1]; 
tri(3).B = [   3; -19;  48; 1];
tri(3).C = [  -8;   0;  16; 1];

% Trójkąty są wizualizowane na obrazach/animacjach uzyskanych przez rzutowanie równoległe
% na płaszczyznę OXY. Każdy z trójkątów w inny sposób odbija oświetlenie kolorami bazowymi
% RGB (czyli ma efektywnie inny kolor):
tri(1).color = [1, 0.5, 0.25]; 
tri(2).color = [0.25, 1, 0.5];
tri(3).color = [0.25, 0.5, 1];

% Obraz otrzymany z kamery ma miec rozdzielczosc 
X = 640;
Y = 480;

% A rozmiar pixela to 
dx = 0.1;
dy = 0.1;

%
%% CZESC 1
%
% Trójkąty oświetlone są dość ciemnym światłem tła o natężeniu:
Iamb = [100,100,100];
%oraz punktowym źródłem bardzo jasnego światła o natężeniu i polozeniu:
Imax = [1000,1000,1000];
pmax = [ -5; -5; -28];
% Spadek natężenia oświetlenia w zależności od odległości opisany jest wzorem:
% Imax / (1 + 0.001 * ||p - pmax ||^2)

% Wygeneruj dwa obrazy przedstawiające te trójkąty:
%
% 1. Używając modelu oświetlenia Lamberta.
%
% 2. Używając modelu oświetlenia Phonga. 
% „Oko obserwatora” umieszczamy w punkcie
eye = [10; 5; 40];
% a współczynnik m równa się 15 (można również próbować innych wartości).
m = 15;
% W obrazach powinny być uwzględnione (jeśli występują) przecinania trójkątów 
% i ich wzajemne rzucanie cieni.

% Wspolczynnik odbicia, jak w lab10.
e = 1;



%% CZESC 1.1 - MODEL LAMBERTA

Im1 = uint8(zeros(Y,X,3));
Im2 = uint8(zeros(Y,X,3));
Im3 = uint8(zeros(Y,X,3));

[Im1, Ish1] = lambert(Im1, tri(1), Iamb, pmax, Imax, X, Y, dx, dy);
[Im2, Ish2] = lambert(Im2, tri(2), Iamb, pmax, Imax, X, Y, dx, dy);
[Im3, Ish3] = lambert(Im3, tri(3), Iamb, pmax, Imax, X, Y, dx, dy);

% Cienie
[A1, B1, C1, D1] = plane(tri(1).A, tri(1).B, tri(1).C);
n1 = [A1; B1; C1] / norm([A1; B1; C1]);
if n1(3) > 0
    n1 = -1 * n1;
end

[A2, B2, C2, D2] = plane(tri(2).A, tri(2).B, tri(2).C);
n2 = [A2; B2; C2] / norm([A2; B2; C2]);
if n2(3) > 0
    n2 = -1 * n2;
end

[A3, B3, C3, D3] = plane(tri(3).A, tri(3).B, tri(3).C);
n3 = [A3; B3; C3] / norm([A3; B3; C3]);
if n3(3) > 0
    n3 = -1 * n3;
end

Im1 = shadow(Im1, Ish1, Ish2, A1, B1, C1, D1, A2, B2, C2, D2, X, Y, dx, dy, pmax, Iamb, tri(1).color);
Im1 = shadow(Im1, Ish1, Ish3, A1, B1, C1, D1, A3, B3, C3, D3, X, Y, dx, dy, pmax, Iamb, tri(1).color);

Im2 = shadow(Im2, Ish2, Ish1, A2, B2, C2, D2, A1, B1, C1, D1, X, Y, dx, dy, pmax, Iamb, tri(2).color);
Im2 = shadow(Im2, Ish2, Ish3, A2, B2, C2, D2, A3, B3, C3, D3, X, Y, dx, dy, pmax, Iamb, tri(2).color);

Im3 = shadow(Im3, Ish3, Ish1, A3, B3, C3, D3, A1, B1, C1, D1, X, Y, dx, dy, pmax, Iamb, tri(3).color);
Im3 = shadow(Im3, Ish3, Ish2, A3, B3, C3, D3, A2, B2, C2, D2, X, Y, dx, dy, pmax, Iamb, tri(3).color);

% Z-buffer

Im = uint8(zeros(Y,X,3));
z_buffer = inf(Y,X);

for j = 1:Y
    for i = 1:X
        [xx,yy] = pix_to_mat(i, j, X, Y, dx, dy);
        if Ish1(j,i) == 255
            [d,~,~,~] = dist_to_plane([A1, B1, C1, D1], xx, yy, 0, 0, 0, 1);
            if d < z_buffer(j, i)
                z_buffer(j, i) = d;
                Im(j, i, :) = Im1(j, i, :);
            end
        end
        if Ish2(j,i) == 255
            [d,~,~,~] = dist_to_plane([A2, B2, C2, D2], xx, yy, 0, 0, 0, 1);
            if d < z_buffer(j, i)
                z_buffer(j, i) = d;
                Im(j, i, :) = Im2(j, i, :);
            end
        end
        if Ish3(j,i) == 255
            [d,~,~,~] = dist_to_plane([A3, B3, C3, D3], xx, yy, 0, 0, 0, 1);
            if d < z_buffer(j, i)
                z_buffer(j, i) = d;
                Im(j, i, :) = Im3(j, i, :);
            end
        end
    end
end

figure(1); imshow(Im); title('Model Lamberta');
imwrite(Im, 'proj3_lambert.png');



%% CZESC 1.2 - MODEL PHONGA

Im1 = uint8(zeros(Y,X,3));
Im2 = uint8(zeros(Y,X,3));
Im3 = uint8(zeros(Y,X,3));

[Im1, Ish1] = phong(Im1, tri(1), Iamb, pmax, Imax, X, Y, dx, dy, e, eye, m);
[Im2, Ish2] = phong(Im2, tri(2), Iamb, pmax, Imax, X, Y, dx, dy, e, eye, m);
[Im3, Ish3] = phong(Im3, tri(3), Iamb, pmax, Imax, X, Y, dx, dy, e, eye, m);

% Cienie
[A1, B1, C1, D1] = plane(tri(1).A, tri(1).B, tri(1).C);
n1 = [A1; B1; C1] / norm([A1; B1; C1]);
if n1(3) > 0
    n1 = -1 * n1;
end

[A2, B2, C2, D2] = plane(tri(2).A, tri(2).B, tri(2).C);
n2 = [A2; B2; C2] / norm([A2; B2; C2]);
if n2(3) > 0
    n2 = -1 * n2;
end

[A3, B3, C3, D3] = plane(tri(3).A, tri(3).B, tri(3).C);
n3 = [A3; B3; C3] / norm([A3; B3; C3]);
if n3(3) > 0
    n3 = -1 * n3;
end

Im1 = shadow(Im1, Ish1, Ish2, A1, B1, C1, D1, A2, B2, C2, D2, X, Y, dx, dy, pmax, Iamb, tri(1).color);
Im1 = shadow(Im1, Ish1, Ish3, A1, B1, C1, D1, A3, B3, C3, D3, X, Y, dx, dy, pmax, Iamb, tri(1).color);

Im2 = shadow(Im2, Ish2, Ish1, A2, B2, C2, D2, A1, B1, C1, D1, X, Y, dx, dy, pmax, Iamb, tri(2).color);
Im2 = shadow(Im2, Ish2, Ish3, A2, B2, C2, D2, A3, B3, C3, D3, X, Y, dx, dy, pmax, Iamb, tri(2).color);

Im3 = shadow(Im3, Ish3, Ish1, A3, B3, C3, D3, A1, B1, C1, D1, X, Y, dx, dy, pmax, Iamb, tri(3).color);
Im3 = shadow(Im3, Ish3, Ish2, A3, B3, C3, D3, A2, B2, C2, D2, X, Y, dx, dy, pmax, Iamb, tri(3).color);

% Z-buffer

Im = uint8(zeros(Y,X,3));
z_buffer = inf(Y,X);

for j = 1:Y
    for i = 1:X
        [xx,yy] = pix_to_mat(i, j, X, Y, dx, dy);
        if Ish1(j,i) == 255
            [d,~,~,~] = dist_to_plane([A1, B1, C1, D1], xx, yy, 0, 0, 0, 1);
            if d < z_buffer(j, i)
                z_buffer(j, i) = d;
                Im(j, i, :) = Im1(j, i, :);
            end
        end
        if Ish2(j,i) == 255
            [d,~,~,~] = dist_to_plane([A2, B2, C2, D2], xx, yy, 0, 0, 0, 1);
            if d < z_buffer(j, i)
                z_buffer(j, i) = d;
                Im(j, i, :) = Im2(j, i, :);
            end
        end
        if Ish3(j,i) == 255
            [d,~,~,~] = dist_to_plane([A3, B3, C3, D3], xx, yy, 0, 0, 0, 1);
            if d < z_buffer(j, i)
                z_buffer(j, i) = d;
                Im(j, i, :) = Im3(j, i, :);
            end
        end
    end
end

figure(2); imshow(Im); title('Model Phonga');
imwrite(Im, 'proj3_phong.png');


%
%% CZESC 2
%
% Używając tych samych parametrów oświetlenia jak w Części I, wygeneruj dwie krótkie 
% (ale nie mniej niż 200 klatek) cyfrową animację przedstawiającą konfigurację 
% tych trójkątów oświetlaną ruchomym źródłem światła .
% Źródło światła porusza się po okręgu o (zdyskretyzowanym) parametrycznym równaniu:
% x(tk) = -5cos(tk)
% y(tk) = -5 + 5sin(tk)
% z(tk) = -28
% gdzie tk = 0.0315k (k jest numerem klatki)
%
% 1. W pierwszej animacji użyj modelu oświetlenia Lamberta
%
% 2. W drugiej animacji użyj modelu oświetlenia Phonga (parametry jak w Części I).
%
% UWAGA: W powyższym równaniu parametr tk podany jest w radianach!
%
%% CZESC 2.1 - ANIMACJA, MODEL LAMBERTA

frames = 200;

v1 = VideoWriter('proj3_lambert.avi');
v1.FrameRate = 20;
open(v1);

% Parametry plaszczyzn trojkatow sa stale, bo trojkaty sie nie ruszaja.
[A1, B1, C1, D1] = plane(tri(1).A, tri(1).B, tri(1).C);
[A2, B2, C2, D2] = plane(tri(2).A, tri(2).B, tri(2).C);
[A3, B3, C3, D3] = plane(tri(3).A, tri(3).B, tri(3).C);

for k = 0:frames-1
    fprintf('Generowanie klatki Lamberta %d/%d...\n', k+1, frames);

    tk = 0.0315 * k;
    lamp = [-5*cos(tk); -5 + 5*sin(tk); -28];

    Im1 = uint8(zeros(Y,X,3));
    Im2 = uint8(zeros(Y,X,3));
    Im3 = uint8(zeros(Y,X,3));

    [Im1, Ish1] = lambert(Im1, tri(1), Iamb, lamp, Imax, X, Y, dx, dy);
    [Im2, Ish2] = lambert(Im2, tri(2), Iamb, lamp, Imax, X, Y, dx, dy);
    [Im3, Ish3] = lambert(Im3, tri(3), Iamb, lamp, Imax, X, Y, dx, dy);

    % Cienie
    Im1 = shadow(Im1, Ish1, Ish2, A1, B1, C1, D1, A2, B2, C2, D2, X, Y, dx, dy, lamp, Iamb, tri(1).color);
    Im1 = shadow(Im1, Ish1, Ish3, A1, B1, C1, D1, A3, B3, C3, D3, X, Y, dx, dy, lamp, Iamb, tri(1).color);

    Im2 = shadow(Im2, Ish2, Ish1, A2, B2, C2, D2, A1, B1, C1, D1, X, Y, dx, dy, lamp, Iamb, tri(2).color);
    Im2 = shadow(Im2, Ish2, Ish3, A2, B2, C2, D2, A3, B3, C3, D3, X, Y, dx, dy, lamp, Iamb, tri(2).color);

    Im3 = shadow(Im3, Ish3, Ish1, A3, B3, C3, D3, A1, B1, C1, D1, X, Y, dx, dy, lamp, Iamb, tri(3).color);
    Im3 = shadow(Im3, Ish3, Ish2, A3, B3, C3, D3, A2, B2, C2, D2, X, Y, dx, dy, lamp, Iamb, tri(3).color);

    % Z-buffer
    Im = uint8(zeros(Y,X,3));
    z_buffer = inf(Y,X);

    for j = 1:Y
        for i = 1:X
            [xx,yy] = pix_to_mat(i, j, X, Y, dx, dy);

            if Ish1(j,i) == 255
                [d,~,~,~] = dist_to_plane([A1, B1, C1, D1], xx, yy, 0, 0, 0, 1);
                if d < z_buffer(j, i)
                    z_buffer(j, i) = d;
                    Im(j, i, :) = Im1(j, i, :);
                end
            end

            if Ish2(j,i) == 255
                [d,~,~,~] = dist_to_plane([A2, B2, C2, D2], xx, yy, 0, 0, 0, 1);
                if d < z_buffer(j, i)
                    z_buffer(j, i) = d;
                    Im(j, i, :) = Im2(j, i, :);
                end
            end

            if Ish3(j,i) == 255
                [d,~,~,~] = dist_to_plane([A3, B3, C3, D3], xx, yy, 0, 0, 0, 1);
                if d < z_buffer(j, i)
                    z_buffer(j, i) = d;
                    Im(j, i, :) = Im3(j, i, :);
                end
            end
        end
    end

    figure(3);
    imshow(Im);
    title('Animacja - model Lamberta');
    drawnow;

    frame = getframe(gcf);
    writeVideo(v1, frame);
end

close(v1);



%% CZESC 2.2 - ANIMACJA, MODEL PHONGA

v2 = VideoWriter('proj3_phong.avi');
v2.FrameRate = 20;
open(v2);

for k = 0:frames-1
    fprintf('Generowanie klatki Phonga %d/%d...\n', k+1, frames);

    tk = 0.0315 * k;
    lamp = [-5*cos(tk); -5 + 5*sin(tk); -28];

    Im1 = uint8(zeros(Y,X,3));
    Im2 = uint8(zeros(Y,X,3));
    Im3 = uint8(zeros(Y,X,3));

    [Im1, Ish1] = phong(Im1, tri(1), Iamb, lamp, Imax, X, Y, dx, dy, e, eye, m);
    [Im2, Ish2] = phong(Im2, tri(2), Iamb, lamp, Imax, X, Y, dx, dy, e, eye, m);
    [Im3, Ish3] = phong(Im3, tri(3), Iamb, lamp, Imax, X, Y, dx, dy, e, eye, m);

    % Cienie
    Im1 = shadow(Im1, Ish1, Ish2, A1, B1, C1, D1, A2, B2, C2, D2, X, Y, dx, dy, lamp, Iamb, tri(1).color);
    Im1 = shadow(Im1, Ish1, Ish3, A1, B1, C1, D1, A3, B3, C3, D3, X, Y, dx, dy, lamp, Iamb, tri(1).color);

    Im2 = shadow(Im2, Ish2, Ish1, A2, B2, C2, D2, A1, B1, C1, D1, X, Y, dx, dy, lamp, Iamb, tri(2).color);
    Im2 = shadow(Im2, Ish2, Ish3, A2, B2, C2, D2, A3, B3, C3, D3, X, Y, dx, dy, lamp, Iamb, tri(2).color);

    Im3 = shadow(Im3, Ish3, Ish1, A3, B3, C3, D3, A1, B1, C1, D1, X, Y, dx, dy, lamp, Iamb, tri(3).color);
    Im3 = shadow(Im3, Ish3, Ish2, A3, B3, C3, D3, A2, B2, C2, D2, X, Y, dx, dy, lamp, Iamb, tri(3).color);

    % Z-buffer
    Im = uint8(zeros(Y,X,3));
    z_buffer = inf(Y,X);

    for j = 1:Y
        for i = 1:X
            [xx,yy] = pix_to_mat(i, j, X, Y, dx, dy);

            if Ish1(j,i) == 255
                [d,~,~,~] = dist_to_plane([A1, B1, C1, D1], xx, yy, 0, 0, 0, 1);
                if d < z_buffer(j, i)
                    z_buffer(j, i) = d;
                    Im(j, i, :) = Im1(j, i, :);
                end
            end

            if Ish2(j,i) == 255
                [d,~,~,~] = dist_to_plane([A2, B2, C2, D2], xx, yy, 0, 0, 0, 1);
                if d < z_buffer(j, i)
                    z_buffer(j, i) = d;
                    Im(j, i, :) = Im2(j, i, :);
                end
            end

            if Ish3(j,i) == 255
                [d,~,~,~] = dist_to_plane([A3, B3, C3, D3], xx, yy, 0, 0, 0, 1);
                if d < z_buffer(j, i)
                    z_buffer(j, i) = d;
                    Im(j, i, :) = Im3(j, i, :);
                end
            end
        end
    end

    figure(4);
    imshow(Im);
    title('Animacja - model Phonga');
    drawnow;

    frame = getframe(gcf);
    writeVideo(v2, frame);
end

close(v2);







%% FUNKCJE POMOCNICZE

%% SHADOW

function Im = shadow(Im,Ish1,Ish2,A1,B1,C1,D1,A2,B2,C2,D2,X,Y,dx,dy,lamp,amb,color)
    for i = 1:X
        for j = 1:Y
            if Ish1(j,i)==255
                % sprawdzanie rzucania cienia
                [xx,yy] = pix_to_mat(i,j,X,Y,dx,dy);
                [~, x, y, z] = dist_to_plane([A1, B1, C1, D1],xx,yy,0,0,0,1);
                l1 = lamp-[x;y;z];
                dist1 = norm(l1);
                [d2, x2, y2, z2] = dist_to_plane([A2, B2, C2, D2],x,y,z,l1(1),l1(2),l1(3));
                if norm([x2;y2;z2]-lamp)<dist1 && d2<dist1
                    [i2, j2] = mat_to_pix(x2,y2,X,Y,dx,dy);
                    if i2>0 && j2>0 && i2<X+1 && j2<Y+1 && Ish2(j2,i2)==255
                        RGB = color .* amb;
                        RGB = min(max(RGB, 0), 255);
                        Im(j,i,:) = reshape(uint8(RGB), 1, 1, 3);
                    end
                end
            end
        end
    end
end

%% LAMBERT

function [Im, Ish] = lambert(Im, triangle, amb, lamp, int, X, Y, dx, dy)
    Ish = uint8(zeros(Y,X)); % pomocniczy obraz zawierający biały trójkąt

    [i1,j1] = mat_to_pix(triangle.A(1), triangle.A(2), X, Y, dx, dy);
    [i2,j2] = mat_to_pix(triangle.B(1), triangle.B(2), X, Y, dx, dy);
    [i3,j3] = mat_to_pix(triangle.C(1), triangle.C(2), X, Y, dx, dy);

    Ish = line(Ish, j1, i1, j2, i2, dx, dy, 255);
    Ish = line(Ish, j2, i2, j3, i3, dx, dy, 255);
    Ish = line(Ish, j3, i3, j1, i1, dx, dy, 255);

    Ish = floodfill(Ish, round((j1+j2+j3)/3), round((i1+i2+i3)/3), 0, 255); % wypełnienie trójkąta białym kolorem


    [A, B, C, D] = plane(triangle.A, triangle.B, triangle.C); % Wyznaczenie parametrów płaszczyzny trójkąta
    n = [A; B; C] / norm([A; B; C]); % Normalizacja wektora normalnego
    if n(3) > 0 
        n = -1*n; 
    end % Obrócenie normalnej, jeśli jest skierowana w dół

    for i = 1:X
        for j = 1:Y
            if Ish(j,i) == 255 % Sprawdzenie, czy piksel jest wewnątrz trójkąta
                [xx,yy] = pix_to_mat(i, j, X, Y, dx, dy); % Zamiana współrzędnych pikselowych na matematyczne
                [~, x, y, z] = dist_to_plane([A,B,C,D], xx, yy, 0, 0, 0, 1); % Wyznaczenie punktu na płaszczyźnie trójkąta
                l = lamp - [x; y; z]; % Wektor od punktu na trójkącie do lampy
                dist = norm(l); % Odległość od lampy
                l = l / dist; % Normalizacja wektora l
                cs = n'* l; 
                if cs < 0 
                    cs = 0; 
                end % Obliczenie cosinusa kąta między normalną a wektorem do lampy
                temp = amb + int * cs / (1 + 0.001 * dist^2); % Obliczenie natężenia oświetlenia z uwzględnieniem tłumienia
                RGB = triangle.color .* temp;
                RGB = min(max(RGB, 0), 255);
                Im(j, i, :) = reshape(uint8(RGB), 1, 1, 3); % Ustawienie koloru dla pikseli wewnątrz trójkąta
            end
        end
    end
end


%% PHONG

function [Im, Ish] = phong(Im, triangle, amb, lamp, int, X, Y, dx, dy, e, eye, m)
    Ish = uint8(zeros(Y,X)); % pomocniczy obraz zawierający biały trójkąt

    [i1,j1] = mat_to_pix(triangle.A(1), triangle.A(2), X, Y, dx, dy);
    [i2,j2] = mat_to_pix(triangle.B(1), triangle.B(2), X, Y, dx, dy);
    [i3,j3] = mat_to_pix(triangle.C(1), triangle.C(2), X, Y, dx, dy);

    Ish = line(Ish, j1, i1, j2, i2, dx, dy, 255);
    Ish = line(Ish, j2, i2, j3, i3, dx, dy, 255);
    Ish = line(Ish, j3, i3, j1, i1, dx, dy, 255);

    Ish = floodfill(Ish, round((j1+j2+j3)/3), round((i1+i2+i3)/3), 0, 255); % wypełnienie trójkąta białym kolorem
    
    [A, B, C, D] = plane(triangle.A, triangle.B, triangle.C); % Wyznaczenie parametrów płaszczyzny trójkąta
    n = [A; B; C] / norm([A; B; C]); % Normalizacja wektora normalnego
    if n(3) > 0 
        n = -1*n; 
    end % Obrócenie normalnej, jeśli jest skierowana w dół

    for i = 1:X
        for j = 1:Y
            if Ish(j,i) == 255 % Sprawdzenie, czy piksel jest wewnątrz trójkąta
                [xx,yy] = pix_to_mat(i, j, X, Y, dx, dy); % Zamiana współrzędnych pikselowych na matematyczne
                [~, x, y, z] = dist_to_plane([A,B,C,D], xx, yy, 0, 0, 0, 1); % Wyznaczenie punktu na płaszczyźnie trójkąta
                l = lamp - [x; y; z]; % Wektor od punktu na trójkącie do lampy
                dist = norm(l); % Odległość od lampy
                l = l / dist; % Normalizacja wektora l
                cs = n'* l; 
                if cs < 0 
                    cs = 0; 
                end % Obliczenie cosinusa kąta między normalną a wektorem do lampy
                
                rp = 2 * (n'* l) * n - l; % Wektor odbicia
                rp = rp / norm(rp); % Normalizacja wektora odbicia
                vp = eye - [x; y; z]; % Wektor od punktu na trójkącie do oka
                vp = vp / norm(vp); % Normalizacja wektora do oka
                cs2 = rp'* vp; 
                if cs2 < 0 
                    cs2 = 0; 
                end % Obliczenie cosinusa kąta między wektorem odbicia a wektorem do oka
                
                temp = amb + int * cs * e * (1 + (cs2^m)) / (1 + 0.001 * dist^2); % Obliczenie natężenia oświetlenia z uwzględnieniem tłumienia
                RGB = triangle.color .* temp;
                RGB = min(max(RGB, 0), 255);
                Im(j, i, :) = reshape(uint8(RGB), 1, 1, 3); % Ustawienie koloru dla pikseli wewnątrz trójkąta
            end
        end
    end
end






%% Funkcja do zamiany wspolrzednych matematycznych na pikselowe i odwrotnie
% x, y - współrzędne
% M, N - szerokość i wysokość obrazu
% dx, dy - rozmiar pojedynczego piksela

function [i,j] = mat_to_pix(x, y, M, N, dx, dy)
    T = [1/dx, 0,    M/2;
         0,   -1/dy, N/2;
         0,    0,    1];
    temp = [x; y; 1];
    res = T * temp;
    i = round(res(1)/res(3));
    j = round(res(2)/res(3));
end

function [i,j] = pix_to_mat(x, y, M, N, dx, dy)
    T = [dx,  0, -M*dx/2;
         0,  -dy, N*dy/2;
         0,   0,  1];
    res = T * [x; y; 1];
    i = res(1)/res(3);
    j = res(2)/res(3);
end

%% Funkcja rysuje odcinek na obrazie monochromatycznym.
function Im = line(Im, ya, xa, yb, xb, dx, dy, color)
    % Im - obraz
    % (xa, ya) - punkt poczatkowy
    % (xb, yb) - punkt koncowy
    % color - kolor linii

    [Y, X] = size(Im);

    if (abs(yb-ya) > abs(xb-xa))          % stroma linia     
        % zamiana wspolrzednych                           
        x0 = ya; 
        y0 = xa; 
        x1 = yb;
        y1 = xb;  

        % zamiana rozmiarow X i Y
        temp = X; X = Y; Y = temp;

        zamiana = 1;                                             
    else
        x0 = xa;
        y0 = ya; 
        x1 = xb;
        y1 = yb;

        zamiana = 0; 
    end

    % zamiana poczatku i konca linii, zeby zaczynac od lewej
    if(x0 > x1) 
        temp1 = x0; x0 = x1; x1 = temp1;
        temp2 = y0; y0 = y1; y1 = temp2;
    end

    dx = abs(x1 - x0) ;                % odleglosc x
    dy = abs(y1 - y0);                 % odleglosc y
    sy = sign(y1 - y0);                % znak przyrostu w kierunku y

    x = x0; y = y0;                    % inicjalizacja
    if x > 0 && x <= X && y > 0 && y <= Y  
        if (zamiana == 0)                                
            Im(y,x) = color;           % rysowanie punktu
        else 
            Im(x,y) = color;
        end
    end

    error = 2*dy - dx ;                % inicjalizacja bledu
    for i = 0:dx-1    

        error = error + 2*dy;          % modyfikacja bledu
        if (error > 0)                                
            y = y + sy;                             
            error = error - 2*dx;                      
        end

        x = x + 1;                     % zwiekszamy x
        if x > 0 && x <= X && y > 0 && y <= Y  
            if (zamiana == 0)                                
                Im(y,x) = color;          % rysowanie punktu
            else                                         
                Im(x,y) = color;
            end
        end
    end
end


%% Funkcja do wyznaczania parametrow plaszczyzny Ax+By+Cz+D=0 przechodzacej przez trzy punkty p1,p2,p3
function [A, B, C, D] = plane(p1,p2,p3)
    A = det([p1(2),p1(3),1;
             p2(2),p2(3),1;
             p3(2),p3(3),1]);
    B = -det([p1(1),p1(3),1;
              p2(1),p2(3),1;
              p3(1),p3(3),1]);
    C = det([p1(1),p1(2),1;
             p2(1),p2(2),1;
             p3(1),p3(2),1]);
    D = -det([p1(1),p1(2),p1(3);
              p2(1),p2(2),p2(3);
              p3(1),p3(2),p3(3)]);
end

%% Funkcja do wyznaczania odleglosci punktu [x,y,z] od plaszczyzny o rownaniu Ax+By+Cz+D=0
% odleglosc mierzona jest wzdluz prostej o wektorze kierunkowym [l,m,n]
% zwraca rowniez punkt przeciecia z plaszczyzna

function [d,x1,y1,z1] = dist_to_plane(plane, x, y, z, l, m, n)
    ro = (plane(1)*x+plane(2)*y+plane(3)*z+plane(4))/(plane(1)*l+plane(2)*m+plane(3)*n);
    x1 = x-l*ro; y1 = y-m*ro; z1 = z-n*ro;
    d = sqrt((x-x1)^2+(y-y1)^2+(z-z1)^2);
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
        % w naszym kodzie oznacza to że trafiliśmy na krawędź - a więc trójkąt jest obrucony do nas bokiem.
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

        % 4-sasiedztwo: gora, dol, lewo, prawo

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






