within Configurations.Case;
model HeatPump_DHW_DIN_newcontrol

  parameter Real m_flow_pump_HP = Q_HL/(4180*T_diff_gen) "kg/s";
  parameter Real m_flow_pump_HC = Q_HL/(4180*T_diff_gen) "kg/s";

  //Characteristic temperatures for the system
  parameter Real T_diff_gen = 10 "K";
  parameter Real T_NA = 261.15 "K";
  parameter Real T_BIV = 271.15 "K";
  parameter Real T_THRESH = 288.15 "K";

  //Pressure losses within system
  parameter Real dp_HP = 25000 "Pa";
  parameter Real dp_HR = 10000 "Pa";
  parameter Real dp_DHW = 50000 "Pa";
  parameter Real dp_max_pump_HP = dp_HP+dp_HR "Pa";

  //Design parameters for system
  parameter Real Q_HL = 9710.1 "W";
  //Heating load of building without DHW according to DIN 12831
  parameter Real Q_flow_HP_Biv = 8248.21 "W" annotation(Evaluate=false);
  //design heat load of on/off heat pump at bivalence temperature
  parameter Real Q_flow_HR_design = 6641.61 "W" annotation(Evaluate=false);
  //design heat load of heating rod

  //DHW storage sizing parameters
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

  //Set temperatures for DHW storage

  parameter Real T_CW = 283.15 "K";

  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    useHeatingCoil2=false,
    useHeatingRod=false,
    useHeatingCoil1=true,
    alphaHC1=500,
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
    annotation (Placement(transformation(extent={{12,-18},{32,8}})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpHP(
    m_flow_small=0,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 per,
    final m_flow_nominal=control_Pump.m_flow_HP,
    final inputType=AixLib.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final nominalValuesDefineDefaultPressureCurve=true,
    final dp_nominal=control_Pump.dp_max_pump_heatgeneration,
    redeclare package Medium = Medium,
    T_start=318.15)
    annotation (Placement(transformation(extent={{-36,-66},{-56,-46}})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpDHW(
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.TopS25slash10 per,
    final m_flow_nominal=control_Pump.m_flow_HC,
    final inputType=AixLib.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final nominalValuesDefineDefaultPressureCurve=true,
    final dp_nominal=dHW.dp_DHW,
    redeclare package Medium = Medium,
    T_start=318.15)
    annotation (Placement(transformation(extent={{60,-44},{44,-28}})));
  AixLib.Fluid.Sources.FixedBoundary bou2(
    nPorts=1,
    redeclare package Medium = Medium,
    p=300000)
    annotation (Placement(transformation(extent={{76,26},{64,38}})));

  AixLib.Fluid.Sources.FixedBoundary bou1(
    nPorts=1,
    redeclare package Medium = Medium,
    p=200000)
    annotation (Placement(transformation(extent={{26,-64},{12,-50}})));

  AixLib.Fluid.Sources.MassFlowSource_T m_flow_freshW(
    m_flow=0.09167,
    use_m_flow_in=true,
    nPorts=1,
    final T=T_CW,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={67,-3})));

  Buildings.DHW dHW(final dp_DHW=dp_DHW, final m_flow_DHW=control_Pump.m_flow_HC,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{42,52},{62,72}})));
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
        origin={-92,0})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_HP_DHW
    annotation (Placement(transformation(extent={{94,-30},{114,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_HeatingRod_DHW
    annotation (Placement(transformation(extent={{94,10},{114,30}})));
  General.Carnot_calc carnot_calc
    annotation (Placement(transformation(extent={{-42,-94},{-16,-80}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-78,-64},{-68,-54}})));
  Modelica.Blocks.Interfaces.RealOutput COP_carnot_DHW
    annotation (Placement(transformation(extent={{96,-90},{116,-70}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_pump_HP_DHW annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-106})));
  Modelica.Blocks.Interfaces.RealOutput T_Top_DHW
    annotation (Placement(transformation(extent={{96,44},{116,64}})));
  Modelica.Blocks.Interfaces.BooleanInput HeatPump_DHW_on
    annotation (Placement(transformation(extent={{-120,-58},{-86,-24}})));
  Modelica.Blocks.Interfaces.BooleanInput HR_onoff
    annotation (Placement(transformation(extent={{-120,46},{-86,80}})));
  HeatPumpandStorages.HeatingRod_OnOff heatingRod_OnOff(
    final m_flow_nominal=pumpHP.m_flow_nominal,
    final Q_design=Q_flow_HR_design,
    final dp_max_HR=dp_HR,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,34},{-22,52}})));
  Controls.Control_Pump2 control_Pump(
    final dp_max_pump_heatgeneration=dp_max_pump_HP,
    final dp_max_demand=dHW.dp_DHW,
    final HeatingLoad=Q_HL,
    final Q_flow_NA_HP=heatPump_Carnot_DIN.Q_flow_NA_HP,
    final m_flow_HC=m_flow_pump_HC,
    final m_flow_HP=m_flow_pump_HP,
    final T_Biv=T_BIV,
    final T_NA=T_NA,
    final T_thresh=T_THRESH,
    final T_diff=T_diff_gen,
    final Q_Biv=Q_flow_HP_Biv,
    final Q_HR_nominal=Q_flow_HR_design,
    final gradient_HP=heatPump_Carnot_DIN.gradient_HP)
    annotation (Placement(transformation(extent={{-4,60},{16,80}})));
  Modelica.Blocks.Interfaces.RealInput T_amb
    annotation (Placement(transformation(extent={{-122,-108},{-86,-72}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=291.15)
    annotation (Placement(transformation(extent={{48,-12},{40,-4}})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem_supply_HP(
    final m_flow_nominal=m_flow_pump_HP,
    final transferHeat=true,
    redeclare package Medium = Medium,
    final TAmb=293.15)
    annotation (Placement(transformation(extent={{-66,20},{-50,36}})));

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
  connect(pumpDHW.port_b,bufferStorage. fluidportBottom2) annotation (Line(
        points={{44,-36},{22,-36},{22,-18.13},{24.875,-18.13}},
                                                            color={0,127,255}));
  connect(bufferStorage.portHC1Out,pumpHP. port_a) annotation (Line(points={{11.875,
          -1.62},{11.875,-40},{-32,-40},{-32,-48},{-36,-48},{-36,-56}},
                                                        color={0,127,255}));
  connect(bou1.ports[1],pumpHP. port_a) annotation (Line(points={{12,-57},{-18,-57},
          {-18,-56},{-36,-56}},      color={0,127,255}));
  connect(m_flow_freshW.ports[1],pumpDHW. port_a) annotation (Line(points={{67,-10},
          {62,-10},{62,-36},{60,-36}},      color={0,127,255}));
  connect(bufferStorage.fluidportTop2, dHW.dhw_in) annotation (Line(points={{25.125,
          8.13},{31.5,8.13},{31.5,52},{41.6,52}}, color={0,127,255}));
  connect(dHW.dhw_out, bou2.ports[1]) annotation (Line(points={{62.4,52},{64,52},
          {64,32}},         color={0,127,255}));
  connect(pumpHP.port_b, heatPump_Carnot_DIN.port_a1) annotation (Line(points={{-56,-56},
          {-56,-10},{-82,-10}},                 color={0,127,255}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, Q_flow_HP_DHW) annotation (Line(
        points={{-102,10.2},{2,10.2},{2,-20},{104,-20}},color={0,0,127}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, greaterThreshold.u) annotation (
      Line(points={{-102,10.2},{-80,10.2},{-80,-59},{-79,-59}},color={0,0,127}));
  connect(greaterThreshold.y, carnot_calc.HP_on) annotation (Line(points={{
          -67.5,-59},{-67.5,-73.5},{-42.78,-73.5},{-42.78,-87}}, color={255,0,
          255}));
  connect(carnot_calc.COP_Carnot, COP_carnot_DHW) annotation (Line(points={{
          -14.7,-87},{41.65,-87},{41.65,-80},{106,-80}}, color={0,0,127}));
  connect(pumpHP.P, P_el_pump_HP_DHW) annotation (Line(points={{-57,-47},{-0.5,-47},
          {-0.5,-106},{0,-106}},       color={0,0,127}));
  connect(bufferStorage.TTop, T_Top_DHW) annotation (Line(points={{12,6.44},{54,
          6.44},{54,54},{106,54}}, color={0,0,127}));
  connect(heatingRod_OnOff.port_b1, bufferStorage.portHC1In) annotation (Line(
        points={{-27.4,32.02},{-27.4,22.01},{11.75,22.01},{11.75,2.41}},
                                                                       color={0,
          127,255}));
  connect(HR_onoff, heatingRod_OnOff.u1) annotation (Line(points={{-103,63},{
          -66.5,63},{-66.5,49.3},{-40,49.3}}, color={255,0,255}));
  connect(heatingRod_OnOff.Q_flow_HeatingRod, Q_flow_HeatingRod_DHW)
    annotation (Line(points={{-22.18,50.2},{41.91,50.2},{41.91,20},{104,20}},
        color={0,0,127}));
  connect(heatingRod_OnOff.Q_flow_HeatingRod, control_Pump.HeatingRod_actual)
    annotation (Line(points={{-22.18,50.2},{-22.18,90.1},{6,90.1},{6,82}},
        color={0,0,127}));
  connect(heatPump_Carnot_DIN.Q_flow_HP_out, control_Pump.Q_HP_actual)
    annotation (Line(points={{-102,10.2},{-40,10.2},{-40,82},{-2.8,82}},
                                                                      color={0,
          0,127}));
  connect(dHW.dhw_OnOff, control_Pump.Q_demand) annotation (Line(points={{63,
          71.4},{39.5,71.4},{39.5,82},{15,82}}, color={0,0,127}));
  connect(control_Pump.dp_pump_HP, pumpHP.dp_in) annotation (Line(points={{-3,
          60},{-24,60},{-24,-44},{-46,-44}}, color={0,0,127}));
  connect(control_Pump.dp_pump_demand, pumpDHW.dp_in) annotation (Line(points={
          {6,60},{30,60},{30,-26.4},{52,-26.4}}, color={0,0,127}));
  connect(control_Pump.m_flow_pump_demand, m_flow_freshW.m_flow_in) annotation (
     Line(points={{15,60},{38,60},{38,5.4},{61.4,5.4}},
                                                    color={0,0,127}));
  connect(T_amb, carnot_calc.T_amb) annotation (Line(points={{-104,-90},{-78,
          -90},{-78,-90.64},{-43.04,-90.64}}, color={0,0,127}));
  connect(HeatPump_DHW_on, heatPump_Carnot_DIN.HP_onoff) annotation (Line(
        points={{-103,-41},{-89.5,-41},{-89.5,-10.4},{-100,-10.4}},color={255,0,
          255}));
  connect(T_amb, heatPump_Carnot_DIN.T_amb) annotation (Line(points={{-104,-90},
          {-104,-10.8},{-92,-10.8}},
                                  color={0,0,127}));
  connect(fixedTemperature.port, bufferStorage.heatportOutside) annotation (
      Line(points={{40,-8},{36,-8},{36,-4.22},{31.75,-4.22}}, color={191,0,0}));
  connect(heatPump_Carnot_DIN.port_b1, senTem_supply_HP.port_a) annotation (
      Line(points={{-82,9.8},{-84,9.8},{-84,28},{-66,28}},  color={0,127,255}));
  connect(senTem_supply_HP.port_b, heatingRod_OnOff.port_a1) annotation (Line(
        points={{-50,28},{-42,28},{-42,32.02},{-34.78,32.02}}, color={0,127,255}));
  connect(senTem_supply_HP.T, carnot_calc.T_supply) annotation (Line(points={{-58,
          36.8},{-52,36.8},{-52,-82.8},{-42.52,-82.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{70,16},{132,-8}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="Q_flow_HeatingRod_DHW"),
        Text(
          extent={{68,-36},{132,-44}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="Q_flow_HP
_DHW"), Rectangle(
          extent={{-28,-42},{32,-76}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{-12,-84},{-12,-62},{2,-72},{16,-62},{16,-84}}, color={0,0,
              0}),
        Rectangle(
          extent={{-68,30},{-26,8}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,8},{-26,-14}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-28,-66},{-84,-66},{-84,10},{-68,10}}, color={0,0,0}),
        Line(points={{-26,10},{40,10},{40,-68},{32,-68}}, color={0,0,0}),
        Polygon(
          points={{2,86},{-10,50},{-10,44},{-6,40},{-2,38},{6,38},{14,38},{18,
              40},{20,42},{20,48},{18,52},{16,58},{2,86}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-24,90},{34,30}}, lineColor={0,0,0}),
        Line(points={{-68,22},{-84,22},{-84,74},{-24,74}}, color={0,0,0}),
        Line(points={{34,74},{58,74},{58,20},{-26,20}}, color={0,0,0}),
        Text(
          extent={{76,-92},{140,-100}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="COP_DHW"),
        Text(
          extent={{-32,-86},{32,-94}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="P_el_pump_HP"),
        Text(
          extent={{26,-86},{90,-94}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="P_el_pump_DHW"),
        Text(
          extent={{80,44},{118,32}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="T_Top_dhw")}),                             Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPump_DHW_DIN_newcontrol;
