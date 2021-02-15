function [elapsedTime,yn]=free_hand(I)
tic
% I=I(:,:,9);
figure,imshow(I);
xf=[];
yf=[];
answer='yes';
while(strcmp(answer,'yes'))
h=imfreehand(gca,'closed',false);
setColor(h,'yellow');
xy=getPosition(h);
x=xy(:,1);
y=xy(:,2);
xf=cat(1,xf,x);
yf=cat(1,yf,y);
answer = questdlg('Would you like to continue?', ...
	'layer segmentation', ...
	'yes','no','no');
end
xf=smooth(xf,50);
yf=smooth(yf,50);
xff=floor(xf)';
yff=floor(yf)';
% yn=zeros(1,numel(xff));
yn=[];
for i=1:numel(xff)
    yn(xff(i))=yff(i);
end

yn(1,1:xff(1))=yff(1);
for i=1:numel(yff)-1
   yn(1,xff(i)+1:xff(i+1))=yff(i+1);
end
if numel(yn)<size(I,2)
    yn(1,numel(yn)+1:size(I,2))=yn(numel(yn));
    if xff(numel(xff))<size(I,2)
    yn(1,xff(numel(xff)):size(I,2))=yn(xff(numel(xff)));
    end
end
if numel(yn)>size(I,2)
    yn=yn(1,1:size(I,2));
    if xff(numel(xff))<size(I,2)
    yn(1,xff(numel(xff)):size(I,2))=yn(xff(numel(xff)));
    end
end
close(gcf)
% figure,imshow(I)
% hold on,plot(1:size(I,2),yn,'r','linewidth',1.5);
% close(gcf)
elapsedTime = toc;