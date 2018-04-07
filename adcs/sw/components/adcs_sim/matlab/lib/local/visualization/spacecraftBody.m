function [ V,F ] = spacecraftBody(dims)

%Ideally this takes in fsw_params so that we have the actual center of mass
%and dimensions
dx = dims(1);
dy = dims(2);
dz = dims(3);

V     = [ ...
        -dx/2	dy/2	dz/2	;%	1	-1
        -dx/2	dy/2	-dz/2	;%	2	-2
        -dx/2	-dy/2	-dz/2	;%	3	-3
        -dx/2	-dy/2	dz/2	;%	4	-4
        -dx/2	dy/2	dz/2	;%	5	-1
        dx/2	dy/2	dz/2	;%	6	-6
        dx/2	dy/2	-dz/2	;%	7	-7
        -dx/2	dy/2	-dz/2	;%	8	-2
        dx/2	dy/2	-dz/2	;%	9	-7
        dx/2	-dy/2	-dz/2	;%	10	-8
        -dx/2	-dy/2	-dz/2	;%	11	-3
        dx/2	-dy/2	-dz/2	;%	12	-8
        dx/2	-dy/2	dz/2	;%	13	-9
        -dx/2	-dy/2	dz/2	;%	14	-4
        dx/2	-dy/2	dz/2	;%	15	-4
        dx/2	dy/2	dz/2	;%	16	-6
        -dx/2	dy/2	dz/2	;%	17	-1
    
    %Solar face
    3*dx/2    dy/2   dz/2;% 18 (10)
    3*dx/2    dy/2   -dz/2;% 19 (11)
    -3*dx/2   dy/2   -dz/2;% 20 (12)
    -3*dx/2   dy/2   dz/2;% 21 (13)
    
    %PPT square
     dx/4     dy/4 -1.03*dz/2;% 22 (10)
     dx/4     -dy/4 -1.03*dz/2;% 23 (11)
     -dx/4    -dy/4 -1.03*dz/2;% 24 (12)
     -dx/4    dy/4 -1.03*dz/2]; %25
    

F   = [ ...
        18 19 20 21;
        22 23 24 25;
        1 4 15 6;
        2 7 10 3;
        3 10 13 4;
        6 7 10 13;
        1 4 3 2];

end

