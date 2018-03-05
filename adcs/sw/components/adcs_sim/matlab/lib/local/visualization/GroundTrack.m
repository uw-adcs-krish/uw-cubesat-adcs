 classdef GroundTrack < handle
    
   properties (SetAccess=private)
    Trace = gobjects(1,1);
    satPos = [0;0];
   end
   
   methods
       function obj = GroundTrack()
           obj.makeImage();
       end
       function updateSat(obj,a1,a2)
           obj.satPos = [a1,a2];
           obj.addTracePoint()
       end
       function clearPoints(obj)
           obj.Trace.clearpoints();
       end
       function r = isAlive(obj)
           r = isvalid(obj) && isvalid(obj.Trace);
       end
   end 
   methods (Access=private)
       function makeImage(obj)
           fig = figure;
           ax = axes('Parent',fig);
            axis([-180 180 -90 90]);
            Earth_im = imread('Flat_earth.jpg');
            imagesc([-180 180],[-90 90],flipud(Earth_im));
            set(gca,'YDir','normal');
            obj.Trace = animatedline('Parent',ax,'Color','red','LineWidth',2)
       end
       function addTracePoint(obj)
           %Longitude comes first, then latitude
           obj.Trace.addpoints(obj.satPos(2),obj.satPos(1));
       end
   end
end