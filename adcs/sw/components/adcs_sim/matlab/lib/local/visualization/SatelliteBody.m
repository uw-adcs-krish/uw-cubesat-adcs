 classdef SatelliteBody < handle
    
   properties (SetAccess=private)
    Body = gobjects(1,1);
    sunVector = [1,0,0];
    gsVector = [0,1,0];
    satQuat = [1,0,0,0];
    color = [1 0 0]; % RGB
   end
   
   methods
       function obj = SatelliteBody()
           obj.makeSat();
           obj.updateTransforms();
       end
       function setQuat(obj,q1,q2,q3,q4)
           obj.satQuat = [q1,q2,q3,q1];
           obj.updateTransforms();
       end
       function r = isAlive(obj)
           r = isvalid(obj) && isvalid(obj.Body);
       end
       function reset(obj)
           obj.setQuat(1,0,0,0);
       end
   end 
   methods (Access=private)
       function makeSat(obj)
            dims=[.1 .1 .37]';
            [V,F]  = spacecraftBody(dims);
            fig = figure;
            dz = dims(3);
            ax = axes('Parent',fig);
            patch_handle = patch('Vertices',V,'Faces',F,'FaceVertexCData',obj.color,...
                    'FaceColor','flat');
            axis([-dz dz -dz dz -dz dz]);
            obj.Body = hgtransform('Parent',ax)
            set(patch_handle,'Parent',obj.Body)
       end
       function updateTransforms(obj)
           obj.Body.Matrix = [quat2rotm(obj.satQuat),zeros(3,1);zeros(1,3),1];
       end
   end
end