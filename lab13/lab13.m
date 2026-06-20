%% GRAFIKA KOMPUTEROWA - LAB 13
%% *Joanna Dagil 231008*

clear; close all; clc;

%% CEL CWICZENIA
% Filtrowanie sygnałów jedno- i dwuwymiarowych.

%% ZADANIA

% -----------------------------------------------------
%% ZADANIE 1
% -----------------------------------------------------

[music,f] = audioread('icing2.wav');
[K,~] = size(music);
fmusic = fft(music);
% zamiana wsp. x na herce
for i = 1:K
	hz(i) = f*(i-1)/K;
end
hz2 = hz-22050;
fmusic2 = fftshift(fmusic);
figure(1); plot(hz2,abs(fmusic2));
% pierwszy filtr
M = 100;
OP = ones(1,M)/M;
[h,w] = freqz(OP,1,512);
figure(2); plot(f*w/(2*pi),abs(h));
music_out = filter(OP,1,music);
audiowrite('icing2_avg.wav', music_out, f);

fmusic_out = fft(music_out);
fmusic_out2 = fftshift(fmusic_out);
figure(3); plot(hz2,abs(fmusic_out2));

OP2 = fir1(99,0.1); 
[h2,w] = freqz(OP2,1,512);
figure(4); plot(f*w/(2*pi),abs(h2));
music_fir = filter(OP2,1,music);
audiowrite('icing2_fir.wav', music_fir, f);

fmusic_fir = fft(music_fir);
fmusic_fir2 = fftshift(fmusic_fir);
figure(5); plot(hz2,abs(fmusic_fir2));



% -----------------------------------------------------
%% ZADANIE 2
% -----------------------------------------------------

zad2('LAKE.bmp',3,3,6);
zad2('LAKE.bmp',5,5,10);
zad2('LAKE.bmp',7,7,12);
zad2('LAKE.bmp',15,15,14);
zad2('LAKE.bmp',3,5,16);


% -----------------------------------------------------
%% ZADANIE 3
% -----------------------------------------------------

zad3('LAKE.bmp',30);


% -----------------------------------------------------
%% ZADANIE 4
% -----------------------------------------------------

zad4('LAKE.bmp',3,40);
zad4('LAKE.bmp',5,44);
zad4('LAKE.bmp',7,48);


% -----------------------------------------------------
%% ZADANIE 5
% -----------------------------------------------------

OP1 = [0,-1,0;-1,5,-1;0,-1,0];
OP2 = [0,1,0;1,-4,1;0,1,0];
[H1,~,~] = freqz2(OP1,256,256);
[H2,~,~] = freqz2(OP2,256,256);

for i = 0:255
	X(i+1) = i*2*pi/256;
	Y(i+1) = i*2*pi/256;
	Xsh(i+1) = i*2*pi/256-pi;
	Ysh(i+1) = i*2*pi/256-pi;
end
figure(111); mesh(Xsh,Ysh,abs(H1));
title('Zadanie 5');
figure(222); mesh(Xsh,Ysh,abs(H2));
title('Zadanie 5');
% OP1 - filtr wyostrzajacy, wzmacnia krawedzie i szczegoly.
% OP2 - operator Laplasjanu, filtr gornoprzepustowy do wykrywania krawedzi.



% -----------------------------------------------------
%% ZADANIE 6
% -----------------------------------------------------

zad2('camelsNOISE.bmp',3,3,120);   % filtr usredniajacy 3x3
zad2('camelsNOISE.bmp',5,5,122);   % filtr usredniajacy 5x5

zad6('camelsNOISE.bmp',3,124);     % filtr medianowy 3x3
zad6('camelsNOISE.bmp',5,125);     % filtr medianowy 5x5
drawnow;



% -----------------------------------------------------
%% FUNKCJE POMOCNICZE
% -----------------------------------------------------

function Im1 = zad2(nazwa,M,N,Fig)
	% Fig - nr pierwszego obrazka
	% MxN - rozmiar operatora
	Im = imread(nazwa);
	OP = ones(M,N)/(M*N);
	[y, x, d] = size(Im);
	if d>1 Im = rgb2gray(Im); end
	dIm = double(Im);
	% Im1 = uint8(zeros(y,x));
	Im1 = uint8(filter2(OP,dIm,'same'));
	figure(Fig); imshow(Im1);
	
	[H1,fx,fy] = freqz2(OP,[256,256]);
	fx = pi*fx; fy = pi*fy;
	figure(Fig+1); mesh(fx,fy,abs(H1));
end


function zad3(nazwa,Fig)
	% NxN rozmiar operatora
	Im = imread(nazwa);
	OP = [ 0.003, 0.013, 0.022, 0.013, 0.003;
			0.013, 0.059, 0.097, 0.059, 0.013;
			0.022, 0.097, 0.159, 0.097, 0.022;
			0.013, 0.059, 0.097, 0.059, 0.013;
			0.003, 0.013, 0.022, 0.013, 0.003];
	[y, x, d] = size(Im);
	if d>1 Im = rgb2gray(Im); end
	figure(1); imshow(Im);

	dIm = double(Im);
	%Im1 = uint8(zeros(y,x));
	Im1 = uint8(filter2(OP,dIm,'same'));
	figure(Fig); imshow(Im1);
    	
	[H1,~,~] = freqz2(OP,256,256);
	for i = 0:255
		X(i+1) = i*2*pi/256;
		Y(i+1) = i*2*pi/256;
		Xsh(i+1) = i*2*pi/256-pi;
		Ysh(i+1) = i*2*pi/256-pi;
	end
	figure(Fig+1); mesh(Xsh,Ysh,abs(H1));
end


function zad4(nazwa,N,Fig)
	% NxN rozmiar operatora
	Im = imread(nazwa);
	TEMP = ones(N,N)/(N*N);
	AUX = zeros(N,N); AUX(ceil(N/2),ceil(N/2)) = 1;
	OP = AUX - TEMP;
	[y,x,d] = size(Im);
	if d>1 Im = rgb2gray(Im); end
	figure(Fig); imshow(Im);

	dIm = double(Im);
	Im1 = uint8(zeros(y,x));
	Im1 = uint8(filter2(OP,dIm,'same'));
	figure(Fig+1); imshow(Im1);
	
	[H1,~,~] = freqz2(OP,256,256);
	for i = 0:255
		X(i+1) = i*2*pi/256;
		Y(i+1) = i*2*pi/256;
		Xsh(i+1) = i*2*pi/256-pi;
		Ysh(i+1) = i*2*pi/256-pi;
	end
	figure(Fig+2); mesh(Xsh,Ysh,abs(H1));
end


function zad6(nazwa,N,Fig)
	% NxN rozmiar operatora medianowego
	Im = imread(nazwa);
	A = zeros(N,N);
	[y,x,d] = size(Im);
	if d>1 Im=rgb2gray(Im); end
	Im1 = uint8(zeros(y,x));
	off = floor(N/2);
	for j = 1+off:y-off
		for i = 1+off:x-off
			jj = j-off; ii = i-off;
			A(1:N,1:N) = Im(jj:jj+N-1,ii:ii+N-1);
			a = median(A(:));
			Im1(j,i) = a;
		end
	end
	figure(Fig); imshow(Im1);
    drawnow;
end