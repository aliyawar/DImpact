function [I,Imax] = circularHough(image, i, j, rmin, rmax)

circle = [];
intensity = [];

for r = rmin:1:rmax
    for th = 0:0.1:2*pi
        p = floor( i + r * cos(th) );
        q = floor( j + r * sin(th) );
        %c = (p-i)^2+(q-j)^2;
        if p == 0 
            p == 1;
        if q == 0
            q == 1;
        end
    end
    I(i,j,r) = mean(intensity);
end

[Imax,idx] = max(I(:));
I = ind2sub(size(I),idx);

end
