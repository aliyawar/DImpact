function [line] = sweepLine(image, box, dx)
line = [];
box = floor(box);

for i=box(1):(box(1)+box(3))        
    line = [line image(box(2):(box(2)+box(4)),i)];
end

% for i=box(1):(box(1)+box(3))        
%     line = [line image(box(2):(box(2)+box(4)),i)];
% end

for i=1:size(line,2);
    avg_line(i) = mean(line(:,i));
end
[tmp,location] = max(avg_line);
end

