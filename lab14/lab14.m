%% GRAFIKA KOMPUTEROWA - LAB 14
%% *Joanna Dagil 231008*

clear; close all; clc;

%% CEL CWICZENIA
% Transformata Hough’a i Radona

%% ZADANIA

% -----------------------------------------------------
%% ZADANIE 1
% -----------------------------------------------------
% (a) Transformacja Hough'a na obrazie konturowym.
% 

im = imread('ez.bmp');
% im = imread('dom.bmp');

cont = edge(im, 'canny');

figure(1); imshow(cont);

[H,T,R] = hough(cont, 'RhoResolution', 2, 'Theta', -90:1:89);

figure(2); mesh(H);

Max = max(H(:));
Hnorm = H / Max;

figure(3); imshow(uint8(255 * Hnorm));

[m, n] = size(H);
Hn = zeros(m,n);

for i = 1:m
    for j = 1:n
        if H(i,j) < 0.40 * Max
            Hn(i,j) = 0;
        else
            Hn(i,j) = H(i,j);
        end
    end
end

Hnn = Hn / max(Hn(:));

figure(4); imshow(uint8(255 * Hnn));
figure(5); mesh(Hn);


% (b) j.w. z wbudowanymi funkcjami houghpeaks i houghlines

% im = imread('ez.bmp');
im = imread('dom.bmp');

cont = edge(im, 'canny');
figure(6); imshow(cont);

[H, T, R] = hough(cont, 'RhoResolution', 2, 'Theta', -90:1:89);
P = houghpeaks(H, 25, 'Threshold', 0.2 * max(H(:))); % 3, 5

lines = houghlines(cont, T, R, P, 'FillGap', 5, 'MinLength', 7);

figure(7); imshow(cont); hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 3, 'Color', 'green');
end



% -----------------------------------------------------
%% ZADANIE 2
% -----------------------------------------------------
% (a) Transformacja Radona
% im = imread('dom.bmp');
im = imread('ez.bmp');

cont = edge(im, 'canny');
figure(8); imshow(cont);

[H, T, R] = hough(cont, 'RhoResolution', 2, 'Theta', -90:1:89);
figure(9); mesh(H);

Max = max(H(:));
Hnorm = H / Max;
figure(10); imshow(uint8(255 * Hnorm));

theta = 0:179;
R1 = radon(im, theta);
R2 = radon(cont, theta);

figure(11); mesh(R1);
figure(12); mesh(R2);

R1norm = R1 / max(R1(:));
figure(14); imshow(uint8(255 * R1norm));

R2norm = R2 / max(R2(:));
figure(15); imshow(uint8(255 * R2norm));


% (b) Odwrócenie transformacji Radona

im = imread('ez.bmp');
% im = imread('dom.bmp');

cont = edge(im, 'canny');

theta = 0:1:179;  % 0:5:179  0:15:179

R1 = radon(im, theta);

im1 = iradon(R1, 1);   % inne wartosci
figure(16); imshow(uint8(im1));

im10 = iradon(R1, 10);
figure(17); imshow(uint8(im10));

R2 = radon(cont, theta);

cont1 = iradon(R2, 1);   % inne wartosci
figure(18); imshow(uint8(255 * cont1));

cont10 = iradon(R2, 10);
figure(19); imshow(uint8(255 * cont10));


% -----------------------------------------------------
%% ZADANIE 3
% -----------------------------------------------------
% Lokalizacja tęczówki

im = imread('e9.jpg'); % reading the image containing a single eye

if (size(im, 3) == 3) % if it is a truecolor image
    imm = rgb2gray(im); % conversion to gray level, if necessary
else
    imm = im;
end

% The image should be established as a certain percentage of the image width
% tentetively, the proposed values are:
Rmin = round(size(im,2)/12);
Rmax = round(size(im,2)/5);

Sens = 0.97; % sensitivity value - if reduced to a smaller value then fewer circles would be detected
% try for the image e13.jpg with the values 0.91 and 0.97

[centers, radii, metric] = imfindcircles(imm, [Rmin Rmax], 'ObjectPolarity', 'dark', 'Sensitivity', Sens);

figure(20); imshow(imm);
viscircles(centers, radii, 'EdgeColor', 'b'); % displaying all detected circles

centersStrong = centers(1:1,:);
radiiStrong = radii(1:1);
% metricStrong = metric(1);

figure(21); imshow(imm);
viscircles(centersStrong, radiiStrong, 'EdgeColor', 'b'); % displaying only
% the "strongest" circle
% additionally, you may want to save the results as image files




% -----------------------------------------------------
%% FUNKCJE POMOCNICZE
% -----------------------------------------------------







