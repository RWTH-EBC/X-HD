within Configurations.Case.Archive;
model HeatPumpandStorage_prototype_oldpumps
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
    annotation (Placement(transformation(extent={{-6,-30},{18,0}})));

  AixLib.Fluid.Sources.Boundary_pT bou(
    nPorts=1,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    p=200000)
    annotation (Placement(transformation(extent={{102,-58},{90,-46}})));
  AixLib.Fluid.Movers.FlowControlled_m_flow pumpHP(
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_nominal=2,
    addPowerToMedium=true,
    dp_nominal=1000)
    annotation (Placement(transformation(extent={{-14,-42},{-34,-22}})));

  AixLib.Fluid.HeatExchangers.HeaterCooler_u Heatdemand(
    m_flow_nominal=2,
    dp_nominal=500,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    Q_flow_nominal=-8000) "Cooler"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={66,10})));

  AixLib.Fluid.Movers.FlowControlled_m_flow pumpHC(
    dp_nominal=500,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    m_flow_nominal=2,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    addPowerToMedium=true)
    annotation (Placement(transformation(extent={{64,-42},{44,-22}})));

  Modelica.Blocks.Sources.Constant TMin(k=323.15)
    annotation (Placement(transformation(extent={{-74,68},{-64,78}})));
  Modelica.Blocks.Sources.Constant TMax(k=328.15)
    annotation (Placement(transformation(extent={{-74,52},{-64,62}})));
  AixLib.Utilities.Logical.SmoothSwitch switchHP_Pump annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={36,52})));
  Modelica.Blocks.Sources.Constant HeatPump_off(k=0)
    annotation (Placement(transformation(extent={{-4,62},{6,72}})));
  AixLib.Fluid.HeatExchangers.HeaterCooler_u HeatPump_ideal(
    m_flow_nominal=2,
    dp_nominal=500,
    show_T=true,
    Q_flow_nominal=10904.159,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
                         annotation (Placement(transformation(
        extent={{-12,-10},{12,10}},
        rotation=90,
        origin={-80,-20})));

  AixLib.Fluid.HeatExchangers.HeaterCooler_u HeatingCoil(
    m_flow_nominal=2,
    dp_nominal=500,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    Q_flow_nominal=6000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,26})));

  DataBase.Tamb_TRYAachen_2a tamb_TRYAachen
    annotation (Placement(transformation(extent={{-212,32},{-192,52}})));
  DataBase.Tamb_TRYAachen_2a tamb_TRYAachen1
    annotation (Placement(transformation(extent={{-38,-90},{-24,-76}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        291.15)
    annotation (Placement(transformation(extent={{36,-20},{26,-10}})));
  General.Hysteresis_control hysteresis_control
    annotation (Placement(transformation(extent={{-46,60},{-26,72}})));
  General.Heatratio_calc heatratio_calc
    annotation (Placement(transformation(extent={{24,26},{40,38}})));
  Modelica.Blocks.Sources.Constant dotQ_design_demand(k=-Heatdemand.Q_flow_nominal)
    annotation (Placement(transformation(extent={{6,12},{16,22}})));
  Modelica.Blocks.Sources.BooleanConstant Bivalence_on
    annotation (Placement(transformation(extent={{-98,82},{-84,96}})));
  Modelica.Blocks.Math.Division division1
    annotation (Placement(transformation(extent={{-80,32},{-72,40}})));
  Modelica.Blocks.Sources.Constant QHeatingrod_nom(k=6000)
    annotation (Placement(transformation(extent={{-98,28},{-88,38}})));
  General.Carnot_calc carnot_calc
    annotation (Placement(transformation(extent={{4,-86},{24,-66}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-32,-68},{-22,-58}})));
  DataBase.dotQ_ref_demand_noDHW dotQ_ref_demand_noDHW
    annotation (Placement(transformation(extent={{2,30},{14,42}})));
  DataBase.dotQ_HP_noDHW dotQ_HP_DIN_noDHW annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-86,-68})));
  Modelica.Blocks.Math.Division division2
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-76,-48})));
  Modelica.Blocks.Sources.Constant HeatPump_On1(k=HeatPump_ideal.Q_flow_nominal)
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=90,
        origin={-67,-67})));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-94,4},{-82,18}})));
  AixLib.Utilities.Logical.SmoothSwitch switchHP_Pump1
                                                      annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-24,10})));
  Modelica.Blocks.Sources.Constant PumpHp_on(k=2) annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-15,35})));
equation
  connect(bufferStorage.fluidportBottom1, pumpHP.port_a) annotation (Line(
        points={{1.95,-30.3},{1.95,-32.15},{-14,-32.15},{-14,-32}}, color={0,
          127,255}));
  connect(pumpHC.port_b, bufferStorage.fluidportBottom2) annotation (Line(
        points={{44,-32},{34,-32},{24,-32},{24,-30.15},{9.45,-30.15}},
                                                               color={0,127,255}));
  connect(Heatdemand.port_b, pumpHC.port_a) annotation (Line(points={{76,10},
          {80,10},{80,-32},{64,-32}},
                                 color={0,127,255}));
  connect(bou.ports[1], pumpHC.port_a) annotation (Line(points={{90,-52},{86,
          -52},{86,-32},{64,-32}}, color={0,127,255}));
  connect(bufferStorage.fluidportTop2, Heatdemand.port_a) annotation (Line(
        points={{9.75,0.15},{14.875,0.15},{14.875,10},{56,10}},  color={0,127,
          255}));
  connect(HeatPump_off.y, switchHP_Pump.u3) annotation (Line(points={{6.5,67},{
          6.5,67.5},{31.2,67.5},{31.2,59.2}}, color={0,0,127}));
  connect(pumpHP.port_b, HeatPump_ideal.port_a) annotation (Line(points={{-34,-32},
          {-80,-32}},                     color={0,127,255}));
  connect(switchHP_Pump.y, HeatPump_ideal.u) annotation (Line(points={{36,45.4},
          {-102,45.4},{-102,-34.4},{-86,-34.4}},
                                             color={0,0,127}));
  connect(HeatingCoil.port_b, bufferStorage.fluidportTop1) annotation (Line(
        points={{-40,26},{2,26},{2,0.15},{1.8,0.15}}, color={0,127,255}));
  connect(fixedTemperature.port, bufferStorage.heatportOutside) annotation (
      Line(points={{26,-15},{22,-15},{22,-14.1},{17.7,-14.1}}, color={191,0,0}));
  connect(HeatPump_ideal.port_b, HeatingCoil.port_a) annotation (Line(points={{-80,-8},
          {-80,-8},{-80,26},{-60,26}},           color={0,127,255}));
  connect(TMin.y, hysteresis_control.T_Min) annotation (Line(points={{-63.5,73},
          {-55.75,73},{-55.75,65},{-46.8,65}}, color={0,0,127}));
  connect(TMax.y, hysteresis_control.T_Max) annotation (Line(points={{-63.5,57},
          {-54.75,57},{-54.75,60},{-46.8,60}}, color={0,0,127}));
  connect(bufferStorage.TTop, hysteresis_control.T_Top) annotation (Line(points=
         {{-6,-1.8},{-106,-1.8},{-106,70},{-46.8,70}}, color={0,0,127}));
  connect(hysteresis_control.WP_an, switchHP_Pump.u2) annotation (Line(points={
          {-25,63.8},{6,63.8},{6,59.2},{36,59.2}}, color={255,0,255}));
  connect(dotQ_design_demand.y, heatratio_calc.dotQ_design) annotation (Line(
        points={{16.5,17},{16.5,24.5},{23.52,24.5},{23.52,28.4}}, color={0,0,
          127}));
  connect(heatratio_calc.y_Heater, Heatdemand.u) annotation (Line(points={{40.48,
          32},{44,32},{44,16},{54,16}},       color={0,0,127}));
  connect(heatratio_calc.y_Heater, pumpHC.m_flow_in) annotation (Line(points={{40.48,
          32},{92,32},{92,-20},{54,-20}},       color={0,0,127}));
  connect(Bivalence_on.y, hysteresis_control.Bivalence_true) annotation (Line(
        points={{-83.3,89},{-82.65,89},{-82.65,71.4},{-42,71.4}}, color={255,0,
          255}));
  connect(HeatPump_ideal.Q_flow, hysteresis_control.Q_HP_actual) annotation (
      Line(points={{-86,-6.8},{-116,-6.8},{-116,71.3},{-35.9,71.3}},
                                                                 color={0,0,127}));
  connect(Heatdemand.Q_flow, hysteresis_control.Q_demand) annotation (Line(
        points={{77,16},{92,16},{92,71.3},{-29.9,71.3}}, color={0,0,127}));
  connect(division1.y, HeatingCoil.u) annotation (Line(points={{-71.6,36},{
          -70,36},{-70,32},{-62,32}},
                                  color={0,0,127}));
  connect(hysteresis_control.heatingRod_dotQ, division1.u1) annotation (Line(
        points={{-36,57.2},{-62,57.2},{-62,38.4},{-80.8,38.4}}, color={0,0,127}));
  connect(QHeatingrod_nom.y, division1.u2) annotation (Line(points={{-87.5,33},
          {-89.75,33},{-89.75,33.6},{-80.8,33.6}}, color={0,0,127}));
  connect(tamb_TRYAachen1.y, carnot_calc.T_amb) annotation (Line(points={{
          -23.3,-83},{-10.65,-83},{-10.65,-81.2},{3.2,-81.2}}, color={0,0,127}));
  connect(HeatPump_ideal.Q_flow, greaterThreshold.u) annotation (Line(points=
          {{-86,-6.8},{-60,-6.8},{-60,-63},{-33,-63}}, color={0,0,127}));
  connect(greaterThreshold.y, carnot_calc.HP_on) annotation (Line(points={{
          -21.5,-63},{-9.75,-63},{-9.75,-76},{3.4,-76}}, color={255,0,255}));
  connect(dotQ_ref_demand_noDHW.y, heatratio_calc.dotQ_actual) annotation (
      Line(points={{14.6,36},{16,36},{16,35.6},{23.52,35.6}}, color={0,0,127}));
  connect(tamb_TRYAachen1.y, dotQ_HP_DIN_noDHW.u[1]) annotation (Line(points=
          {{-23.3,-83},{-51.65,-83},{-51.65,-75.2},{-86,-75.2}}, color={0,0,
          127}));
  connect(dotQ_HP_DIN_noDHW.y[1], division2.u1) annotation (Line(points={{-86,
          -61.4},{-78.4,-61.4},{-78.4,-52.8}}, color={0,0,127}));
  connect(HeatPump_On1.y, division2.u2) annotation (Line(points={{-67,-61.5},
          {-67,-56.75},{-73.6,-56.75},{-73.6,-52.8}}, color={0,0,127}));
  connect(division2.y, switchHP_Pump.u1) annotation (Line(points={{-76,-43.6},
          {-120,-43.6},{-120,59.2},{40.8,59.2}}, color={0,0,127}));
  connect(HeatPump_ideal.port_b, temperature.port) annotation (Line(points={{
          -80,-8},{-80,-8},{-80,4},{-88,4}}, color={0,127,255}));
  connect(temperature.T, carnot_calc.T_supply) annotation (Line(points={{
          -83.8,11},{-64,11},{-64,-70},{3.6,-70}}, color={0,0,127}));
  connect(HeatPump_off.y, switchHP_Pump1.u3) annotation (Line(points={{6.5,67},
          {6.5,42.5},{-28.8,42.5},{-28.8,17.2}}, color={0,0,127}));
  connect(hysteresis_control.WP_an, switchHP_Pump1.u2) annotation (Line(
        points={{-25,63.8},{-25,40.9},{-24,40.9},{-24,17.2}}, color={255,0,
          255}));
  connect(PumpHp_on.y, switchHP_Pump1.u1) annotation (Line(points={{-15,29.5},
          {-15,21.75},{-19.2,21.75},{-19.2,17.2}}, color={0,0,127}));
  connect(switchHP_Pump1.y, pumpHP.m_flow_in) annotation (Line(points={{-24,3.4},
          {-24,-20}},                color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-46,94},{-20,86}},
          lineColor={28,108,200},
          textString="HeatPump_Control"),
        Text(
          extent={{2,-54},{24,-62}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString="Carnot-
Berechnung
")}),
    Documentation(info="<html>
<p>Assumptions:</p>
<p>- Heat pump turns on if upper storage temperature falls below a certain threshold and turns off if an upper threshold is exceeded</p>
<p>- Heat pump efficiency is calculated with the Carnot COP</p>
<p>- the heating rod is modulating and supplies the heat flow difference between demand and heat pump </p>
</html>"));
end HeatPumpandStorage_prototype_oldpumps;
