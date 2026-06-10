%% GRAFIKA KOMPUTEROWA - LAB 12
%% *Joanna Dagil 231008*

clear; close all; clc;

%% CEL CWICZENIA
% Transformata Fouriera i szybka transformata Fouriera (FFT).

%% ZADANIA

% -----------------------------------------------------
%% ZADANIE 1
% -----------------------------------------------------

for n = 0:1023
    x(n+1) = cos(0.314*n + 2.5) + 2*cos(1.57*n - 0.18);
end

xx(1:32) = x(1:32);       % krotka sekwencja
w = 0:0.001:2*pi;         % "ciagly" zakres czestotliwosci
[aux,k] = size(w);

for i = 1:k
    ww(i) = 0 + 1*0;
    for j = 0:31
        ww(i) = ww(i) + xx(j+1)*exp(-1*j*w(i)); % ze wzoru slajd 11
    end
end

figure(1); 
plot(w, abs(ww))
hold on;

fww = fft(xx); % FFT
for i = 1:32
    p1(i) = (i-1)*2*pi/32;
end

stem(p1, abs(fww)); 
hold off;

figure(2); 
plot(p1, abs(fww));

% 1024 probki
fw = fft(x);
for i = 1:1024
    p12(i) = (i-1)*2*pi/1024;
end

figure(3); 
plot(p12, abs(fw));
fwsh = fftshift(fw);
figure(4); 
plot(p12-pi, abs(fwsh));




% -----------------------------------------------------
%% ZADANIE 2
% -----------------------------------------------------

[music, f] = audioread('icing2.wav');

[K, aux] = size(music);
fmusic = fft(music);
figure(5); plot(abs(fmusic));

% zamiana wsp. x na herce
for i = 1:K
    hz(i) = f*(i-1)/K;
end

hz2 = hz - 22050;
fmusic2 = fftshift(fmusic);
figure(6); plot(hz2, abs(fmusic2));

fmusic2_low = fmusic2;

for i = 1:K
    if abs(hz2(i)) > 2205
        fmusic2_low(i) = 0;
    end
end

figure(7); plot(hz2, abs(fmusic2_low));

fmusic_low = ifftshift(fmusic2_low);
music_low = ifft(fmusic_low);

audiowrite('icing2low.wav', music_low, f);

fmusic2_high = fmusic2;

for i = 1:K
    if abs(hz2(i)) < 1103
        fmusic2_high(i) = 0;
    end
end

figure(8); plot(hz2, abs(fmusic2_high));

fmusic_high = ifftshift(fmusic2_high);
music_high = ifft(fmusic_high);

audiowrite('icing2high.wav', music_high, f);


% -----------------------------------------------------
%% ZADANIE 3
% -----------------------------------------------------

Im = imread('LAKE.bmp');
figure(9); imshow(Im);
dIm = double(Im);
fIm = fft2(dIm);
% zakres czestotliwosci od 0 do 2PI
for i = 0:255
	wX(i+1) = i*2*pi/256; % rozdzielczosc obrazka 256x256
	wY(i+1) = i*2*pi/256;
	wXsh(i+1) = i*2*pi/256-pi; % czestotliwosci dodatnie i ujemne
	wYsh(i+1) = i*2*pi/256-pi; % czestotliwosci dodatnie i ujemne
end
fImsh = fftshift(fIm);
figure(10); mesh(wX,wY,abs(fIm));
figure(11); mesh(wXsh,wYsh,abs(fImsh));



% -----------------------------------------------------
%% ZADANIE 4
% -----------------------------------------------------

Im = imread('LAKE.bmp');
dIm = double(Im);
fIm = fft2(dIm);
% zakres czestotliwosci od 0 do 2PI
for i = 0:255
	wX(i+1) = i*2*pi/256; % rozdzielczosc obrazka 256x256
	wY(i+1) = i*2*pi/256;
	wXsh(i+1) = i*2*pi/256-pi; % czestotliwosci dodatnie i ujemne
	wYsh(i+1) = i*2*pi/256-pi; % czestotliwosci dodatnie i ujemne
end
fImsh = fftshift(fIm);
figure(12); mesh(wXsh,wYsh,abs(fImsh));

% czestotliwosc wx
fImshx = fImsh;
for n = 1:256
	if abs(wXsh(n)) > pi/12
		for m = 1:256
			fImshx(m,n) = 0;
		end
	end
end
figure(13); mesh(wXsh,wYsh,abs(fImshx));
fIm2 = ifftshift(fImshx);
Im2 = uint8(ifft2(fIm2));
figure(14); imshow(Im2);

% czestotliwosci wy
fImshy = fImsh;
for n = 1:256
	if abs(wYsh(n)) < pi/12
		for m = 1:256
			fImshy(n,m) = 0;
		end
	end
end
figure(15); mesh(wXsh,wYsh,abs(fImshy));
fIm3 = ifftshift(fImshy);
Im3 = uint8(ifft2(fIm3));
figure(16); imshow(Im3);

% czestotliwosci wx i wy
fImshxy = fImsh;
for n = 1:256
	for m = 1:256
		if abs(wYsh(n)) > pi/10 || abs(wXsh(m)) > pi/10
			fImshxy(n,m) = 0;
		end
	end
end
figure(17); mesh(wXsh,wYsh,abs(fImshxy));
fIm4 = ifftshift(fImshxy);
Im4 = uint8(ifft2(fIm4));
figure(18); imshow(Im4);


