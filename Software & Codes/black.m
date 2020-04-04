function [Gy_black]= black(contourx,contoury,Gy)
Gy_black = Gy;
s=size(contourx);
for i=1:s(2)
   Gy_black(contourx(i)-5:contourx(i)+5,contoury(i))=min(Gy(:));  
end