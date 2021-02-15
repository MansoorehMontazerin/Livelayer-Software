function index=irregularity_index(y)

% Finding irregularity index for IPL and OPL layers, by deviding the length
% of the boundary with length of the straight line that connect the two
% end of the boundary.
% The length of a continuous and differentiable curve y from x=a to x=b 
% is given by  \int_a^b \sqrt{(1+(dy/dx)^2} dx.

dif = diff(y);
curve_length = sum(sqrt(1+ dif.^2));

a = [1 y(1)];
b = [numel(y) y(end)];
straight_length = sqrt( (a(1)- b(1))^2 + (a(2)- b(2))^2 );

index = straight_length/curve_length;

end 





