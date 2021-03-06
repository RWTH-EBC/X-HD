within Configurations.SimpleTests;
model Test_HeatPump_Carnot_DHWStorage
  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    useHeatingCoil2=false,
    useHeatingRod=false,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC1 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    useHeatingCoil1=true,
    data=AixLib.DataBase.Storage.Generic_New_2000l(hHC1Up=2.1),
    alphaHC1=300,
    TStart=318.15)
    annotation (Placement(transformation(extent={{-8,-28},{24,12}})));

  AixLib.Fluid.Movers.FlowControlled_dp pumpHP(
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    addPowerToMedium=false,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 per,
    m_flow_nominal=0.26,
    nominalValuesDefineDefaultPressureCurve=true,
    T_start=318.15,
    dp_nominal=102055.773)
    annotation (Placement(transformation(extent={{-36,-64},{-56,-44}})));

  AixLib.Fluid.Movers.FlowControlled_dp pumpDHW(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 per,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=5.5/60,
    dp_nominal=500000,
    T_start=318.15)
    annotation (Placement(transformation(extent={{60,-46},{40,-26}})));

  AixLib.Fluid.Sources.FixedBoundary bou2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=1,
    p=700000)
    annotation (Placement(transformation(extent={{102,42},{82,62}})));

  AixLib.Fluid.Sources.FixedBoundary bou1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    p=200000)
    annotation (Placement(transformation(extent={{0,-74},{-20,-54}})));

  AixLib.Fluid.Sensors.RelativePressure senRelPre_DHWCoil(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-30,-32},{-14,-16}})));
  AixLib.Fluid.Sensors.RelativePressure senRelPre_HP(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-92,-34},{-76,-18}})));
  AixLib.Fluid.Sources.MassFlowSource_T m_flow_freshW(
    m_flow=0.09167,
    use_m_flow_in=true,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    T=283.15)
    annotation (Placement(transformation(extent={{100,-60},{80,-40}})));

  AixLib.Fluid.HeatExchangers.HeaterCooler_u HeatingRod(
    Q_flow_nominal=6000,
    m_flow_nominal=pumpHP.m_flow_nominal,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    dp_nominal=0)
    annotation (Placement(transformation(extent={{-72,0},{-52,20}})));

  HeatPumpandStorages.HeatPump_Carnot heatPump_Carnot(m_flow_HP=pumpHP.m_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-94,-6})));
  Controls.Control_Pump control_Pump(dp_max_demand=500000, dp_max_HP=102055.773)
    annotation (Placement(transformation(extent={{2,72},{22,92}})));
  Buildings.DHW dHW
    annotation (Placement(transformation(extent={{30,26},{50,46}})));
equation
  connect(pumpDHW.port_b, bufferStorage.fluidportBottom2) annotation (Line(
        points={{40,-36},{12,-36},{12,-28.2},{12.6,-28.2}}, color={0,127,255}));
  connect(bufferStorage.TTop, control.T_Top1) annotation (Line(points={{-8,9.6},
          {-44,9.6},{-44,45.2},{-18,45.2}}, color={0,0,127}));
  connect(bufferStorage.portHC1Out, pumpHP.port_a) annotation (Line(points={{
          -8.2,-2.8},{-8.2,-2.4},{-36,-2.4},{-36,-54}}, color={0,127,255}));
  connect(bou1.ports[1], pumpHP.port_a) annotation (Line(points={{-20,-64},{-28,
          -64},{-28,-54},{-36,-54}}, color={0,127,255}));
  connect(senRelPre_DHWCoil.port_a, bufferStorage.portHC1In) annotation (Line(
        points={{-30,-24},{-20,-24},{-20,3.4},{-8.4,3.4}}, color={0,127,255}));
  connect(senRelPre_DHWCoil.port_b, bufferStorage.portHC1Out) annotation (Line(
        points={{-14,-24},{-12,-24},{-12,-2.8},{-8.2,-2.8}}, color={0,127,255}));
  connect(m_flow_freshW.ports[1], pumpDHW.port_a) annotation (Line(points={{80,
          -50},{78,-50},{78,-36},{60,-36}}, color={0,127,255}));
  connect(HeatingRod.port_b, bufferStorage.portHC1In) annotation (Line(points={
          {-52,10},{-34,10},{-34,3.4},{-8.4,3.4}}, color={0,127,255}));
  connect(control.Q_HeatingRod_OnOff, HeatingRod.u) annotation (Line(points={{
          2.6,60},{-78,60},{-78,16},{-74,16}}, color={0,0,127}));
  connect(heatPump_Carnot.port_a1, senRelPre_HP.port_a) annotation (Line(points=
         {{-84,-16},{-98,-16},{-98,-26},{-92,-26}}, color={0,127,255}));
  connect(heatPump_Carnot.port_b1, senRelPre_HP.port_b) annotation (Line(points=
         {{-84,3.8},{-82,3.8},{-82,-26},{-76,-26}}, color={0,127,255}));
  connect(pumpHP.port_b, heatPump_Carnot.port_a1) annotation (Line(points={{-56,
          -54},{-82,-54},{-82,-16},{-84,-16}}, color={0,127,255}));
  connect(heatPump_Carnot.port_b1, HeatingRod.port_a) annotation (Line(points={
          {-84,3.8},{-80,3.8},{-80,10},{-72,10}}, color={0,127,255}));
  connect(heatPump_Carnot.Q_flow_HP_out, control.Q_HP_actual1) annotation (Line(
        points={{-104,4.2},{-64,4.2},{-64,54},{-18,54}}, color={0,0,127}));
  connect(heatPump_Carnot.Q_flow_HP_out, control_Pump.Q_HP_actual) annotation (
      Line(points={{-104,4.2},{-36,4.2},{-36,88.2},{1.4,88.2}}, color={0,0,127}));
  connect(control_Pump.dp_pump_HP, pumpHP.dp_in) annotation (Line(points={{22.4,
          88.2},{22.4,19.1},{-46,19.1},{-46,-42}}, color={0,0,127}));
  connect(control_Pump.dp_pump_demand, pumpDHW.dp_in) annotation (Line(points={
          {22.6,76.2},{22.6,15.1},{50,15.1},{50,-24}}, color={0,0,127}));
  connect(control_Pump.m_flow_pump_demand, m_flow_freshW.m_flow_in) annotation (
     Line(points={{22.6,82},{136,82},{136,-42},{100,-42}}, color={0,0,127}));
  connect(control.switch_HeatPump_OnOff, heatPump_Carnot.HP_OnOff) annotation (
      Line(points={{2.8,48},{-46,48},{-46,-16.8},{-94,-16.8}}, color={0,0,127}));
  connect(bufferStorage.fluidportTop2, dHW.dhw_in) annotation (Line(points={{13,
          12.2},{21.5,12.2},{21.5,26},{29.6,26}}, color={0,127,255}));
  connect(dHW.dhw_out, bou2.ports[1]) annotation (Line(points={{50.4,26},{66,26},
          {66,52},{82,52}}, color={0,127,255}));
  connect(dHW.Q_dhw, control.Q_demand1) annotation (Line(points={{51,36},{16,36},
          {16,63},{-18,63}}, color={0,0,127}));
  connect(dHW.dhw_OnOff, control_Pump.Q_demand) annotation (Line(points={{51,
          45.4},{42.5,45.4},{42.5,76.2},{1.4,76.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Test_HeatPump_Carnot_DHWStorage;
