function  YUV = RGBtoYUV(RGB)
    T = [0.2126,    0.7152,   0.0722; 
        -0.09991,  -0.33609,  0.436; 
         0.615,    -0.55861, -0.05639];

    [h,w,c] = size(RGB);
    RGB = reshape(RGB, h*w, c)';
    YUV = T * RGB;
    YUV = reshape(YUV', h, w, c);
endfunction