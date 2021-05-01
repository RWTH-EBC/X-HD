within Configurations.Case.Archive;
model HeatPump_DHW_VDI
  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    useHeatingCoil2=false,
    useHeatingRod=false,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC1 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    useHeatingCoil1=true,
    alphaHC1=300,
    TStart=318.15,
    data=AixLib.DataBase.Storage.Generic_New_2000l(
        hTank=0.575,
        hUpperPorts=0.53,
        hHC1Up=0.475,
        hHC2Up=0.5,
        hHR=0.26,
        dTank=0.292,
        hTS2=0.53))
    annotation (Placement(transformation(extent={{2,-18},{34,22}})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpHP(
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=0.279,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.VeroLine50slash150dash4slash2
      per,
    dp_nominal=135832.0143,
    T_start=318.15)
    annotation (Placement(transformation(extent={{-26,-54},{-46,-34}})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpDHW(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=control_Pump.m_flow_pump_max,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.TopS25slash10 per,
    dp_nominal=dHW.dp_DHW,
    T_start=318.15)
    annotation (Placement(transformation(extent={{52,-66},{32,-46}})));
  AixLib.Fluid.Sources.FixedBoundary bou2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=1,
    p=700000)
    annotation (Placement(transformation(extent={{92,56},{72,76}})));

  AixLib.Fluid.Sources.FixedBoundary bou1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    p=200000)
    annotation (Placement(transformation(extent={{10,-64},{-10,-44}})));
  AixLib.Fluid.Sensors.RelativePressure senRelPre_DHWCoil(redeclare package
      Medium = Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-20,-22},{-4,-6}})));
  AixLib.Fluid.Sensors.RelativePressure senRelPre_HP(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-82,-24},{-66,-8}})));
  AixLib.Fluid.Sources.MassFlowSource_T m_flow_freshW(
    m_flow=0.09167,
    use_m_flow_in=true,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    T=283.15)
    annotation (Placement(transformation(extent={{88,-50},{68,-30}})));
  AixLib.Fluid.HeatExchangers.HeaterCooler_u HeatingRod(
    m_flow_nominal=pumpHP.m_flow_nominal,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    Q_flow_nominal=5520.86,
    dp_nominal=25000)
    annotation (Placement(transformation(extent={{-64,42},{-44,62}})));
  Controls.Control_Pump control_Pump(
    m_flow_pump_max=0.141,
    dp_max_demand=dHW.dp_DHW,
    dp_max_HP=135832.0143)
    annotation (Placement(transformation(extent={{16,76},{36,96}})));
  Buildings.DHW dHW(m_flow_DHW=control_Pump.m_flow_pump_max, dp_DHW=100000)
    annotation (Placement(transformation(extent={{40,36},{60,56}})));
  HeatPumpandStorages.HeatPump_Carnot_VDI heatPump_Carnot_VDI(Q_flow_Biv=
        7127.46, m_flow_HP=pumpHP.m_flow_nominal)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,16})));
equation
  connect(pumpDHW.port_b,bufferStorage. fluidportBottom2) annotation (Line(
        points={{32,-56},{22,-56},{22,-18.2},{22.6,-18.2}}, color={0,127,255}));
  connect(bufferStorage.TTop,control. T_Top1) annotation (Line(points={{2,19.6},
          {-34,19.6},{-34,55.2},{-8,55.2}}, color={0,0,127}));
  connect(bufferStorage.portHC1Out,pumpHP. port_a) annotation (Line(points={{1.8,7.2},
          {1.8,7.6},{-26,7.6},{-26,-44}},               color={0,127,255}));
  connect(bou1.ports[1],pumpHP. port_a) annotation (Line(points={{-10,-54},{-18,
          -54},{-18,-44},{-26,-44}}, color={0,127,255}));
  connect(senRelPre_DHWCoil.port_a,bufferStorage. portHC1In) annotation (Line(
        points={{-20,-14},{-10,-14},{-10,13.4},{1.6,13.4}},color={0,127,255}));
  connect(senRelPre_DHWCoil.port_b,bufferStorage. portHC1Out) annotation (Line(
        points={{-4,-14},{-2,-14},{-2,7.2},{1.8,7.2}},       color={0,127,255}));
  connect(m_flow_freshW.ports[1],pumpDHW. port_a) annotation (Line(points={{68,-40},
          {68,-40},{68,-56},{52,-56}},      color={0,127,255}));
  connect(HeatingRod.port_b,bufferStorage. portHC1In) annotation (Line(points={{-44,52},
          {-24,52},{-24,13.4},{1.6,13.4}},         color={0,127,255}));
  connect(control.Q_HeatingRod_OnOff,HeatingRod. u) annotation (Line(points={{12.6,70},
          {-68,70},{-68,58},{-66,58}},         color={0,0,127}));
  connect(control_Pump.dp_pump_HP, pumpHP.dp_in) annotation (Line(points={{36.4,
          92.2},{36.4,29.1},{-36,29.1},{-36,-32}}, color={0,0,127}));
  connect(control_Pump.dp_pump_demand, pumpDHW.dp_in) annotation (Line(points={{36.6,
          80.2},{36.6,25.1},{42,25.1},{42,-44}},       color={0,0,127}));
  connect(control_Pump.m_flow_pump_demand, m_flow_freshW.m_flow_in) annotation (
     Line(points={{36.6,86},{94,86},{94,-32},{88,-32}},   color={0,0,127}));
  connect(bufferStorage.fluidportTop2, dHW.dhw_in) annotation (Line(points={{23,
          22.2},{31.5,22.2},{31.5,36},{39.6,36}}, color={0,127,255}));
  connect(dHW.dhw_out, bou2.ports[1]) annotation (Line(points={{60.4,36},{68,36},
          {68,66},{72,66}}, color={0,127,255}));
  connect(dHW.Q_dhw, control.Q_demand1) annotation (Line(points={{61,46},{26,46},
          {26,73},{-8,73}}, color={0,0,127}));
  connect(dHW.dhw_OnOff, control_Pump.Q_demand) annotation (Line(points={{61,
          55.4},{52.5,55.4},{52.5,80.2},{15.4,80.2}}, color={0,0,127}));
  connect(pumpHP.port_b, heatPump_Carnot_VDI.port_a1) annotation (Line(points={
          {-46,-44},{-52,-44},{-52,6},{-60,6}}, color={0,127,255}));
  connect(heatPump_Carnot_VDI.port_b1, HeatingRod.port_a) annotation (Line(
        points={{-60,25.8},{-62,25.8},{-62,52},{-64,52}}, color={0,127,255}));
  connect(heatPump_Carnot_VDI.Q_flow_HP_out, control.Q_HP_actual1) annotation (
      Line(points={{-80,26.2},{-44,26.2},{-44,64},{-8,64}}, color={0,0,127}));
  connect(heatPump_Carnot_VDI.Q_flow_HP_out, control_Pump.Q_HP_actual)
    annotation (Line(points={{-80,26.2},{-32,26.2},{-32,92.2},{15.4,92.2}},
        color={0,0,127}));
  connect(senRelPre_HP.port_a, heatPump_Carnot_VDI.port_a1) annotation (Line(
        points={{-82,-16},{-72,-16},{-72,6},{-60,6}}, color={0,127,255}));
  connect(senRelPre_HP.port_b, heatPump_Carnot_VDI.port_b1) annotation (Line(
        points={{-66,-16},{-64,-16},{-64,25.8},{-60,25.8}}, color={0,127,255}));
  connect(control.switch_HeatPump_OnOff, heatPump_Carnot_VDI.HP_OnOff)
    annotation (Line(points={{12.8,58},{-28,58},{-28,5.2},{-70,5.2}}, color={0,
          0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPump_DHW_VDI;
