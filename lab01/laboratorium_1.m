%% GRAFIKA KOMPUTEROWA LAB_1
% *Joanna Dagil 231008*

%% 1. CEL CWICZENIA
% Zapoznanie sie z modelami kolorów i ich przekształceniami.

%% 2. PRZEKSZTAŁCENIA KOLORÓW

%% 2.1(a) Funkcja przekształcająca obrazy w formacie RGB do formatu YUV.

RGB = [255; 0; 0];
YUV = RGBtoYUV(RGB)

RGB = [255; 0; 0];
kR = 0.299;
kG = 0.587; 
kB = 0.114;
YCbCr = RGBtoYCbCr(RGB, kR, kG, kB)

%% 2.1(b) Funkcja przekształcająca obrazy w formacie RGB do formatu YCbCr.
% gdzie macierz przekształcenia zdefiniowana jest przez współczynniki [kR, kG, kB], a argumentem wyjściowym macierz obrazu w formacie YCbCr. Przykładowe wartości współczynników to kR = 0.299, kG = 0.587 oraz kB = 0.114).

% Ścieżki w pierwotnym obrazie

Im = imread('obraz.bmp');
fig = 1;
fig = show_mono(Im, fig);

% Ścieżki w obrazie

ImYUV = RGBtoYUV(double(Im));
fig = show_mono(uint8(ImYUV), fig);

% Ścieżki w obrazie YCbCr

ImYCbCr = RGBtoYCbCr(double(Im));
fig = show_mono(uint8(ImYCbCr), fig);

