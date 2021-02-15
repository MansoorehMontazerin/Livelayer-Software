function [NumBScans,Im_SLO_Image,OCTs,header,BScanHeader]= read_VOL_func(address)
%by rahele kafieh 2012


fid=fopen(address);

%--------------------------------------------------------------------------
% File header read
header.Version = fread( fid, 12, 'int8' );
header.SizeX = fread( fid, 1, 'int32' );
header.NumBScans = fread( fid, 1, 'int32' );
header.SizeZ = fread( fid, 1, 'int32' );
header.ScaleX = fread( fid, 1, 'double' );
header.Distance = fread( fid, 1, 'double' );
header.ScaleZ = fread( fid, 1, 'double' );
header.SizeXSlo = fread( fid, 1, 'int32' );
header.SizeYSlo = fread( fid, 1, 'int32' );
header.ScaleXSlo = fread( fid, 1, 'double' );
header.ScaleYSlo = fread( fid, 1, 'double' );
header.FieldSizeSlo = fread( fid, 1, 'int32' );
header.ScanFocus = fread( fid, 1, 'double' );
header.ScanPosition = char(fread( fid, 4, 'uchar' )');
header.ExamTime = fread( fid, 1, 'int64' );
header.ScanPattern = fread( fid, 1, 'int32' );
header.BScanHdrSize = fread( fid, 1, 'int32' );
header.ID = char(fread( fid, 16, 'uchar' )');
header.ReferenceID = char(fread( fid, 16, 'uchar' )');
header.PID = fread( fid, 1, 'int32' );
header.PatientID = char(fread( fid, 21, 'uchar' )');
header.Padding = fread( fid, 3, 'int8' );
header.DOB = fread( fid, 1, 'double' );
header.VID = fread( fid, 1, 'int32' );
header.VisitID = char(fread( fid, 24, 'uchar' )');
header.VisitDate = fread( fid, 1, 'double' );
header.GridType = fread( fid, 1, 'int32');
header.GridOffset = fread( fid, 1, 'int32');
header.Spare = fread( fid, 1832, 'int8' );

SizeX = header.SizeX;
NumBScans = header.NumBScans;
SizeZ = header.SizeZ;
SizeXSlo = header.SizeXSlo;
SizeYSlo = header.SizeYSlo;
BScanHdrSize =header.BScanHdrSize;

%SLO Blocks
fseek(fid, 2048, 'bof');
SloImageSize=SizeXSlo*SizeYSlo;
SLO_Image=fread(fid,SloImageSize,'uint8');
Im_SLO_Image = reshape(SLO_Image,SizeXSlo,SizeYSlo);
Im_SLO_Image = flipud( Im_SLO_Image );
Im_SLO_Image = rot90( Im_SLO_Image, 3);
scrsz = get(0,'ScreenSize');
% figure('Position',[1 0 scrsz(3) scrsz(4)-70]);
% clf;
% subplot(1,2,1); imshow(Im_SLO_Image,[])

BScanHeader.StartX = zeros(1, header.NumBScans, 'double');
BScanHeader.StartY = zeros(1, header.NumBScans, 'double');
BScanHeader.EndX = zeros(1, header.NumBScans, 'double');
BScanHeader.EndY = zeros(1, header.NumBScans, 'double');
BScanHeader.NumSeg = zeros(1, header.NumBScans, 'int32');
BScanHeader.Quality = zeros(1, header.NumBScans, 'single');
BScanHeader.Shift = zeros(1, header.NumBScans, 'int32');
BScanHeader.ILM = zeros(header.NumBScans,header.SizeX, 'single');
BScanHeader.RPE = zeros(header.NumBScans,header.SizeX, 'single');
BScanHeader.NFL = zeros(header.NumBScans,header.SizeX, 'single');

% disp(['---------------------------------------------']);
% disp(['           Version: ' char(header.Version')]);
% disp(['             SizeX: ' num2str(header.SizeX)]);
% disp(['         NumBScans: ' num2str(header.NumBScans)]);
% disp(['             SizeZ: ' num2str(header.SizeZ)]);
% disp(['            ScaleX: ' num2str(header.ScaleX) ' mm']);
% disp(['          Distance: ' num2str(header.Distance) ' mm']);
% disp(['            ScaleZ: ' num2str(header.ScaleZ) ' mm']);
% disp(['          SizeXSlo: ' num2str(header.SizeXSlo)]);
% disp(['          SizeYSlo: ' num2str(header.SizeYSlo)]);
% disp(['         ScaleXSlo: ' num2str(header.ScaleXSlo) ' mm']);
% disp(['         ScaleYSlo: ' num2str(header.ScaleYSlo) ' mm']);
% disp(['FieldSizeSlo (FOV): ' num2str(header.FieldSizeSlo) 'ï?½']);
% disp(['         ScanFocus: ' num2str(header.ScanFocus) ' dpt']);
% disp(['      ScanPosition: ' char(header.ScanPosition)]);
% disp(['          ExamTime: ' datestr(header.ExamTime(1)/(1e7*60*60*24)+584755+(2/24))]);
% disp(['       ScanPattern: ' num2str(header.ScanPattern)]);
% disp(['      BScanHdrSize: ' num2str(header.BScanHdrSize) ' bytes']);
% disp(['                ID: ' char(header.ID)]);
% disp(['       ReferenceID: ' char(header.ReferenceID)]);
% disp(['               PID: ' num2str(header.PID)]);
% disp(['         PatientID: ' char(header.PatientID)]);
% disp(['               DOB: ' datestr(header.DOB+693960)]);
% disp(['               VID: ' num2str(header.VID)]);
% disp(['           VisitID: ' char(header.VisitID)]);
% disp(['         VisitDate: ' datestr(header.VisitDate+693960)]);
% disp(['          GridType: ' num2str(header.GridType)]);
% disp(['        GridOffset: ' num2str(header.GridOffset)]);
% disp(['---------------------------------------------']);

OCTs = zeros(SizeZ,SizeX,NumBScans);
StartX_px=zeros(NumBScans,1); %StartX in pixels
StartY_px=zeros(NumBScans,1); %StartY in pixels
EndX_px=zeros(NumBScans,1); %EndX in pixels
EndY_px=zeros(NumBScans,1); 

for ii=1:NumBScans
    i = ii-1;
    
    BsBlkSize = BScanHdrSize + SizeZ * SizeX * 4;
    BsBlkOffs =2048 + SloImageSize + i * BsBlkSize;
    
    status = fseek( fid, 16+2048+(header.SizeXSlo*header.SizeYSlo)+(i*(header.BScanHdrSize+header.SizeX*header.SizeZ*4)), -1 );
    StartX = fread( fid, 1, 'double' );
    StartY = fread( fid, 1, 'double' );
    EndX = fread( fid, 1, 'double' );
    EndY = fread( fid, 1, 'double' );
    NumSeg = fread( fid, 1, 'int32' );
    OffSeg = fread( fid, 1, 'int32' );
    Quality = fread( fid, 1, 'float32' );
    Shift = fread( fid, 1, 'int32' );
    
    BScanHeader.StartX(ii) = StartX;
    BScanHeader.StartY(ii) = StartY;
    BScanHeader.EndX(ii) = EndX;
    BScanHeader.EndY(ii) = EndY;
    BScanHeader.NumSeg(ii) = NumSeg;
    BScanHeader.Shift(ii) = Shift;
    BScanHeader.Quality(ii) = Quality;
    
    StartX_px(ii)=round(StartX/(header.SizeXSlo*header.ScaleXSlo)*header.SizeXSlo); %StartX in pixels
    StartY_px(ii)=round(StartY/(header.SizeYSlo*header.ScaleYSlo)*header.SizeYSlo); %StartY in pixels
    EndX_px(ii)=round(EndX/(header.SizeXSlo*header.ScaleXSlo)*header.SizeXSlo); %EndX in pixels
    EndY_px(ii)=round(EndY/(header.SizeYSlo*header.ScaleYSlo)*header.SizeYSlo); %EndY in pixels
%     subplot(1,2,1); line([StartX_px(ii) EndX_px(ii)],[StartY_px(ii) EndY_px(ii)]);
    
    %B Scan Data
    BscanSize = SizeZ * SizeX ;
    BsOffs = BsBlkOffs + BScanHdrSize;
    fseek(fid, BsOffs,-1);
    Bscan_Image=fread(fid,BscanSize,'float32');
    
    Im_OCT = reshape(Bscan_Image,SizeX,SizeZ);
    Im_OCT = flipud( Im_OCT );
    Im_OCT = rot90( Im_OCT, 3);
    OCTs (:,:,ii)=(Im_OCT).^.25;
%     subplot(1,2,2);
%     imshow((Im_OCT).^.25,[])
%     drawnow
%     F(ii) =getframe(gcf);
   
end
NumBScans = header.NumBScans;
% disp(['        @ SLO result is saved in "Im_SLO_Image". ' ]);
% disp(['        @ BScan results are saved in "OCTs". ' ]);
% disp(['        @ Header results are saved in an structure "header". ' ]);
% disp(['        @ B Scan Header results are saved in an structure "BScanHeader". ' ]);

% for i=1:NumBScans
%     figure, imshow(OCTs(:,:,i),[])
% end
% movie2avi(F , 'aa.avi','compression','None')