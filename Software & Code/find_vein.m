function [Ig1]=find_vein(Ig,contourx3_new,contoury3_new,Ig2)
[M,N]=size(Ig);
for i=1:N
    I1=Ig2(contourx3_new(i):M,contoury3_new(i));
     average(i)=mean(I1);
end
average=smooth(average,5);
% subplot(2,1,1);
% imshow(Ig2);
% axis on
% h = gca;
% h.Visible = 'On';
% subplot(2,1,2);
 x=1:N;
% plot(x,average);
% TF = islocalmin(average,'MinProminence',5);
% hold on
% plot(x(TF),average(TF),'r*')
% figure,imshow(Ig2);
% hold on
% z=x(TF);
% for i=1:numel(z)
%     line([z(i),z(i)],[1,M]);
% end
average_diff=diff(average);
% figure,plot(1:N-1,average_diff);
TF1 = islocalmin(average_diff,'MinProminence',4);
TF2 = islocalmax(average_diff,'MinProminence',4);
% hold on
% plot(x(TF1),average_diff(TF1),'r*')
% hold on
% plot(x(TF2),average_diff(TF2),'r*')
% figure,imshow(Ig2);
% hold on
 z1=x(TF1);
% for i=1:numel(z1)
%     line([z1(i),z1(i)],[1,M]);
% end
% hold on
 z2=x(TF2);
% for i=1:numel(z2)
%     line([z2(i),z2(i)],[1,M]);
% end
Ig1=Ig2;
for i=1:min(numel(z1),numel(z2))
    for w=1:M
        h=ceil((z2(i)-z1(i))/2);
        Ig1(w,z1(i):z1(i)+h)=Ig2(w,z1(i)-h:z1(i));
        Ig1(w,z2(i)-h:z2(i))=Ig2(w,z2(i):z2(i)+h);
    end
end
% figure,imshow(Ig1);
% figure,[r_contour2,contoury2,contourx2] = lwcontour(Ig1,1,500);
% [contoury2_new,contourx2_new]=resize_contour(contoury2,contourx2,Ig);
% contourx22_new=smooth(contourx2_new,10);
% figure,imshow(Ig2)
% hold on ,plot(contoury2_new,contourx22_new,'c','LineWidth',0.5);
% 
% [Ig3]=alignment(-1,Ig2,contourx8_new);
% figure,imshow(Ig3)




