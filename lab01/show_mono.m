function fig = show_mono(Im, fig)
    A = Im(:,:,1);
    B = Im(:,:,2);
    C = Im(:,:,3);

    figure(fig); imshow(cat(3, A, zeros(size(A)), zeros(size(A)))); % wyswietlenie
    figure(fig+1); imshow(cat(3, zeros(size(B)), B, zeros(size(B)))); % wyswietlenie
    figure(fig+2); imshow(cat(3, zeros(size(C)), zeros(size(C)), C)); % wyswietlenie
    fig = fig + 3;
endfunction