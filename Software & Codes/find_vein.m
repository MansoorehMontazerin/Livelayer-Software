%{
This function is used to find and delete peripapillary veins so that
these images would be appropriate for segmentation
%}
function [Ig1]=find_vein(Ig,contourx3_new,contoury3_new,Ig2)
[M,N]=size(Ig);
for i=1:N
    I1=Ig2(contourx3_new(i):M,contoury3_new(i));
     average(i)=mean(I1);
end
average=smooth(average,5);

 x=1:N;
average_diff=diff(average);

TF1 = islocalmin(average_diff,'MinProminence',4);
TF2 = islocalmax(average_diff,'MinProminence',4);

 z1=x(TF1);

 z2=x(TF2);

Ig1=Ig2;
for i=1:min(numel(z1),numel(z2))
    for w=1:M
        h=ceil((z2(i)-z1(i))/2);
        Ig1(w,z1(i):z1(i)+h)=Ig2(w,z1(i)-h:z1(i));
        Ig1(w,z2(i)-h:z2(i))=Ig2(w,z2(i):z2(i)+h);
    end
end



