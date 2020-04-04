function Phi = regiongrowing (tolerance,I,x,y)
if(x == 0 || y == 0)
    imshow(I);
    [x,y] = ginputc(1,'color','y');
 end
Phi=false(size(I,1),size(I,2));
% ref=true(size(Igray,1),size(Igray,2));
PhiOld = Phi;
%Phi(uint16(x),uint16(y)) = 1;
Phi(round(y),round(x))=1;
I_canny=edge(I,'canny',0.35,0.8);
se=strel('rectangle',[4 5]);
I=imdilate(I_canny,se);
while(sum(Phi(:)) ~= sum(PhiOld(:)))
    PhiOld = Phi;
    segm_val = I(Phi);
    meanSeg = mean(segm_val);
    posVoisinsPhi = imdilate(Phi,strel('disk',1,0))- Phi;
    voisins = find(posVoisinsPhi);
    valeursVoisins = I(voisins);
    Phi(voisins(valeursVoisins > meanSeg - tolerance & valeursVoisins < meanSeg + tolerance)) = 1;
    imshow(Phi)
end
imshow(Phi);
% Uncomment this if you only want to get the region boundaries
SE = strel('disk',2,0);
ImErd = imerode(Phi,SE);
Phi_boundary = Phi - ImErd;
% figure,imshow(Phi_boundary);