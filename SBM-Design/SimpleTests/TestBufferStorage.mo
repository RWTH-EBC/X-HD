within Configurations.SimpleTests;
model TestBufferStorage
  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    useHeatingCoil2=false,
    useHeatingRod=false,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare package MediumHC1 = Modelica.Media.Water.StandardWater,
    redeclare package MediumHC2 = Modelica.Media.Water.StandardWater,
    useHeatingCoil1=false)
    annotation (Placement(transformation(extent={{30,-20},{58,14}})));
  AixLib.Fluid.Sources.MassFlowSource_T m_flowSourceBufferHC(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_m_flow_in=false,
    m_flow=0.5,
    T=283.15) annotation (Placement(transformation(extent={{98,-56},{78,-36}})));
  AixLib.Fluid.Sources.FixedBoundary boundaryBufferOutHC(redeclare package
      Medium = Modelica.Media.Water.StandardWater, nPorts=1)
    annotation (Placement(transformation(extent={{100,28},{80,48}})));
  AixLib.Fluid.HeatPumps.HeatPumpDetailed heatPumpDetailed(
    capCalcType=2,
    redeclare package Medium_con = Modelica.Media.Water.StandardWater,
    redeclare package Medium_eva = Modelica.Media.Air.DryAirNasa,
    P_eleOutput=true,
    CoP_output=true)
    annotation (Placement(transformation(extent={{-60,-14},{-30,6}})));
  AixLib.Fluid.Sources.MassFlowSource_T boundaryEva(
    nPorts=1,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=10,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-78,30})));
  DataBase.Tamb_TRYAachen_2a tamb_TRYAachen
    annotation (Placement(transformation(extent={{-102,56},{-82,76}})));
  AixLib.Fluid.Sources.FixedBoundary boundaryEvaOut(nPorts=1, redeclare package
      Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{-92,-26},{-72,-6}})));
  Modelica.Blocks.Sources.BooleanConstant HeatPump_on(k=true)
    annotation (Placement(transformation(extent={{-68,66},{-54,80}})));
  AixLib.Fluid.Movers.Pump pump(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow_start=2,
    m_flow_small=0.01)
    annotation (Placement(transformation(extent={{14,-38},{-6,-18}})));
  Modelica.Blocks.Sources.BooleanConstant night_off(k=false)
    annotation (Placement(transformation(extent={{-26,26},{-12,40}})));
equation
  connect(m_flowSourceBufferHC.ports[1], bufferStorage.fluidportBottom2)
    annotation (Line(points={{78,-46},{66,-46},{66,-20.17},{48.025,-20.17}},
        color={0,127,255}));
  connect(bufferStorage.fluidportTop2, boundaryBufferOutHC.ports[1])
    annotation (Line(points={{48.375,14.17},{48.4375,14.17},{48.4375,38},{80,38}},
        color={0,127,255}));
  connect(heatPumpDetailed.port_conOut, bufferStorage.fluidportTop1)
    annotation (Line(points={{-32,3},{-16,3},{-16,14.17},{39.1,14.17}}, color={
          0,127,255}));
  connect(tamb_TRYAachen.y, boundaryEva.T_in) annotation (Line(points={{-81,66},
          {-78,66},{-78,42},{-74,42}}, color={0,0,127}));
  connect(boundaryEva.ports[1], heatPumpDetailed.port_evaIn) annotation (Line(
        points={{-78,20},{-68,20},{-68,3},{-58,3}}, color={0,127,255}));
  connect(heatPumpDetailed.port_evaOut, boundaryEvaOut.ports[1]) annotation (
      Line(points={{-58,-11},{-66,-11},{-66,-16},{-72,-16}}, color={0,127,255}));
  connect(HeatPump_on.y, heatPumpDetailed.onOff_in) annotation (Line(points={{
          -53.3,73},{-53.3,39.5},{-50,39.5},{-50,5}}, color={255,0,255}));
  connect(pump.port_b, heatPumpDetailed.port_conIn) annotation (Line(points={{
          -6,-28},{-20,-28},{-20,-11},{-32,-11}}, color={0,127,255}));
  connect(pump.port_a, bufferStorage.fluidportBottom1) annotation (Line(points=
          {{14,-28},{28,-28},{28,-20.34},{39.275,-20.34}}, color={0,127,255}));
  connect(night_off.y, pump.IsNight) annotation (Line(points={{-11.3,33},{-11.3,
          7.5},{4,7.5},{4,-17.8}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestBufferStorage;
