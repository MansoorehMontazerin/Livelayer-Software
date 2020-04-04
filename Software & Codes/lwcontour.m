function [r_contour,contoury,contourx] = lwcontour(image2d,imgshow,grad_calc , SamplingPace)
%function r_contour = lwcontour(image2d, grad_calc)
%
%Live Wire: allows user to guide semi-automated segmentation of images
%image2d is a 2D color image
%grad_calc = 1, is the old program using mean color gradient/gray images
%grad_calc = 2, is the new program using color gradient
%
%returns points along the segmented path
%left mouse button to create new seed point
%Press any key to terminate the program and return coordinates
%Image can be resized at any time
%
% smooth_param  for  producing a smoothWire (set to ~10-20)

%Note: X and Y variables are inverted to regular X and Y axis. I may
%correct these labels later.



%image needs to be a double for the gradients to be calculated
%So range is 0 to 1 instead of 0 to 255
global p_inputImage;
% global imgshow;
global SamplingPace;
p_inputImage = im2double(image2d);


imagesize = size(p_inputImage);
maxx = imagesize(2);
maxy = imagesize(1);
%no border around image is wanted
iptsetpref('ImshowBorder', 'tight');



%used to help guide segmentation
% gt=data2(img_number).contour_gt;
%     [N M] = size(gt);
%     for i=1:N-1,
%    		h=line( [ gt(i,1) ,gt(i+1,1)],  [gt(i,2), gt(i+1,2)]);
%          set(h,'Color',[0 1 0], 'LineWidth',1);
%     end

switch grad_calc
    %This uses the old color gradient magnitude and direction
    case 1
        % create the edge image using canny edge detection
        imageCannyEdge = edge(mean(p_inputImage,3), 'canny');
        %change the value so the edges are zero cost
        imageCannyEdge = abs(imageCannyEdge -1);

        %Detects edges using Laplacian of Gaussian filter
        imageLoG = edge(mean(p_inputImage,3),'log');
        imageLoG = abs(imageLoG -1);

        % get the x and y gradient
        [gradientx, gradienty] = gradient(mean(p_inputImage,3));
        %Calculate gradient magnitude
        magnitude = sqrt(gradientx.*gradientx + gradienty.*gradienty);
        maxMag = max(max(magnitude));
        %invert the magnitude map so high magnitude has low cost.
        %normalized to within 0:1 range
        magnitude = abs(magnitude./maxMag - 1);

        %Don't use gradient direction
        %gradientx = zeros(imagesize(1), imagesize(2));
        %gradienty = zeros(imagesize(1), imagesize(2));

        %Do not use Canny edge detection
        %imageCannyEdge = zeros(imagesize(1), imagesize(2));

        %Do not use Laplacian of Gaussian filter edge detection
        %imageLoG = zeros(imagesize(1), imagesize(2));

        %Calculates new color gradient magnitude and direction
    case 2
        % create the edge image using canny edge detection
        imageCannyEdge = edge(mean(p_inputImage,3), 'canny');
        %change the value so the edges are zero cost
        imageCannyEdge = abs(imageCannyEdge -1);


        %Detects edges using Laplacian of Gaussian filter
        imageLoG = edge(mean(p_inputImage,3),'log');
        imageLoG = abs(imageLoG -1);


        % Calculate color gradient magnitude and direction using all 3 colors
        maxMag = 0;
        [du_dx,du_dy] = gradient(p_inputImage(:,:,1));
        [dv_dx,dv_dy] = gradient(p_inputImage(:,:,2));
        [dw_dx,dw_dy] = gradient(p_inputImage(:,:,3));
        for x = 1:maxx
            for y = 1:maxy
                D=[du_dx(y,x),du_dy(y,x); dv_dx(y,x),dv_dy(y,x); dw_dx(y,x), dw_dy(y,x);];
                [eigen_vectors, eigen_values] = eig(D'*D);
                if eigen_values(1,1) == 0 && eigen_values(2,2) == 0
                    gradientx(y,x) = 0;
                    gradienty(y,x) = 0;
                elseif eigen_values(1,1) > eigen_values(2,2)
                    gradientx(y,x) = eigen_vectors(2,1);
                    gradienty(y,x) = eigen_vectors(1,1);
                    magnitude(y,x) = sqrt(eigen_values(1,1));
                else
                    gradientx(y,x)=eigen_vectors(1,2);
                    gradienty(y,x)=eigen_vectors(2,2);
                    magnitude(y,x) = sqrt(eigen_values(2,2));
                end;


                if sqrt(max(diag(eigen_values))) > maxMag
                    maxMag = sqrt(max(diag(eigen_values)));
                end
            end
        end
        %invert the magnitude map so high magnitude has low cost.
        %normalized to within 0:1 range
        magnitude = abs(magnitude./maxMag - 1);

        %Don't use gradient direction
        %gradientx = zeros(imagesize(1), imagesize(2));
        %gradienty = zeros(imagesize(1), imagesize(2));

        %Do not use Laplacian of Gaussian filter edge detection
        %imageLoG = zeros(imagesize(1), imagesize(2));

        %Do not use Canny edge detection
        %imageCannyEdge = zeros(imagesize(1), imagesize(2));

end %end of cases



wghtCoA = 4; %Presence of canny edge weight
wghtCoB = 1; %Gradient magnitude weight
wghtCoC = 1; %Gradient direction weight
wghtCoD = 4; %Presence of LoG edge weight

global contourx;
global contoury;
contourx=[];
contoury=[];

%==========================================================================
%start of what is neccesary step to calculate the cost.
%==========================================================================
global COST;
sizeof = size(imageCannyEdge);
sizex = sizeof(1);
sizey = sizeof(2);

%Display the image
 imshow(imgshow);
 hold on;

[x,y]= ginputc(1,'color','y');
inputSeed=[x,y];
% inputSeed = ginput(1);
seedx = inputSeed(2) -1;
seedy = inputSeed(1) -1;
format long; % needed??

%Calls simplelw.dll
output=simplelw_mod(sizex,sizey,seedx,seedy,wghtCoA,wghtCoB,wghtCoC,wghtCoD,gradientx,gradienty,imageCannyEdge,imageLoG,magnitude);

%fill the border
output(find(output(:) == max(output(:)))) = inf;
COST = output;

%Mouse click action
set(gcf,'WindowButtonDownFcn',{@seedclick,sizex,sizey,wghtCoA,wghtCoB,wghtCoC,wghtCoD,gradientx,gradienty,imageCannyEdge,imageLoG,magnitude});
%Mouse moves action
set(gcf,'WindowButtonMotionFcn',@mousemove);
%Any keyboard input
set(gcf,'KeyPressFcn',@keypress);
uiwait(gcf);
r_contour = [contourx;contoury];
close(gcf);

%Called when user clicks on the image
function seedclick(src,eventdata,sizex,sizey,wghtCoA,wghtCoB,wghtCoC,wghtCoD,gradientx,gradienty,imageCannyEdge,imageLoG,magnitude)
global COST;
global p_inputImage;
global contourx;
global contoury;

findNeighbourX = [-1 -1 -1 0 0 1 1 1]';%vector for calculating neighbour pixels
findNeighbourY = [-1 0 1 -1 1 -1 0 1]';

format short;

%get the coordinates of the mouse click
seed=get(gca,'CurrentPoint');
endx = round(seed(1,2));
endy = round(seed(1,1));

[maxx,maxy]=size(COST);

%Checks if coordinates are valid
if(endx > maxx || endy > maxy || endx < 0 || endy < 0)
    return;
end

pathcost = COST(endx, endy);%flipped x|y
previouscost = pathcost+1;
while ((pathcost > 0) && (previouscost > pathcost))
    neighbour = [findNeighbourX+endx(1) findNeighbourY+endy(1)];%fncFindNeighbour(endx, endy, 1, 1, imagesize(1), imagesize(2));
    endx = [neighbour(1,1) endx];
    endy = [neighbour(1,2) endy];
    for ind = 1:size(neighbour,1)
        if (COST(neighbour(ind,1), neighbour(ind,2)) < pathcost)
            pathcost = COST(neighbour(ind,1), neighbour(ind,2));
            %endx = neighbour(ind,1);
            %endy = neighbour(ind,2);
            endx(1) = neighbour(ind,1);
            endy(1) = neighbour(ind,2);
        end;%end of if (cost()<
    end;%end of for loop
end;%while pathcost > 0

currentcontourx = endx;
currentcontoury = endy;
contourx = [contourx currentcontourx];
contoury = [contoury currentcontoury];

%Delete old plot lines
delete(findobj(gca,'Type','Line'));
%Redraw the image with the green line
plot(contoury, contourx, 'Color','green', 'LineWidth',1.5);


format long; % needed??

seedy = endy(end)-1;
seedx =endx(end)-1;

%Calls simplelw.dll
output=simplelw_mod(sizex,sizey,seedx,seedy,wghtCoA,wghtCoB,wghtCoC,wghtCoD,gradientx,gradienty,imageCannyEdge,imageLoG,magnitude);

%fill the border
output(find(output(:) == max(output(:)))) = inf;
COST = output;


%Called when user moves the mouse
function mousemove(src,eventdata)
global COST;
global p_inputImage;
global contourx;
global contoury;

findNeighbourX = [-1 -1 -1 0 0 1 1 1]';%vector for calculating neighbour pixels
findNeighbourY = [-1 0 1 -1 1 -1 0 1]';

format short;

seed=get(gca,'CurrentPoint');
endx = round(seed(1,2));
endy = round(seed(1,1));

[maxx,maxy]=size(COST);

%Checks if coordinates are valid
if(endx >= maxx || endy >= maxy || endx < 0 || endy < 0)
    return;
end

pathcost = COST(endx, endy);%flipped x|y
previouscost = pathcost+1;
while ((pathcost > 0) && (previouscost > pathcost))
    neighbour = [findNeighbourX+endx(1) findNeighbourY+endy(1)];%fncFindNeighbour(endx, endy, 1, 1, imagesize(1), imagesize(2));
    endx = [neighbour(1,1) endx];
    endy = [neighbour(1,2) endy];
    for ind = 1:size(neighbour,1)
        if (COST(neighbour(ind,1), neighbour(ind,2)) < pathcost)
            pathcost = COST(neighbour(ind,1), neighbour(ind,2));
            endx(1) = neighbour(ind,1);
            endy(1) = neighbour(ind,2);
        end;%end of if (cost()<
    end;%end of for loop
end;%while pathcost > 0

%Delete old plot lines
delete(findobj(gca,'Type','Line','Color','red'));
%Draw the live wire line (red line)


if nargin==3
    out=ContourSampling(endx,endy,smooth_param);
    t=1:size(out,2);
    ts=1:0.1:size(out,2);
    psc=spline(t,out,ts);
    endy=[];
    endx=[];
    endx=psc(1,:);
    endy=psc(2,:);
end
plot(endy,endx,'Color','red','LineWidth',1.5);


%when any key is pressed matlab resumes and returns coordinates
function keypress(src,eventdata)
uiresume(src);


function out=ContourSampling(endx,endy,t);

out=[];
count=1;
i=1;
while i<=size(endx,2)
    out(:,count)=[endx(1,i) endy(1,i)];
    i=i+t;
    count=count+1;
end
out(:,end+1)=[endx(1,end) endy(1,end)];
