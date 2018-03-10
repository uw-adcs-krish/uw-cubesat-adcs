function [ V,F ] = spacecraftBody(dims)

dx = dims(1);
dy = dims(2);
dz = dims(3);

V     = [ ...
    dx/2    dy/2   0;% 1 (1)
    dx/2   -dy/2   0;% 2 (2)
   -dx/2   -dy/2   0;% 3 (3)
   -dx/2    dy/2   0;% 4 (4)
    dx/2    dy/2   0;% 5 (1)
    dx/2    dy/2  dz;% 6 (6)
    dx/2   -dy/2  dz;% 7 (7)
    dx/2   -dy/2   0;% 8 (2)
    dx/2   -dy/2  dz;% 9 (7)
   -dx/2   -dy/2  dz;% 10 (8)
   -dx/2   -dy/2   0;% 11 (3)
   -dx/2   -dy/2  dz;% 12 (8)
   -dx/2    dy/2  dz;% 13 (9)
   -dx/2    dy/2   0;% 14 (4)
   -dx/2    dy/2  dz;% 15 (4)
    dx/2    dy/2  dz;% 16 (6)
    dx/2    dy/2   0];% 17 (1)
    

F   = [ ...
        1 4 13 6;
        1 6 7 2;
        2 7 10 3;
        3 10 13 4;
        6 7 10 13;
        1 4 3 2];

end

