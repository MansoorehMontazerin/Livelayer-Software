function [Gy_black]= blackl(contourx,contoury,Gy)
Gy_black = Gy;
s=size(contourx);
for i=1:s(2)
   Gy_black(contourx(i)-10,contoury(i)+10)=min(Gy(:));  
end