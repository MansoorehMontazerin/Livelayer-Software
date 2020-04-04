function [ s ] = readbin(filename)
% [ s ] = readbin(filename)
% read a bin file writen by C++ class CVMatTreeStructBin
% Input  : a bin file
% Output : a data structure contains strings, scalare, 2D matrics, cellarrays, structures

% this file is generated by CVMatTreeStructBin::writeMatlabReadCode
	fileID = fopen(filename);
	if fileID == -1
		error(['cant open file ' filename]);
	end

	magic    = fread(fileID, 8, 'char');
	if strcmp(convertChar2String(magic), 'CVMatBin') == false
		error('not a bin file')
	end
	version  = fread(fileID, 1, 'uint32');
	assert(version == 1);
	           fread(fileID, 4, 'uint32');
	s  = readNode(fileID);
	fclose(fileID);
end


function [node] = readNode(fileID)
	type  = fread(fileID, 1, 'uint32');
	switch(type)
		case 0
			% node not written because unhandled type
			node = [];
		case 1
			node = readDir(fileID);
		case 3
			node = readMat(fileID);
		case 2
			node = readList(fileID);
		case 4
			node = readString(fileID);
		otherwise
			fprintf('unknown node type %d\n', type);
			node = [];
	end
end

function [node] = readDir(fileID)
	dirLength  = fread(fileID, 1, 'uint32');
	for i=1:dirLength
		name        = readString(fileID);
		node.(name) = readNode(fileID);
	end
end

function [node] = readList(fileID)
	dirLength  = fread(fileID, 1, 'uint32');
	node = cell(1, dirLength);
	for i=1:dirLength
		node{i} = readNode(fileID);
	end
end

function [string] = readString(fileID)
	stringLength  = fread(fileID, 1, 'uint32');
	str    = fread(fileID, stringLength, 'char');
	string = convertChar2String(str);
end

function [string] = convertChar2String(str)
	string = sprintf('%s', str);
end

function [mat] = readMat(fileID)
	data     = fread(fileID, 8, 'uint32=>uint32');
	type     = data(1);
	channels = data(2);
	rows     = data(3);
	cols     = data(4);
	% data(5) - data(8) unused
	switch type
		case 0 % OpenCV type for uint8_t
			mat = fread(fileID, [cols rows], 'uint8=>uint8')';
		case 2 % OpenCV type for uint16_t
			mat = fread(fileID, [cols rows], 'uint16=>uint16')';
		case 7 % OpenCV type for uint32_t
			mat = fread(fileID, [cols rows], 'uint32=>uint32')';
		case 7 % OpenCV type for uint64_t
			mat = fread(fileID, [cols rows], 'uint64=>uint64')';
		case 1 % OpenCV type for int8_t
			mat = fread(fileID, [cols rows], 'int8=>int8')';
		case 3 % OpenCV type for int16_t
			mat = fread(fileID, [cols rows], 'int16=>int16')';
		case 4 % OpenCV type for int32_t
			mat = fread(fileID, [cols rows], 'int32=>int32')';
		case 7 % OpenCV type for int64_t
			mat = fread(fileID, [cols rows], 'int64=>int64')';
		case 5 % OpenCV type for float
			mat = fread(fileID, [cols rows], 'single=>single')';
		case 6 % OpenCV type for double
			mat = fread(fileID, [cols rows], 'double=>double')';
	end
end