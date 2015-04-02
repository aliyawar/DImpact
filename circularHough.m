function [finalX, finalY, radius, gauss] = circularHough(image, box, rmin, rmax)

for i = box(1) : box(1)+box(3)
    for j = box(2) : box(2)+box(4)
        k = 1;
        for r = rmin:1:rmax
            intensity = [];
            for th = 0:0.2:2*pi
                p = abs(floor( i + r * cos(th) ));
                q = abs(floor( j + r * sin(th) ));
                %c = (p-i)^2+(q-j)^2;
                %if p == 0
                    %p = 1;
                %end
                %if q == 0
                %    q = 1;
                %end
                %if q > 400
                %    q = 400;
                %end
                intensity = [intensity;image(q,p)];
            end
            I(k) = mean(intensity);
            k = k+1;
        end
        
        [maxLocalIntensity,radiusInd] = max(I);
        output(i,j,:) = [radiusInd+rmin-1,maxLocalIntensity];
        gauss(i,j,:) = I;
        
    end
end
    
tmp = output(:,:,2);
[intmax,idx] = max(tmp(:));
[finalX,finalY]=ind2sub(size(tmp),idx);
radius = output(finalX,finalY,1);

end