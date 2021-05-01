within Configurations.Case;
model HeatPump_Buffer_DIN_newcontrol_parallel

  parameter Real m_flow_pump_HP = Q_HL/(4180*T_diff_gen) "kg/s" annotation(Evaluate=false);
  parameter Real m_flow_pump_HC = Q_HL/(4180*T_diff_gen) "kg/s" annotation(Evaluate=false);

  //Characteristic temperatures for the system
  parameter Real T_diff_gen = 10 "K" annotation(Evaluate=false);
  parameter Real T_NA = 261.15 "K";
  parameter Real T_BIV = 271.15 "K";
  parameter Real T_THRESH = 288.15 "K";

  //Pressure losses within system
  parameter Real dp_HP = 25000 "Pa";
  parameter Real dp_HR = 10000 "Pa";
  parameter Real dp_building = 100000 "Pa";
  parameter Real dp_max_pump_HP = dp_HP+dp_HR "Pa";

  //Design parameters for system
  parameter Real Q_HL = 9710.1 "W" annotation(Evaluate=false);
  //Heating load of building without DHW according to DIN 12831
  parameter Real Q_flow_HP_Biv = 8248.21 "W" annotation(Evaluate=false);
  //design heat load of on/off heat pump at bivalence temperature
  parameter Real Q_flow_HR_design = 6641.61 "W" annotation(Evaluate=false);
  //design heat load of heating rod

  //Buffer storage sizing parameters
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
    redeclare final model HeatTransfer =
        AixLib.Fluid.Storage.BaseClasses.HeatTransferLambdaEff,
    redeclare package Medium = Medium,
    redeclare package MediumHC1 = MediumHC1,
    redeclare package MediumHC2 = MediumHC2,
    TStart=318.15)
    annotation (Placement(transformation(extent={{-6,-30},{18,0}})));

  AixLib.Fluid.Sources.Boundary_pT bou(
    nPorts=1,
    redeclare package Medium = Medium,
    p=200000)
    annotation (Placement(transformation(extent={{90,-54},{78,-42}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=291.15)
    annotation (Placement(transformation(extent={{36,-20},{26,-10}})));
  General.Carnot_calc carnot_calc
    annotation (Placement(transformation(extent={{4,-86},{24,-66}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-32,-68},{-22,-58}})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpHP(
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_small=0,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 per,
    final m_flow_nominal=control_Pump.m_flow_HP,
    final dp_nominal=control_Pump.dp_max_pump_heatgeneration,
    final inputType=AixLib.Fluid.Types.InputType.Continuous,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-26,-46},{-46,-26}})));

  AixLib.Fluid.Movers.FlowControlled_dp pumpHC(
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_small=0,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 per,
    final m_flow_nominal=control_Pump.m_flow_HC,
    final dp_nominal=control_Pump.dp_max_demand,
    final inputType=AixLib.Fluid.Types.InputType.Continuous,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{62,-58},{42,-38}})));

  Buildings.Building building(
    final Q_flow_building_max=-Q_HL,
    final dp_max_building=dp_building,
    final m_flow_building=control_Pump.m_flow_HC,
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
    annotation (Placement(transformation(extent={{96,74},{116,94}}),
        iconTransformation(extent={{96,74},{116,94}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_HeatingRod
    annotation (Placement(transformation(extent={{96,-40},{116,-20}}),
        iconTransformation(extent={{96,-40},{116,-20}})));
  Modelica.Blocks.Interfaces.RealOutput COP_Buffer
    annotation (Placement(transformation(extent={{98,-86},{118,-66}})));
  Modelica.Blocks.Interfaces.RealOutput P_pump_HP_Buffer annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={34,-106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-14,-106})));
  Modelica.Blocks.Interfaces.RealOutput P_pump_Buffer_demand annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={76,-106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={62,-106})));
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
    annotation (Placement(transformation(extent={{-122,-108},{-86,-72}})));
  Modelica.Blocks.Interfaces.RealOutput T_Bottom_Buffer
    annotation (Placement(transformation(extent={{96,2},{116,22}}),
        iconTransformation(extent={{96,2},{116,22}})));
  Modelica.Blocks.Sources.Constant Threshold_temperature(k=T_THRESH)
    annotation (Placement(transformation(extent={{-26,74},{-14,86}})));
  Controls.Control_Pump2 control_Pump(
    dp_max_demand=dp_building,
    HeatingLoad=Q_HL,
    Q_flow_NA_HP=heatPump_Carnot_DIN.Q_flow_NA_HP,
    T_Biv=T_BIV,
    T_NA=T_NA,
    T_thresh=T_THRESH,
    Q_Biv=Q_flow_HP_Biv,
    Q_HR_nominal=Q_flow_HR_design,
    m_flow_HP=m_flow_pump_HP,
    m_flow_HC=m_flow_pump_HC,
    gradient_HP=heatPump_Carnot_DIN.gradient_HP,
    T_diff=T_diff_gen,
    dp_max_pump_heatgeneration=dp_max_pump_HP)
    annotation (Placement(transformation(extent={{-32,16},{-12,36}})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem_supply_HP(
    transferHeat=true,
    final m_flow_nominal=m_flow_pump_HP,
    redeclare package Medium = Medium,
    final TAmb=293.15)
    annotation (Placement(transformation(extent={{-82,30},{-68,42}})));

  parameter Real dp_max_pump_heatgeneration=dp_max_pump_HP "Pa";
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
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
      Line(points={{26,-15},{22,-15},{22,-14.1},{17.7,-14.1}}, color={191,0,0}));
  connect(greaterThreshold.y, carnot_calc.HP_on) annotation (Line(points={{
          -21.5,-63},{-9.75,-63},{-9.75,-76},{3.4,-76}}, color={255,0,255}));
  connect(pumpHC.port_b, bufferStorage.fluidportBottom2) annotation (Line(
        points={{42,-48},{26,-48},{26,-30.15},{9.45,-30.15}}, color={0,127,255}));
  connect(bou.ports[1], pumpHC.port_a) annotation (Line(points={{78,-48},{78,
          -48},{62,-48}},          color={0,127,255}));
  connect(bufferStorage.fluidportTop2, building.building_in) annotation (Line(
        points={{9.75,0.15},{16.875,0.15},{16.875,6},{22,6}}, color={0,127,255}));
  connect(building.building_out, pumpHC.port_a) annotation (Line(points={{42,6},{
          70,6},{70,-48},{62,-48}},  color={0,127,255}));
  connect(pumpHP.port_b, heatPump_Carnot_DIN.port_a1) annotation (Line(points={
          {-46,-36},{-50,-36},{-50,-16},{-54,-16}}, color={0,127,255}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, greaterThreshold.u) annotation (
      Line(points={{-74,4.2},{-54,4.2},{-54,-63},{-33,-63}}, color={0,0,127}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, Q_flow_HP) annotation (Line(points={{-74,4.2},
          {12,4.2},{12,84},{106,84}},           color={0,0,127}));
  connect(carnot_calc.COP_Carnot, COP_Buffer)
    annotation (Line(points={{25,-76},{66,-76},{108,-76}}, color={0,0,127}));
  connect(pumpHP.P, P_pump_HP_Buffer) annotation (Line(points={{-47,-27},{34.5,
          -27},{34.5,-106},{34,-106}}, color={0,0,127}));
  connect(pumpHC.P, P_pump_Buffer_demand) annotation (Line(points={{41,-39},{41,
          -67.5},{76,-67.5},{76,-106}}, color={0,0,127}));
  connect(bufferStorage.TTop, T_Top_Buffer) annotation (Line(points={{-6,-1.8},
          {46,-1.8},{46,52},{106,52}}, color={0,0,127}));
  connect(HR_onoff, heatingRod_OnOff.u1) annotation (Line(points={{-103,63},{
          -44,63},{-44,63.3}}, color={255,0,255}));
  connect(heatingRod_OnOff.port_b1, bufferStorage.fluidportTop1) annotation (
      Line(points={{-31.4,46.02},{-31.4,45.01},{1.8,45.01},{1.8,0.15}}, color={
          0,127,255}));
  connect(heatingRod_OnOff.Q_flow_HeatingRod, Q_flow_HeatingRod) annotation (
      Line(points={{-26.18,64.2},{36.91,64.2},{36.91,-30},{106,-30}}, color={0,
          0,127}));
  connect(T_amb, carnot_calc.T_amb) annotation (Line(points={{-104,-90},{-58,-90},
          {-58,-81.2},{3.2,-81.2}},      color={0,0,127}));
  connect(bufferStorage.TBottom, T_Bottom_Buffer) annotation (Line(points={{-6,-27},
          {46,-27},{46,12},{106,12}},      color={0,0,127}));
  connect(HeatPump_Buffer_on, heatPump_Carnot_DIN.HP_onoff) annotation (Line(
        points={{-104,-42},{-72,-42},{-72,-16.4}}, color={255,0,255}));
  connect(T_amb, heatPump_Carnot_DIN.T_amb) annotation (Line(points={{-104,-90},
          {-64,-90},{-64,-16.8}}, color={0,0,127}));
  connect(T_amb, building.T_amb) annotation (Line(points={{-104,-90},{-78,-90},{
          -78,15.2},{21.8,15.2}}, color={0,0,127}));
  connect(Threshold_temperature.y, building.T_Thresh) annotation (Line(points={
          {-13.4,80},{4,80},{4,9.4},{21.8,9.4}}, color={0,0,127}));
  connect(bufferStorage.fluidportBottom1, pumpHP.port_a) annotation (Line(
        points={{1.95,-30.3},{-12.025,-30.3},{-12.025,-36},{-26,-36}}, color={0,
          127,255}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, control_Pump.Q_HP_actual)
    annotation (Line(points={{-74,4.2},{-54,4.2},{-54,38},{-30.8,38}}, color={0,
          0,127}));
  connect(heatingRod_OnOff.Q_flow_HeatingRod, control_Pump.HeatingRod_actual)
    annotation (Line(points={{-26.18,64.2},{-26.18,51.1},{-22,51.1},{-22,38}},
        color={0,0,127}));
  connect(building.HeatDemand_OnOff, control_Pump.Q_demand) annotation (Line(
        points={{42.8,26},{14,26},{14,38},{-13,38}}, color={0,0,127}));
  connect(control_Pump.dp_pump_HP, pumpHP.dp_in) annotation (Line(points={{-31,16},
          {-34,16},{-34,-24},{-36,-24}}, color={0,0,127}));
  connect(control_Pump.dp_pump_demand, pumpHC.dp_in) annotation (Line(points={{-22,
          16},{64,16},{64,-36},{52,-36}}, color={0,0,127}));
  connect(heatPump_Carnot_DIN.port_b1, senTem_supply_HP.port_a) annotation (
      Line(points={{-54,3.8},{-88,3.8},{-88,36},{-82,36}}, color={0,127,255}));
  connect(senTem_supply_HP.port_b, heatingRod_OnOff.port_a1) annotation (Line(
        points={{-68,36},{-54,36},{-54,46.02},{-38.78,46.02}}, color={0,127,255}));
  connect(senTem_supply_HP.T, carnot_calc.T_supply) annotation (Line(points={{
          -75,42.6},{-75,-13.7},{3.6,-13.7},{3.6,-70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-84,92},{-48,78}},
          lineColor={28,108,200},
          textString="DHW_OnOff"),
        Text(
          extent={{82,106},{118,92}},
          lineColor={0,0,0},
          fontSize=16,
          textString="Q_flow_HP"),
        Text(
          extent={{84,-8},{144,-22}},
          lineColor={0,0,0},
          fontSize=16,
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
        Line(points={{-28,-2},{16,-2},{16,-42}}, color={0,0,0}),
        Line(points={{-28,4},{60,4},{60,52},{42,52}}, color={0,0,0}),
        Text(
          extent={{90,-56},{116,-64}},
          lineColor={0,0,0},
          fontSize=16,
          textString="COP"),
        Text(
          extent={{26,-78},{102,-104}},
          lineColor={0,0,0},
          fontSize=16,
          textString="P_pump_demand_Buffer"),
        Text(
          extent={{-48,-78},{20,-102}},
          lineColor={0,0,0},
          fontSize=16,
          textString="P_pump_HP_Buffer"),
        Text(
          extent={{82,74},{128,60}},
          lineColor={0,0,0},
          fontSize=16,
          textString="T_Top_Buffer"),
        Text(
          extent={{84,36},{138,22}},
          lineColor={0,0,0},
          fontSize=16,
          textString="T_Bottom_Buffer")}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{2,-58},{24,-66}},
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
end HeatPump_Buffer_DIN_newcontrol_parallel;
