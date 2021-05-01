within Configurations.Case;
model HeatPump_Buffer_DIN_newcontrol_series


  parameter Real m_flow_pump_HP = Q_HL/(4180*T_diff_gen) "kg/s" annotation(Evaluate=false);

  //Characteristic temperatures for the system
  parameter Real T_diff_gen = 10 "K" annotation(Evaluate=false);
  parameter Real T_NA = 261.15 "K";
  parameter Real T_BIV = 271.15 "K";
  parameter Real T_THRESH = 288.15 "K";

  //Pressure losses within system
  parameter Real dp_HP = 25000 "Pa";
  parameter Real dp_HR = 10000 "Pa";
  parameter Real dp_building = 100000 "Pa";
  parameter Real dp_max_total_Cycle = dp_HP + dp_HR+dp_building "Pa";

  //Design parameters for system
  parameter Real Q_HL = 9710.1 "W" annotation(Evaluate=false);
  //Heating load of building without DHW according to DIN 12831
  parameter Real Q_flow_HP_Biv = 8248.21 "W" annotation(Evaluate=false);
  //design heat load of on/off heat pump at bivalence temperature
  parameter Real Q_flow_HR_design = 6641.61 "W" annotation(Evaluate=false);
  //design heat load of heating rod

  //Storage sizing parameters
  parameter Real h_Storage = 0.985 "m";
  parameter Real h_lowerPorts = 0.1 "m";
  parameter Real h_upperPorts = 0.94 "m";
  parameter Real h_upperHeatingCoil = 0.885 "m";
  parameter Real h_lowerHeatingCoil = 0.1 "m";
  parameter Real h_upperHeatingCoil_2 = 0.885 "m";
  parameter Real h_lowerHeatingCoil_2= 0.1 "m";
  parameter Real h_heatingRod = 0.4 "m";
  parameter Real d_Buffer = 0.501 "m";
  parameter Real h_lowerSenTemp = 0.1 "m";
  parameter Real h_upperSenTemp = 0.94 "m";


  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    useHeatingCoil2=false,
    useHeatingRod=false,
    alphaHC1=100,
    useHeatingCoil1=false,
    redeclare model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferLambdaEff,
    final data=AixLib.DataBase.Storage.Generic_New_2000l(
        hTank=h_Storage,
        hLowerPorts=h_lowerPorts,
        hUpperPorts=h_upperPorts,
        hHC1Up=h_upperHeatingCoil,
        hHC1Low=h_lowerHeatingCoil,
        hHC2Up=h_upperHeatingCoil_2,
        hHC2Low=h_lowerHeatingCoil_2,
        hHR=h_heatingRod,
        dTank=d_Buffer,
        hTS1=h_lowerSenTemp,
        hTS2=h_upperSenTemp),
    redeclare package Medium = Medium,
    redeclare package MediumHC1 = MediumHC1,
    redeclare package MediumHC2 = MediumHC2,
    TStart=318.15)
    annotation (Placement(transformation(extent={{32,-44},{56,-14}})));

  AixLib.Fluid.Sources.Boundary_pT bou(
    nPorts=1,
    redeclare package Medium = Medium,
    p=200000)
    annotation (Placement(transformation(extent={{0,-62},{-12,-50}})));

  DataBase.Tamb_TRYAachen_2a tamb_TRYAachen
    annotation (Placement(transformation(extent={{-212,32},{-192,52}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=291.15)
    annotation (Placement(transformation(extent={{74,-32},{66,-24}})));
  General.Carnot_calc carnot_calc
    annotation (Placement(transformation(extent={{4,-94},{24,-74}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-32,-72},{-22,-62}})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpHP(
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_small=0,
    show_T=false,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 per,
    final m_flow_nominal=control_Pump_Series.m_flow_Cycle,
    final dp_nominal=control_Pump_Series.dp_max_Cycle,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-18,-54},{-38,-34}})));

  Buildings.Building building(
    final Q_flow_building_max=-Q_HL,
    final dp_max_building=dp_building,
    final m_flow_building=control_Pump_Series.m_flow_Cycle,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{22,6},{42,26}})));
  HeatPumpandStorages.HeatPump_Carnot_DIN heatPump_Carnot_DIN(
    final dp_HP=dp_HP,
    final m_flow_HP=pumpHP.m_flow_nominal,
    final T_NA=T_NA,
    final T_Biv_para=T_BIV,
    final Q_flow_HP_Biv=Q_flow_HP_Biv,
    final Q_NA_Building=Q_HL,
    redeclare package Medium = Medium)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-6})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_HP
    annotation (Placement(transformation(extent={{96,70},{116,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_HeatingRod
    annotation (Placement(transformation(extent={{96,-24},{116,-4}})));
  Modelica.Blocks.Interfaces.RealOutput COP_Buffer
    annotation (Placement(transformation(extent={{98,-94},{118,-74}})));
  Modelica.Blocks.Interfaces.RealOutput P_pump_HP_Buffer annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={34,-106})));
  Modelica.Blocks.Interfaces.RealOutput T_Top_Buffer
    annotation (Placement(transformation(extent={{96,42},{116,62}})));
  Modelica.Blocks.Interfaces.BooleanInput HeatPump_Buffer_on
    annotation (Placement(transformation(extent={{-120,-58},{-88,-26}})));
  Modelica.Blocks.Interfaces.BooleanInput HR_onoff
    annotation (Placement(transformation(extent={{-120,46},{-86,80}})));
  HeatPumpandStorages.HeatingRod_OnOff heatingRod_OnOff(
    final m_flow_nominal=pumpHP.m_flow_nominal,
    final Q_design=Q_flow_HR_design,
    final dp_max_HR=dp_HR,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-44,48},{-26,66}})));
  Modelica.Blocks.Interfaces.RealInput T_amb
    annotation (Placement(transformation(extent={{-122,-106},{-86,-70}})));
  Modelica.Blocks.Interfaces.RealOutput T_Bottom_Buffer
    annotation (Placement(transformation(extent={{96,12},{116,32}})));
  Controls.Control_Pump_Series control_Pump_Series(
    final dp_max_Cycle=dp_max_total_Cycle,
    final m_flow_Cycle=m_flow_pump_HP,
    final HeatingLoad=Q_HL,
    final T_Biv=T_BIV,
    final T_NA=T_NA,
    final T_thresh=T_THRESH,
    final T_diff=T_diff_gen,
    final Q_flow_NA_HP=heatPump_Carnot_DIN.Q_flow_NA_HP,
    final Q_Biv=heatPump_Carnot_DIN.Q_flow_HP_Biv,
    final Q_HR_nominal=Q_flow_HR_design,
    final gradient_HP=heatPump_Carnot_DIN.gradient_HP)
    annotation (Placement(transformation(extent={{-24,14},{-4,34}})));
  Modelica.Blocks.Sources.Constant const(final k=T_THRESH)
    annotation (Placement(transformation(extent={{-22,74},{-8,88}})));
  Modelica.Blocks.Interfaces.RealOutput P_pump_demand annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={72,-106})));
  Modelica.Blocks.Sources.Constant const1(final k=0)
                                               annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={71,-63})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem_supply_HP(
    m_flow_nominal=m_flow_pump_HP,
    transferHeat=true,
    redeclare package Medium = Medium,
    TAmb=293.15)
    annotation (Placement(transformation(extent={{-70,32},{-58,44}})));

  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  replaceable package MediumHC1 =
      Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
  replaceable package MediumHC2 =
      Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
equation
  connect(fixedTemperature.port, bufferStorage.heatportOutside) annotation (
      Line(points={{66,-28},{66,-28.1},{55.7,-28.1}},          color={191,0,0}));
  connect(greaterThreshold.y, carnot_calc.HP_on) annotation (Line(points={{-21.5,
          -67},{-9.75,-67},{-9.75,-84},{3.4,-84}},       color={255,0,255}));
  connect(pumpHP.port_a, bufferStorage.fluidportBottom1) annotation (Line(
        points={{-18,-44},{-12,-44},{-12,-44.3},{39.95,-44.3}},color={0,127,255}));
  connect(pumpHP.port_b, heatPump_Carnot_DIN.port_a1) annotation (Line(points={{-38,-44},
          {-50,-44},{-50,-16},{-54,-16}},           color={0,127,255}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, greaterThreshold.u) annotation (
      Line(points={{-74,4.2},{-54,4.2},{-54,-67},{-33,-67}}, color={0,0,127}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, Q_flow_HP) annotation (Line(points=
         {{-74,4.2},{12,4.2},{12,80},{106,80}}, color={0,0,127}));
  connect(carnot_calc.COP_Carnot, COP_Buffer)
    annotation (Line(points={{25,-84},{108,-84}},          color={0,0,127}));
  connect(pumpHP.P, P_pump_HP_Buffer) annotation (Line(points={{-39,-35},{34.5,-35},
          {34.5,-106},{34,-106}},      color={0,0,127}));
  connect(bufferStorage.TTop, T_Top_Buffer) annotation (Line(points={{32,-15.8},
          {6,-15.8},{6,52},{106,52}},  color={0,0,127}));
  connect(HR_onoff, heatingRod_OnOff.u1) annotation (Line(points={{-103,63},{
          -44,63},{-44,63.3}}, color={255,0,255}));
  connect(heatingRod_OnOff.Q_flow_HeatingRod, Q_flow_HeatingRod) annotation (
      Line(points={{-26.18,64.2},{36.91,64.2},{36.91,-14},{106,-14}}, color={0,
          0,127}));
  connect(T_amb, carnot_calc.T_amb) annotation (Line(points={{-104,-88},{-58,-88},
          {-58,-89.2},{3.2,-89.2}},      color={0,0,127}));
  connect(bufferStorage.TBottom, T_Bottom_Buffer) annotation (Line(points={{32,-41},
          {16,-41},{16,22},{106,22}},      color={0,0,127}));
  connect(HeatPump_Buffer_on, heatPump_Carnot_DIN.HP_onoff) annotation (Line(
        points={{-104,-42},{-72,-42},{-72,-16.4}}, color={255,0,255}));
  connect(T_amb, heatPump_Carnot_DIN.T_amb) annotation (Line(points={{-104,-88},
          {-64,-88},{-64,-16.8}}, color={0,0,127}));
  connect(heatingRod_OnOff.port_b1, building.building_in) annotation (Line(
        points={{-31.4,46.02},{21.3,46.02},{21.3,6},{22,6}}, color={0,127,255}));
  connect(building.building_out, bufferStorage.fluidportTop1) annotation (Line(
        points={{42,6},{70,6},{70,-13.85},{39.8,-13.85}}, color={0,127,255}));
  connect(bou.ports[1], pumpHP.port_a) annotation (Line(points={{-12,-56},{-16,-56},
          {-16,-44},{-18,-44}}, color={0,127,255}));
  connect(control_Pump_Series.dp_pump_HP, pumpHP.dp_in) annotation (Line(points=
         {{-14,13.6},{-20,13.6},{-20,-32},{-28,-32}}, color={0,0,127}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, control_Pump_Series.Q_HP_actual)
    annotation (Line(points={{-74,4.2},{-50,4.2},{-50,36},{-22.8,36}}, color={0,
          0,127}));
  connect(heatingRod_OnOff.Q_flow_HeatingRod, control_Pump_Series.HeatingRod_actual)
    annotation (Line(points={{-26.18,64.2},{-26.18,50.1},{-14,50.1},{-14,36}},
        color={0,0,127}));
  connect(building.HeatDemand_OnOff, control_Pump_Series.Q_demand) annotation (
      Line(points={{42.8,26},{20,26},{20,36},{-5,36}}, color={0,0,127}));
  connect(T_amb, building.T_amb) annotation (Line(points={{-104,-88},{-40,-88},{
          -40,15.2},{21.8,15.2}}, color={0,0,127}));
  connect(const.y, building.T_Thresh) annotation (Line(points={{-7.3,81},{-7.3,8.5},
          {21.8,8.5},{21.8,9.4}}, color={0,0,127}));
  connect(const1.y, P_pump_demand) annotation (Line(points={{71,-70.7},{71,
          -81.5},{72,-81.5},{72,-106}}, color={0,0,127}));
  connect(heatPump_Carnot_DIN.port_b1, senTem_supply_HP.port_a) annotation (
      Line(points={{-54,3.8},{-62,3.8},{-62,38},{-70,38}}, color={0,127,255}));
  connect(senTem_supply_HP.port_b, heatingRod_OnOff.port_a1) annotation (Line(
        points={{-58,38},{-48,38},{-48,46.02},{-38.78,46.02}}, color={0,127,255}));
  connect(senTem_supply_HP.T, carnot_calc.T_supply) annotation (Line(points={{
          -64,44.6},{-30,44.6},{-30,-78},{3.6,-78}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-84,92},{-48,78}},
          lineColor={28,108,200},
          textString="DHW_OnOff"),
        Text(
          extent={{82,102},{118,88}},
          lineColor={0,0,0},
          textString="Q_flow_HP"),
        Text(
          extent={{78,12},{114,-2}},
          lineColor={0,0,0},
          textString="Q_flow_HeatingRod"),
        Rectangle(extent={{-80,26},{-28,-40}}, lineColor={0,0,0}),
        Rectangle(
          extent={{-80,26},{-28,-8}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-6},{-28,-40}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,-42},{36,-78}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(points={{-16,-80},{-16,-54},{0,-68},{16,-54},{16,-80}},   color={0,
              0,0}),
        Rectangle(
          extent={{-12,70},{42,12}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(points={{-34,-64},{-60,-64},{-60,-40}}, color={0,0,0}),
        Line(points={{-54,26},{-54,50},{-12,50}}, color={0,0,0}),
        Polygon(
          points={{-12,70},{14,94},{42,70},{-12,70}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{36,-62},{60,-62},{60,52},{42,52}},
                                                      color={0,0,0}),
        Text(
          extent={{90,-56},{116,-64}},
          lineColor={0,0,0},
          textString="COP"),
        Text(
          extent={{58,-78},{102,-104}},
          lineColor={0,0,0},
          textString="P_pump_demand_Buffer"),
        Text(
          extent={{10,-80},{52,-104}},
          lineColor={0,0,0},
          textString="P_pump_HP_Buffer"),
        Text(
          extent={{82,42},{118,28}},
          lineColor={0,0,0},
          textString="T_Top_Buffer")}),                          Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{2,-66},{24,-74}},
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
end HeatPump_Buffer_DIN_newcontrol_series;
