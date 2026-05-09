%% GRAFIKA KOMPUTEROWA LAB_3
% *Joanna Dagil 231008*

%% 1. CEL CWICZENIA
% Zapoznanie sie transformacjami geometrycznymi 2D obrazów

%% 2. ZADANIA

%% 2.1.a Zamiana współrzędnych matematycznych obrazu na współrzędne pikselowe obrazu cyfrowego.

function [i,j] = mat_to_pix(x, y, M, N, dx, dy)
    T = [1/dx, 0,    M/2;
         0,   -1/dy, N/2;
         0,    0,    1];
    temp = [x; y; 1];
    res = T * temp;
    i = round(res(1)/res(3));
    j = round(res(2)/res(3));
end


%% 2.1.b Zamiana współrzędnych pikselowych obrazu cyfrowego na współrzędne matematyczne.

function [i,j] = pix_to_mat(x, y, M, N, dx, dy)
    T = [dx,  0, -M*dx/2;
         0,  -dy, N*dy/2;
         0,   0,  1];
    res = T * [x; y; 1];
    i = res(1)/res(3);
    j = res(2)/res(3);
end

% Sprawdźmy czy po przekształceniu z matamatycznych na pikselowe i spowrotem na matematyczne otrzymujemy pierwotne współrzędne (z pominięciem błedu)

x=15
y=2.73
dx=0.67; dy=0.67; M=1000; N=800;
[a,b] = mat_to_pix(x,y,M,N,dx,dy)
[c,d] = pix_to_mat(a,b,M,N,dx,dy)

%% 2.2. Wyznaczanie macierzy transformacji dla przekształcenia podobieństwa (a) i przekształcenia afinicznego (b).

%% 2.2.a Przekształcenie podobieństwa

function res = podobienstwo(x1,y1,x2,y2,u1,v1,u2,v2)
    mat = [x1, -y1, 1, 0;
           y1, x1, 0, 1;
           x2, -y2, 1, 0;
           y2, x2, 0, 1];
    temp = linsolve(mat, [u1; v1; u2; v2]);
    res =[temp(1), -temp(2), temp(3);
         temp(2), temp(1), temp(4);
         0,       0,       1];
end

A = imread('A_podo.bmp');
B = imread('B_podo.bmp');
figure(1); imshow(A);
figure(2); imshow(B);

x1 = 1; y1 = 1;
u1 = 42; v1 = 100;
x2 = 1; y2 = 360;
u2 = 133; v2 = 353;

H_podobienstwa = podobienstwo(x1,y1,x2,y2,u1,v1,u2,v2);

disp(H_podobienstwa)

%% 2.2.b Przekształcenie afiniczne

function res = afiniczne(x1,y1,x2,y2,x3,y3,u1,v1,u2,v2,u3,v3)
    mat = [x1, y1, 1, 0, 0, 0;
           0, 0, 0, x1, y1, 1;
           x2, y2, 1, 0, 0, 0;
           0, 0, 0, x2, y2, 1;
           x3, y3, 1, 0, 0, 0;
           0, 0, 0, x3, y3, 1];
    temp = linsolve(mat, [u1; v1; u2; v2; u3; v3]);
    res =[temp(1), temp(2), temp(3);
         temp(4), temp(5), temp(6);
         0,       0,       1];
end

A = imread('A_afin.bmp');
B = imread('B_afin.bmp');
figure(1); imshow(A);
figure(2); imshow(B);

x1 = 123; y1 = 94;
u1 = 185; v1 = 126;
x2 = 308; y2 = 140;
u2 = 333; v2 = 293;
x3 = 234; y3 = 210;
u3 = 379; v3 = 261;

H_afiniczne = afiniczne(x1,y1,x2,y2,x3,y3,u1,v1,u2,v2,u3,v3);

disp(H_afiniczne)


%% 2.3. Przekształcenie obrazów A i B za pomocą wyznaczonych macierzy transformacji.

% Dokonujemy zaokrąglenia współrzędnych do najbliższych liczb całkowitych w celu uniknięcia czarnych ziaren na wynikowym obrazie.

function res = transform(A, H)
    [height, width] = size(A);
    res = uint8(zeros(height, width));

    for y2 = 1:height
        for x2 = 1:width
            
            v = H \ [x2; y2; 1];
            x = v(1) / v(3);
            y = v(2) / v(3);

            if (x >= 1) && (x <= width) && (y >= 1) && (y <= height)
                res(y2, x2) = A(round(y), round(x));
            end
        end
    end
end

A = imread('A.bmp');
B = imread('B.bmp');
figure(3); imshow(A);
figure(4); imshow(B);

% transformacje podobieństwa

A_podobienstwo = transform(A, H_podobienstwa);
B_podobienstwo = transform(B, H_podobienstwa);
figure(5); imshow(A_podobienstwo);
figure(6); imshow(B_podobienstwo);

% transformacje afiniczne

A_afiniczne = transform(A, H_afiniczne);
B_afiniczne = transform(B, H_afiniczne);
figure(7); imshow(A_afiniczne);
figure(8); imshow(B_afiniczne);

%% Typowy koniec skryptu

% clear all; % usuniecie wszystkich zmiennych
% close all; % zamkniecie wszystkich wykresow
% clc % zresetowanie okna komend
