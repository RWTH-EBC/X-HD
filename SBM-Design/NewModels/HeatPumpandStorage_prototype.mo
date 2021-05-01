within Configurations.NewModels;
model HeatPumpandStorage_prototype
  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    useHeatingCoil2=false,
    useHeatingRod=false,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC1 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    n=5,
    alphaHC1=100,
    useHeatingCoil1=false,
    data=AixLib.DataBase.Storage.Generic_New_2000l(),
    TStart=308.15)
    annotation (Placement(transformation(extent={{-6,-30},{18,0}})));

  AixLib.Fluid.Sources.Boundary_pT bou(          redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=1,
    p=200000)
    annotation (Placement(transformation(extent={{102,-58},{90,-46}})));
  AixLib.Fluid.Movers.FlowControlled_m_flow pumpHP(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    dp_nominal=500,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    m_flow_nominal=2)
    annotation (Placement(transformation(extent={{-14,-42},{-34,-22}})));

  AixLib.Fluid.HeatExchangers.HeaterCooler_u Heatdemand(
    m_flow_nominal=2,
    dp_nominal=500,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,

    Q_flow_nominal=-6850) "Cooler"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={64,10})));
  AixLib.Fluid.Movers.FlowControlled_m_flow pumpHC(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    dp_nominal=500,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    m_flow_nominal=2)
    annotation (Placement(transformation(extent={{64,-42},{44,-22}})));

  Modelica.Blocks.Sources.Constant TMin(k=313.15)
    annotation (Placement(transformation(extent={{-74,68},{-64,78}})));
  Modelica.Blocks.Sources.Constant TMax(k=333.15)
    annotation (Placement(transformation(extent={{-74,52},{-64,62}})));
  AixLib.Utilities.Logical.SmoothSwitch switchHP_Pump annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={36,52})));
  Modelica.Blocks.Sources.Constant HeatPump_On(k=1)
    annotation (Placement(transformation(extent={{-10,84},{0,94}})));
  Modelica.Blocks.Sources.Constant HeatPump_off(k=0)
    annotation (Placement(transformation(extent={{-4,62},{6,72}})));
  AixLib.Fluid.HeatExchangers.HeaterCooler_u HeatPump_ideal(
    m_flow_nominal=2,
    dp_nominal=500,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    Q_flow_nominal=6850,
    show_T=true)         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-20})));

  AixLib.Fluid.HeatExchangers.HeaterCooler_u HeatingCoil(
    m_flow_nominal=2,
    dp_nominal=500,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    Q_flow_nominal=6850) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,26})));

  DataBase.Tamb_TRYAachen tamb_TRYAachen
    annotation (Placement(transformation(extent={{-212,32},{-192,52}})));
  DataBase.Tamb_TRYAachen tamb_TRYAachen1
    annotation (Placement(transformation(extent={{-30,-88},{-16,-74}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{-4,-88},{6,-78}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{34,-80},{42,-72}})));
  Modelica.Blocks.Interfaces.RealOutput COP_t
    annotation (Placement(transformation(extent={{54,-82},{66,-70}})));
  AixLib.Utilities.Logical.SmoothSwitch switch2
    annotation (Placement(transformation(extent={{22,-62},{30,-54}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-4,-58},{4,-50}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1
    annotation (Placement(transformation(extent={{-4,-70},{4,-62}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{8,-62},{16,-54}})));
  Modelica.Blocks.Sources.Constant HeatingCoil_on1(k=0.5)
    annotation (Placement(transformation(extent={{10,-70},{16,-64}})));
  AixLib.Utilities.Logical.SmoothSwitch switch3
    annotation (Placement(transformation(extent={{20,-86},{28,-78}})));
  Modelica.Blocks.Sources.Constant HeatingCoil_on2(k=1)
    annotation (Placement(transformation(extent={{8,-92},{14,-86}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        291.15)
    annotation (Placement(transformation(extent={{36,-20},{26,-10}})));
  General.Hysteresis_control hysteresis_control
    annotation (Placement(transformation(extent={{-46,60},{-26,72}})));
  General.Heatratio_calc heatratio_calc
    annotation (Placement(transformation(extent={{22,26},{38,38}})));
  DataBase.dotQ_ref dotQ_ref
    annotation (Placement(transformation(extent={{8,32},{16,40}})));
  Modelica.Blocks.Sources.Constant dotQ_design_demand(k=-Heatdemand.Q_flow_nominal)
    annotation (Placement(transformation(extent={{4,16},{14,26}})));
  Modelica.Blocks.Sources.BooleanConstant Bivalence_on
    annotation (Placement(transformation(extent={{-98,82},{-84,96}})));
  Modelica.Blocks.Math.Division division1
    annotation (Placement(transformation(extent={{-86,32},{-78,40}})));
  Modelica.Blocks.Sources.Constant QHeatingrod_nom(k=6850)
    annotation (Placement(transformation(extent={{-102,28},{-92,38}})));
equation
  connect(bufferStorage.fluidportBottom1, pumpHP.port_a) annotation (Line(
        points={{1.95,-30.3},{1.95,-32.15},{-14,-32.15},{-14,-32}}, color={0,
          127,255}));
  connect(pumpHC.port_b, bufferStorage.fluidportBottom2) annotation (Line(
        points={{44,-32},{34,-32},{24,-32},{24,-30.15},{9.45,-30.15}},
                                                               color={0,127,255}));
  connect(Heatdemand.port_b, pumpHC.port_a) annotation (Line(points={{74,10},{
          80,10},{80,-32},{64,-32}},
                                 color={0,127,255}));
  connect(bou.ports[1], pumpHC.port_a) annotation (Line(points={{90,-52},{86,
          -52},{86,-32},{64,-32}}, color={0,127,255}));
  connect(bufferStorage.fluidportTop2, Heatdemand.port_a) annotation (Line(
        points={{9.75,0.15},{14.875,0.15},{14.875,10},{54,10}},  color={0,127,
          255}));
  connect(HeatPump_On.y, switchHP_Pump.u1) annotation (Line(points={{0.5,89},{
          0.5,81.5},{40.8,81.5},{40.8,59.2}}, color={0,0,127}));
  connect(HeatPump_off.y, switchHP_Pump.u3) annotation (Line(points={{6.5,67},{
          6.5,67.5},{31.2,67.5},{31.2,59.2}}, color={0,0,127}));
  connect(pumpHP.port_b, HeatPump_ideal.port_a) annotation (Line(points={{-34,-32},
          {-80,-32},{-80,-30}},           color={0,127,255}));
  connect(switchHP_Pump.y, HeatPump_ideal.u) annotation (Line(points={{36,45.4},
          {-102,45.4},{-102,-32},{-86,-32}}, color={0,0,127}));
  connect(switchHP_Pump.y, pumpHP.m_flow_in) annotation (Line(points={{36,45.4},
          {-24,45.4},{-24,-20}}, color={0,0,127}));
  connect(HeatingCoil.port_b, bufferStorage.fluidportTop1) annotation (Line(
        points={{-40,26},{2,26},{2,0.15},{1.8,0.15}}, color={0,127,255}));
  connect(division.y, COP_t)
    annotation (Line(points={{42.4,-76},{60,-76}}, color={0,0,127}));
  connect(add.y, greaterThreshold1.u) annotation (Line(points={{6.5,-83},{6.5,
          -73.5},{-4.8,-73.5},{-4.8,-66}}, color={0,0,127}));
  connect(greaterThreshold.y, and1.u1) annotation (Line(points={{4.4,-54},{7.2,
          -54},{7.2,-58}}, color={255,0,255}));
  connect(greaterThreshold1.y, and1.u2) annotation (Line(points={{4.4,-66},{7.2,
          -66},{7.2,-61.2}}, color={255,0,255}));
  connect(and1.y, switch2.u2) annotation (Line(points={{16.4,-58},{18,-58},{
          21.2,-58}}, color={255,0,255}));
  connect(HeatingCoil_on1.y, switch2.u3) annotation (Line(points={{16.3,-67},{
          16.3,-64.5},{21.2,-64.5},{21.2,-61.2}}, color={0,0,127}));
  connect(switch2.y, division.u1) annotation (Line(points={{30.4,-58},{33.2,-58},
          {33.2,-73.6}}, color={0,0,127}));
  connect(add.y, switch3.u1) annotation (Line(points={{6.5,-83},{13.25,-83},{
          13.25,-78.8},{19.2,-78.8}}, color={0,0,127}));
  connect(and1.y, switch3.u2) annotation (Line(points={{16.4,-58},{19.2,-58},{
          19.2,-82}}, color={255,0,255}));
  connect(HeatingCoil_on2.y, switch3.u3) annotation (Line(points={{14.3,-89},{
          17.15,-89},{17.15,-85.2},{19.2,-85.2}}, color={0,0,127}));
  connect(switch3.y, division.u2) annotation (Line(points={{28.4,-82},{30,-82},
          {30,-78.4},{33.2,-78.4}}, color={0,0,127}));
  connect(fixedTemperature.port, bufferStorage.heatportOutside) annotation (
      Line(points={{26,-15},{22,-15},{22,-14.1},{17.7,-14.1}}, color={191,0,0}));
  connect(tamb_TRYAachen1.y, add.u1) annotation (Line(points={{-15.3,-81},{-10,
          -81},{-10,-80},{-5,-80}}, color={0,0,127}));
  connect(HeatPump_ideal.port_b, HeatingCoil.port_a) annotation (Line(points={{
          -80,-10},{-80,-10},{-80,26},{-60,26}}, color={0,127,255}));
  connect(bufferStorage.TTop, greaterThreshold.u)
    annotation (Line(points={{-6,-1.8},{-6,-54},{-4.8,-54}}, color={0,0,127}));
  connect(bufferStorage.TTop, switch2.u1) annotation (Line(points={{-6,-1.8},{8,
          -1.8},{8,-54.8},{21.2,-54.8}}, color={0,0,127}));
  connect(bufferStorage.TTop, add.u2)
    annotation (Line(points={{-6,-1.8},{-6,-86},{-5,-86}}, color={0,0,127}));
  connect(TMin.y, hysteresis_control.T_Min) annotation (Line(points={{-63.5,73},
          {-55.75,73},{-55.75,65},{-46.8,65}}, color={0,0,127}));
  connect(TMax.y, hysteresis_control.T_Max) annotation (Line(points={{-63.5,57},
          {-54.75,57},{-54.75,60},{-46.8,60}}, color={0,0,127}));
  connect(bufferStorage.TTop, hysteresis_control.T_Top) annotation (Line(points
        ={{-6,-1.8},{-106,-1.8},{-106,70},{-46.8,70}}, color={0,0,127}));
  connect(hysteresis_control.WP_an, switchHP_Pump.u2) annotation (Line(points={
          {-25,63.8},{6,63.8},{6,59.2},{36,59.2}}, color={255,0,255}));
  connect(dotQ_ref.y, heatratio_calc.dotQ_actual) annotation (Line(points={{
          16.4,36},{21.52,36},{21.52,35.6}}, color={0,0,127}));
  connect(dotQ_design_demand.y, heatratio_calc.dotQ_design) annotation (Line(
        points={{14.5,21},{14.5,24.5},{21.52,24.5},{21.52,28.4}}, color={0,0,
          127}));
  connect(heatratio_calc.y_Heater, Heatdemand.u) annotation (Line(points={{
          38.48,32},{44,32},{44,16},{52,16}}, color={0,0,127}));
  connect(heatratio_calc.y_Heater, pumpHC.m_flow_in) annotation (Line(points={{
          38.48,32},{92,32},{92,-20},{54,-20}}, color={0,0,127}));
  connect(Bivalence_on.y, hysteresis_control.Bivalence_true) annotation (Line(
        points={{-83.3,89},{-42.65,89},{-42.65,71.4},{-42,71.4}}, color={255,0,
          255}));
  connect(HeatPump_ideal.Q_flow, hysteresis_control.Q_HP_actual) annotation (
      Line(points={{-86,-9},{-116,-9},{-116,71.3},{-35.9,71.3}}, color={0,0,127}));
  connect(Heatdemand.Q_flow, hysteresis_control.Q_demand) annotation (Line(
        points={{75,16},{78,16},{78,71.3},{-29.9,71.3}}, color={0,0,127}));
  connect(division1.y, HeatingCoil.u) annotation (Line(points={{-77.6,36},{-70,
          36},{-70,32},{-62,32}}, color={0,0,127}));
  connect(hysteresis_control.heatingRod_dotQ, division1.u1) annotation (Line(
        points={{-36,57.2},{-62,57.2},{-62,38.4},{-86.8,38.4}}, color={0,0,127}));
  connect(QHeatingrod_nom.y, division1.u2) annotation (Line(points={{-91.5,33},
          {-89.75,33},{-89.75,33.6},{-86.8,33.6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-46,94},{-20,86}},
          lineColor={28,108,200},
          textString="HeatPump_Control"),
        Rectangle(
          extent={{54,-96},{-32,-50}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-30,-54},{-8,-62}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString="Carnot-
Berechnung
")}));
end HeatPumpandStorage_prototype;
