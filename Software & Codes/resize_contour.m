%{
This function stretches an acquired boundary to fit into the width of the
image
%}
function [contoury_new,contourx_new]=resize_contour(contouryo,contourxo,S,Ig)
[M,N]=size(Ig);
s=numel(contouryo);
contouryn=contouryo;
contourxn=contourxo;
for  i=1:s-2
    if contouryo(i+1)<contouryn(i)
        contouryn(i+1)=contouryn(i);
        contourxn(i+1)=contourxn(i);
    else 
        contouryn(i+1)=contouryo(i+1);
        contourxn(i+1)=contourxo(i+1);
    end
end
i=1;
while i<numel(contouryn)
if contouryn(i+1) - contouryn(i) == 0 || contouryn(i+1) - contouryn(i)<0
contouryn(i) = [];
contourxn(i) = [];
i=i-1;
end
i=i+1;
end
s1=numel(contourxn);
contoury_new=1:N;
contourx_new=zeros(1,N);
contourx_new(contouryn(1):contouryn(s1))=contourxn(:);
contourx_new(1:contouryn(1)-1)=contourxn(1);
contourx_new(contouryn(s1)+1:N)=contourxn(s1);
contourx_new=smooth(contourx_new,S);
