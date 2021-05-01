within Configurations.SimpleTests;
model TestPumps
  AixLib.Fluid.HeatExchangers.HeaterCooler_u HeatPump_ideal(
    show_T=true,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    linearizeFlowResistance=false,
    Q_flow_nominal=50,
    m_flow_nominal=1,
    dp_nominal=25000)    annotation (Placement(transformation(
        extent={{-12,-10},{12,10}},
        rotation=90,
        origin={-56,10})));
  AixLib.Fluid.Movers.FlowControlled_dp fan1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 per,
    dp_nominal=25000,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    m_flow_nominal=1,
    nominalValuesDefineDefaultPressureCurve=true)
    annotation (Placement(transformation(extent={{-14,-42},{-34,-22}})));

  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    useHeatingCoil2=false,
    useHeatingRod=false,
    n=5,
    alphaHC1=100,
    useHeatingCoil1=false,
    data=AixLib.DataBase.Storage.Generic_New_2000l(),
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC1 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    TStart=308.15)
    annotation (Placement(transformation(extent={{20,-10},{44,20}})));
  AixLib.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    p=200000,
    nPorts=1)
    annotation (Placement(transformation(extent={{34,-50},{22,-38}})));
  AixLib.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-88,34})));
  Modelica.Blocks.Sources.Pulse pulse1(amplitude=25000, period=1800)
    annotation (Placement(transformation(extent={{-42,46},{-22,66}})));
  Modelica.Blocks.Sources.Pulse pulse2(amplitude=1, period=1800)
    annotation (Placement(transformation(extent={{-106,-44},{-86,-24}})));
equation
  connect(fan1.port_b, HeatPump_ideal.port_a) annotation (Line(points={{-34,-32},
          {-46,-32},{-46,-2},{-56,-2}}, color={0,127,255}));
  connect(HeatPump_ideal.port_b, bufferStorage.fluidportTop1) annotation (Line(
        points={{-56,22},{-14,22},{-14,20.15},{27.8,20.15}}, color={0,127,255}));
  connect(bufferStorage.fluidportBottom1, fan1.port_a) annotation (Line(points=
          {{27.95,-10.3},{7.975,-10.3},{7.975,-32},{-14,-32}}, color={0,127,255}));
  connect(bou1.ports[1], fan1.port_a) annotation (Line(points={{22,-44},{4,-44},
          {4,-32},{-14,-32}}, color={0,127,255}));
  connect(senRelPre.port_a, HeatPump_ideal.port_a) annotation (Line(points={{
          -88,24},{-72,24},{-72,-2},{-56,-2}}, color={0,127,255}));
  connect(senRelPre.port_b, HeatPump_ideal.port_b)
    annotation (Line(points={{-88,44},{-56,44},{-56,22}}, color={0,127,255}));
  connect(pulse1.y, fan1.dp_in) annotation (Line(points={{-21,56},{-22,56},{-22,
          -20},{-24,-20}}, color={0,0,127}));
  connect(pulse2.y, HeatPump_ideal.u) annotation (Line(points={{-85,-34},{-74,
          -34},{-74,-8},{-62,-8},{-62,-4.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestPumps;
