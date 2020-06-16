%{ 
  This function is used in the Peripapillary section for aligning and flattening 
  all boundaries after being shifted by the find_vein function
%}

function [Ig2,d]=alignment(a,Ig,contourx_new)
[M,N]=size(Ig);
x_max=max(contourx_new);
Ig2=Ig;
d=(x_max-contourx_new);
for i=1:N
    Ig2(:,i)=circshift(Ig(:,i),round(a*d(i)));
end
