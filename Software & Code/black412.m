%{
This function is used in order to black some boundaries interfering with
the segmentation process
%}
function [Gy_black]= black412(contourx,contoury,Gy)
Gy_black = Gy;
s=size(contourx);
for i=1:s(2)
   Gy_black(contourx(i)-4:contourx(i)+12,contoury(i))=min(Gy(:));  
end