function  YCbCr = RGBtoYCbCr(RGB)
    kR = 0.299;
    kG = 0.587; 
    kB = 0.114;
    T = [kR, kG, kB; -0.5*kR/(1-kB), -0.5*kG/(1-kB), 0.5; 0.5, -0.5*kG/(1-kR), -0.5*kB/(1-kR)];
    [h,w,c] = size(RGB);
    RGB = reshape(RGB, h*w, c)';
    YCbCr = T * RGB;
    YCbCr = reshape(YCbCr', h, w, c);
endfunction