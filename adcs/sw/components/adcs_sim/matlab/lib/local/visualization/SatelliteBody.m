 classdef SatelliteBody < handle
    
   properties (SetAccess=private)
    Body = gobjects(1,1);
    velocityVector; sunVector; gsVector;
    velocityVectorVal = [.2,0,0];
    sunVectorVal = [0,.2,0];
    gsVectorVal = [0,0,.2];
    satQuat = [1,0,0,0];
    color = [1 0 0]; % RGB
   end
   
   methods
       function obj = SatelliteBody()
           obj.makeSat();
           obj.updateTransforms();
       end
       function setQuat(obj,q1,q2,q3,q4)
           obj.satQuat = [q1,q2,q3,q4];
           obj.updateTransforms();
       end
       function setVecs(obj,v,gs,sun)
           obj.velocityVectorVal = v;
           obj.gsVectorVal = gs;
           obj.sunVectorVal = sun;
           obj.updateVectors();
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
            %Should set based on fsw_params
            dims=[.1 .1 .37]';
            [V,F]  = spacecraftBody(dims);
            fig = figure;
            dz = dims(3);
            ax = axes('Parent',fig);
            patch_handle = patch('Vertices',V,'Faces',F,'FaceVertexCData',obj.color,...
                    'FaceColor','flat');
            axis([-dz dz -dz dz -dz dz]);
            title('Body in ECI coordinates');
            xlabel('x-axis')
            ylabel('y-axis')
            zlabel('z-axis')
            grid on
            box on
            hold on
            obj.velocityVector = quiver3(0,0,0,obj.velocityVectorVal(1),obj.velocityVectorVal(2),obj.velocityVectorVal(3));
            obj.sunVector = quiver3(0,0,0,obj.sunVectorVal(1),obj.sunVectorVal(2),obj.sunVectorVal(3));
            obj.gsVector = quiver3(0,0,0,obj.gsVectorVal(1),obj.gsVectorVal(2),obj.gsVectorVal(3));
            obj.Body = hgtransform('Parent',ax)
            set(patch_handle,'Parent',obj.Body)
       end
       function updateTransforms(obj)
           obj.Body.Matrix = [quat2rotm(quatconj(obj.satQuat)),zeros(3,1);zeros(1,3),1];
       end
       function updateVectors(obj)
           obj.velocityVector.UData = obj.velocityVectorVal(1);
           obj.velocityVector.VData = obj.velocityVectorVal(2);
           obj.velocityVector.WData = obj.velocityVectorVal(3);
           obj.sunVector.UData = obj.sunVectorVal(1);
           obj.sunVector.VData = obj.sunVectorVal(2);
           obj.sunVector.WData = obj.sunVectorVal(3);
           obj.gsVector.UData = obj.gsVectorVal(1);
           obj.gsVector.VData = obj.gsVectorVal(2);
           obj.gsVector.WData = obj.gsVectorVal(3);
       end
   end
end