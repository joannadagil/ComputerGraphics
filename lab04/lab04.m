%% GRAFIKA KOMPUTEROWA LAB_4
% *Joanna Dagil 231008*

%% 1. CEL CWICZENIA
% Zapoznanie sie transformacjami geometrycznymi obrazów 3D i ich wypełnianiem

%% 2. ZADANIA

%% 2.1 Obrót  i przesuniecie trójkąta w przestrzeni 3D.

% Funkcja do zamiany współrzędnych matematycznych na pikselowe z poprzednich laboratoriów

function [i,j] = mat_to_pix(x, y, M, N, dx, dy)
    T = [1/dx, 0,    M/2;
         0,   -1/dy, N/2;
         0,    0,    1];
    temp = [x; y; 1];
    res = T * temp;
    i = round(res(1)/res(3));
    j = round(res(2)/res(3));
end

% Funkcja do tworzenia macierzy transformacji dla obrotu i przesunięcia w przestrzeni 3D

function Hmat =  RPYT(roll,pitch,yaw,px,py,pz)
r = roll*pi/180; p = pitch*pi/180; y = yaw*pi/180;
MR = [cos(r), -sin(r), 0; 
      sin(r), cos(r), 0; 
      0, 0, 1];
MP = [cos(p), 0, sin(p); 
      0, 1, 0; 
      -sin(p), 0, cos(p)];
MY = [1, 0, 0;
      0, cos(y), -sin(y); 
      0, sin(y), cos(y)];
Rot = MY*MP*MR;
Hmat = zeros(4,4);
Hmat(1:3,1:3)=Rot;
Hmat(1,4)=px; Hmat(2,4)=py; Hmat(3,4)=pz;
Hmat(4,4)=1;
end

% Funkcja do tworzenia macierzy transformacji dla rzutu perspektywicznego

function H =  Persp(f)
% zwraca macierz jednorodna tranformacji rzutu perspektywicznego
% z uzyciem kamery o osi OZ i o ogniskowej f (konwencja jak na wykladzie) 
H = zeros(4,4);
H(1,1)=1; H(2,2)=1;
H(4,3)=-1/f; H(4,4)=1;
end


% Funkcja do rysowania linii na obrazie monochromatycznym

function Im2 =  linia1(Im1,yp,xp,yk,xk,C)
% na monochromatycznym obrazie kresli linie o jasnosci C  
% od punktu (yp,xp) do punktu (yk, xk)
[Y, X] = size(Im1);
Im2 = Im1;

if (abs(yk-yp) > abs(xk-xp))          % stroma linia                                
    x0 = yp;y0 = xp; x1 = yk;y1 = xk; % zamiana wspolrzednych 
    zamiana =1;                                             
else
    x0 = xp;y0 = yp; x1 = xk;y1 = yk;
    zamiana = 0; 
end
if zamiana==1 temp=X; X=Y; Y=temp; end % zamiana rozmiarow X i Y
if(x0 >x1) % zamiana poczatku i konca linii, zeby zaczynac od lewej
    temp1 = x0; x0 = x1; x1 = temp1;
    temp2 = y0; y0 = y1; y1 = temp2;
end
dx = abs(x1 - x0) ;                % odleglosc x
dy = abs(y1 - y0);                 % odleglosc y
sy = sign(y1 - y0);                % znak przyrostu w kierunku y
x = x0; y = y0;                    % inicjalizacja
if x>0 && x<=X && y>0 && y<=Y  
if (zamiana ==0)                                
        Im2(y,x) = C;               % rysowanie punktu
else 
        Im2(x,y) = C;
end
end
error = 2*dy - dx ;                              % inicjalizacja bledu
for i = 0:dx-1                                   
    error = error + 2*dy;                        % modyfikacja bledu
    if (error >0)                                
        y = y +sy;                             
        error = error - 2*dx;                      
    end
    x = x + 1;                                % zwiekszamy x
  if x>0 && x<=X && y>0 && y<=Y  
    if (zamiana ==0)                                
        Im2(y,x) = C;                % rysowanie punktu
    else                                         
        Im2(x,y) = C;
    end
  end
end
end







% pierwotny trójkąt
p1 = [0;0;0;1];
p2 = [1;0;0;1];
p3 = [0;1;0;1];

% pierwsza transformacja, rzut równoległy
H1 = RPYT(30,30,10,0.5,0.3,1.9);
p11 = H1*p1; 
p12 = H1*p2; 
p13 = H1*p3;

% druga transformacja, rzut równoległy
H2 = RPYT(-30,-30,-10,0.3,0.5,2);
p21 = H2*p1; 
p22 = H2*p2; 
p23 = H2*p3;
HHH = Persp(1);

% pierwsza transformacja, rzut perspektywiczny
rp11 = HHH*p11; rp11 = rp11/rp11(4);
rp12 = HHH*p12; rp12 = rp12/rp12(4);
rp13 = HHH*p13; rp13 = rp13/rp13(4);

% druga transformacja, rzut perspektywiczny
rp21 = HHH*p21; rp21 = rp21/rp21(4);
rp22 = HHH*p22; rp22 = rp22/rp22(4);
rp23 = HHH*p23; rp23 = rp23/rp23(4);


Imm1 = uint8(zeros(400,400)); Imm2 = Imm1;
[x11,y11] = mat_to_pix(p11(1),p11(2),400,400,0.01,0.01);
[x12,y12] = mat_to_pix(p12(1),p12(2),400,400,0.01,0.01);
[x13,y13] = mat_to_pix(p13(1),p13(2),400,400,0.01,0.01);
Imm1 = linia1(Imm1,y11,x11,y12,x12,200);
Imm1 = linia1(Imm1,y12,x12,y13,x13,200);
Imm1 = linia1(Imm1,y13,x13,y11,x11,200);

Imm2 = uint8(zeros(400,400));
[x21,y21] = mat_to_pix(p21(1),p21(2),400,400,0.01,0.01);
[x22,y22] = mat_to_pix(p22(1),p22(2),400,400,0.01,0.01);
[x23,y23] = mat_to_pix(p23(1),p23(2),400,400,0.01,0.01);
Imm2 = linia1(Imm2,y21,x21,y22,x22,200);
Imm2 = linia1(Imm2,y22,x22,y23,x23,200);
Imm2 = linia1(Imm2,y23,x23,y21,x21,200);

Imm3 = uint8(zeros(400,400));
[x31,y31] = mat_to_pix(rp11(1), rp11(2), 400, 400, 0.01, 0.01);
[x32,y32] = mat_to_pix(rp12(1), rp12(2), 400, 400, 0.01, 0.01);
[x33,y33] = mat_to_pix(rp13(1), rp13(2), 400, 400, 0.01, 0.01);
Imm3 = linia1(Imm3,y31,x31,y32,x32,200);
Imm3 = linia1(Imm3,y32,x32,y33,x33,200);
Imm3 = linia1(Imm3,y33,x33,y31,x31,200);

Imm4 = uint8(zeros(400,400));
[x41,y41] = mat_to_pix(rp21(1), rp21(2), 400, 400, 0.01, 0.01);
[x42,y42] = mat_to_pix(rp22(1), rp22(2), 400, 400, 0.01, 0.01);
[x43,y43] = mat_to_pix(rp23(1), rp23(2), 400, 400, 0.01, 0.01);
Imm4 = linia1(Imm4,y41,x41,y42,x42,200);
Imm4 = linia1(Imm4,y42,x42,y43,x43,200);
Imm4 = linia1(Imm4,y43,x43,y41,x41,200);

figure(11); imshow(Imm1); title('T1 - rzut równoległy');
figure(12); imshow(Imm2); title('T2 - rzut równoległy');
figure(13); imshow(Imm3); title('T1 - rzut perspektywiczny');
figure(14); imshow(Imm4); title('T2 - rzut perspektywiczny');








%% 2.2 Funkcja do wypełniania obszarów metodą flood fill.

function Im2 = floodfill1(Im, y, x, T, C)
    [H, W] = size(Im);

    % sprawdzenie zakresu
    if y < 1 || y > H || x < 1 || x > W
        error('Punkt startowy (y,x) jest poza obrazem.');
    end

    % sprawdzenie jasnosci piksela startowego
    if Im(y,x) ~= T
        error('Piksel startowy (%d,%d) ma jasnosc %d zamiast T=%d.', ...
              y, x, Im(y,x), T);
    end

    % jesli nowa jasnosc taka sama jak stara, nic nie trzeba robic
    if T == C
        Im2 = Im;
        return;
    end

    Im2 = Im;

    % kolejka pikseli do odwiedzenia
    Q = zeros(H*W, 2);
    head = 1;
    tail = 1;

    Q(tail,:) = [y, x];
    Im2(y,x) = C;

    while head <= tail
        cy = Q(head,1);
        cx = Q(head,2);
        head = head + 1;

        % 4-sasiedztwo: gora, dol, lewo, prawo

        % gora
        ny = cy - 1;
        nx = cx;
        if ny >= 1 && Im2(ny,nx) == T
            tail = tail + 1;
            Q(tail,:) = [ny, nx];
            Im2(ny,nx) = C;
        end

        % dol
        ny = cy + 1;
        nx = cx;
        if ny <= H && Im2(ny,nx) == T
            tail = tail + 1;
            Q(tail,:) = [ny, nx];
            Im2(ny,nx) = C;
        end

        % lewo
        ny = cy;
        nx = cx - 1;
        if nx >= 1 && Im2(ny,nx) == T
            tail = tail + 1;
            Q(tail,:) = [ny, nx];
            Im2(ny,nx) = C;
        end

        % prawo
        ny = cy;
        nx = cx + 1;
        if nx <= W && Im2(ny,nx) == T
            tail = tail + 1;
            Q(tail,:) = [ny, nx];
            Im2(ny,nx) = C;
        end
    end
end

BW = imread('BW.bmp');
if ndims(BW) == 3
    BW = rgb2gray(BW);
end
BW = uint8(BW);

% 1. Wypelnienie czarnego obszaru w lewym gornym rogu
Im1 = floodfill1(BW, 20, 20, 0, 128);

% 2. Wypelnienie duzego czarnego obszaru w srodku
Im2 = floodfill1(BW, 80, 120, 0, 180);

% 3. Wypelnienie bialego tla
Im3 = floodfill1(BW, 10, 200, 255, 100);

% 4. Wypelnienie dolnego czarnego obszaru
Im4 = floodfill1(BW, 280, 300, 0, 200);

figure(21); imshow(BW);  title('Oryginal');
figure(22); imshow(Im1); title('Czarny obszar: (20,20)');
figure(23); imshow(Im2); title('Czarny obszar: (80,120)');
figure(24); imshow(Im3); title('Biale tlo: (10,200)');
figure(25); imshow(Im4); title('Dolny czarny obszar: (280,300)');

%% 2.3 Wypełnianie trójkątów z zadania 1.

% użyję środka trójkąta jako punktu startowego do wypełnienia

% Kopie obrazów z konturami z zadania 1
Fill1 = Imm1;
Fill2 = Imm2;
Fill3 = Imm3;
Fill4 = Imm4;

% --- trójkąt 1: transformacja 1, rzut równoległy
xs1 = round((x11 + x12 + x13)/3);
ys1 = round((y11 + y12 + y13)/3);
Fill1 = floodfill1(Fill1, ys1, xs1, 0, 200);

% --- trójkąt 2: transformacja 2, rzut równoległy
xs2 = round((x21 + x22 + x23)/3);
ys2 = round((y21 + y22 + y23)/3);
Fill2 = floodfill1(Fill2, ys2, xs2, 0, 200);

% --- trójkąt 3: transformacja 1, rzut perspektywiczny
xs3 = round((x31 + x32 + x33)/3);
ys3 = round((y31 + y32 + y33)/3);
Fill3 = floodfill1(Fill3, ys3, xs3, 0, 200);

% --- trójkąt 4: transformacja 2, rzut perspektywiczny
xs4 = round((x41 + x42 + x43)/3);
ys4 = round((y41 + y42 + y43)/3);
Fill4 = floodfill1(Fill4, ys4, xs4, 0, 200);

% Wyświetlenie wyników
figure(31); imshow(Fill1); title('T1 - rzut równoległy, wypełniony');
figure(32); imshow(Fill2); title('T2 - rzut równoległy, wypełniony');
figure(33); imshow(Fill3); title('T1 - rzut perspektywiczny, wypełniony');
figure(34); imshow(Fill4); title('T2 - rzut perspektywiczny, wypełniony');

%% Typowy koniec skryptu

% clear all; % usuniecie wszystkich zmiennych
% close all; % zamkniecie wszystkich wykresow
% clc % zresetowanie okna komend

