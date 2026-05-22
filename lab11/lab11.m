%% GRAFIKA KOMPUTEROWA - LAB 11
%% *Joanna Dagil 231008*

clear; close all; clc;

%% CEL CWICZENIA
% Przekształcenia morfologiczne.

%% ZADANIA

%% ZADANIE 1
%
% Operacja *erozji* i *dylatacji* na zalaczonych obrazach bw.bmp (binarny) i camels.bmp (monochromatyczny).
% Elementy strukturalne do operacji:
%
% 1.
%    x x x
%    x o x
%    x x x
%
% 2.
%    x x x x x
%    x x x x x 
%    x x o x x
%    x x x x x
%    x x x x x
%
% 3.
%    x x x o x x x 
%  

SE{1} = ones(3,3);
SE{2} = ones(5,5);
SE{3} = ones(1,7);

Im{1} = imread('bw.bmp');
Im{2} = imread('camels.bmp');

for i = 1:2

    for j = 1:3

        IE{i}{j} = imerode(Im{i}, SE{j});
        ID{i}{j} = imdilate(Im{i}, SE{j});

        figure(1000+i*100+j*10);
        imshow(IE{i}{j});
        %figure(1000+i*100+j*10+1);
        %imshow(ID{i}{j});

    end

end



%% ZADANIE 2
%
% Operacja *otwarcia* i *domkniecia* na zalaczonych obrazach.

for i = 1:2

    for j = 1:3

        IOT{i}{j} = imdilate(IE{i}{j}, SE{j});
        IDO{i}{j} = imerode(ID{i}{j}, SE{j});
        % IOT{i}{j} = imopen(Im{i}, SE{j});
        % jw

        figure(2000+i*100+j*10);
        imshow(IOT{i}{j});
        %figure(2000+i*100+j*10+1);
        %imshow(IDO{i}{j});

    end

end


%% ZADANIE 3
%
% Operacja *top-hat* i *bottom-hat* na zalaczonych obrazach.

for i = 1:2

    for j = 1:3

        ITH{i}{j} = imtophat(Im{i}, SE{j});
        IBH{i}{j} = imbothat(Im{i}, SE{j});

        figure(3000+i*100+j*10);
        imshow(ITH{i}{j});
        %figure(3000+i*100+j*10+1);
        %imshow(IBH{i}{j});

    end

end


%% ZADANIE 4
%
% Operacja scieniania na obrazach bw.bmp, Un.bmp, oraz Un1.bmp i wyznaczenie szkieletow.
% Liczba iteracji - nieskończona i skończona.


Im2{1} = imread('bw.bmp');
Im2{2} = imread('Un.bmp'); 
Im2{3} = imread('Un1.bmp');

for i = 1:3

    ISKEL10{i}  = bwmorph(Im2{i}, 'skel', 10);
    ISKELINF{i} = bwmorph(Im2{i}, 'skel', Inf);
    ITHIN10{i}  = bwmorph(Im2{i}, 'thin', 10);
    ITHININF{i} = bwmorph(Im2{i}, 'thin', Inf);

    figure(4000+i*100+10);
    imshow(ISKEL10{i});
    %figure(4000+i*100+11);
    %imshow(ISKELINF{i});
    %figure(4000+i*100+12);
    %imshow(ITHIN10{i});
    %figure(4000+i*100+13);
    %imshow(ITHININF{i});

end



%% ZADANIE 5
%
% Wyznaczanie szkieletów obrazów binarnych wykorzystując metodę opartej na transformacji *hit-or-miss*.

EL = false(3,3,24);

EL(1:3,1:3,1) = [0, 0, 0;
                 1, 1, 1;
                 1, 1, 1];

EL(1:3,1:3,2) = [0, 0, 0;
                 0, 1, 1;
                 1, 1, 1];

EL(1:3,1:3,3) = [0, 0, 0;
                 1, 1, 0;
                 1, 1, 1];

EL(1:3,1:3,4) = [1, 0, 0;
                 1, 1, 0;
                 1, 1, 1];

EL(1:3,1:3,5) = [0, 0, 1;
                 1, 1, 1;
                 1, 1, 1];

EL(1:3,1:3,6) = [1, 0, 0;
                 1, 1, 1;
                 1, 1, 1];

% EL{7-24} obrocone jw

for k = 1:6
    temp(1:3,1:3) = EL(1:3,1:3,k);
    for j = 1:3
        for i = 1:3
            EL(j,i,k+18) = temp(i,4-j);
            EL(j,i,k+12) = temp(4-j,4-i);
            EL(j,i,k+6)  = temp(4-i,j);
        end
    end
end

Im1 = imread('Un1.bmp');
Im2 = bwmorph(Im1, 'skel', Inf);
[Y, X] = size(Im1);

Im3 = Im1;
diff = true;
frag = false(3,3);
while diff

    diff = false;
    Im4 = Im3;

    for x = 1:X
        for y = 1:Y
            if Im3(y,x) == 0
                continue;
            end

            for i = max(1, x-1):min(X,x+1)
                for j = max(1, y-1):min(Y, y+1)
                    frag(j-y+2, i-x+2) = Im3(j, i);
                end
            end

            for k = 1:24
                if hit_miss(frag, EL, k)
                    Im4(y,x) = 0;
                    diff = true;
                    break;
                end
            end
        end
    end

    Im3 = Im4;

end

%figure(5000);
%imshow(Im2);
figure(5001);
imshow(Im3);





%% FUNKCJE POMOCNICZE

%% HIT-OR-MISS

function value = hit_miss(frag, el, k)
    value = 0;
    temp(1:3,1:3) = el(1:3,1:3,k);

    if isequal(frag,temp)
        value = 1;
    end
end
