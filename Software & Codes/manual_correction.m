function [xf,yf]=manual_correction(I,contourx,contoury,m)
imshow(I)
hold on
plot(contoury,contourx,'color','red');
hold on 
[x,y]= ginputc(2,'color','y');

contoury1=contoury(contoury<x(1));
contoury2=contoury(contoury>x(2));
contourx1=contourx(1:numel(contoury1));
contourx2=contourx(numel(contoury)-numel(contoury2)+1:numel(contoury));
% contourx11=smooth(contourx1,11);
% contourx22=smooth(contourx2,11);
delete(gcf);
figure,imshow(I);
hold on ,plot(contoury1,contourx1,'cyan');
hold on ,plot(contoury2,contourx2,'cyan');

sm=size(I);
for a=x(1):((x(2)-x(1))/m):x(2)
   hold on 
   line([a,a],[1,sm(1)],'color','red');
end

a=zeros(size(m+1));
b=zeros(size(m+1));
for i=1:m+1
   [a(i),b(i)]=ginputc(1,'color','y');
   hold on
   plot(a(i),b(i),'cyanx')
end
p=x(1):x(2);
q=interp1(a,b,p,'spline');
hold on 
plot(p,q,'cyan')
yf=cat(2,contoury1,p,contoury2);
xf=cat(1,contourx1,q',contourx2);

