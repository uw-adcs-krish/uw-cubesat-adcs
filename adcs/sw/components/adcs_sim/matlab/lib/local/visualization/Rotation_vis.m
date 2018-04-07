function Rotation_vis(block)
    setup(block)
end

%
% Called when the block is added to a model.
function setup(block)
  %
  % 1 input port, no output ports
  block.NumInputPorts  = 4;
  block.NumOutputPorts = 0;
  %
  % Setup functional port properties
  block.SetPreCompInpPortInfoToDynamic;
  %
  % The input is a quaternion and the spacecraft dimensions
  block.InputPort(1).Dimensions = 4;
  block.InputPort(2).Dimensions = 3;
  block.InputPort(3).Dimensions = 3;
  block.InputPort(4).Dimensions = 3;


  %
  % Register block methods
  block.RegBlockMethod('Start',   @Start);
  block.RegBlockMethod('Outputs', @Output);
  %
  % To work in external mode
  block.SetSimViewingDevice(true);
end
%
% Called when the simulation starts.
function Start(block)
  %
  % Check to see if we already have an instance of Satellite
  ud = get_param(block.BlockHandle,'UserData');
  if isempty(ud)
    vis = [];
  else
    vis = ud.vis;
  end
  %
  % If not, create one
  if isempty(vis) || ~isa(vis,'SatelliteBody') || ~vis.isAlive
    vis = SatelliteBody();
  else
    vis.reset();
  end
  ud.vis = vis;
  %
  % Save it in UserData
  set_param(block.BlockHandle,'UserData',ud);
end
%
% Called when the simulation time changes.
function Output(block)
  if block.IsMajorTimeStep
    ud = get_param(block.BlockHandle,'UserData');
    vis = ud.vis;
    if isempty(vis) || ~isa(vis,'SatelliteBody') || ~vis.isAlive
      return;
    end
    vis.setQuat(block.InputPort(1).Data(1), block.InputPort(1).Data(2),...
        block.InputPort(1).Data(3), block.InputPort(1).Data(4));
    vis.setVecs(block.InputPort(2).Data,block.InputPort(3).Data,block.InputPort(4).Data)
  end
end