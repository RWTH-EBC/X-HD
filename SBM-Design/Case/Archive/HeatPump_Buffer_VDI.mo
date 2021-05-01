within Configurations.Case.Archive;
model HeatPump_Buffer_VDI
  AixLib.Fluid.Storage.BufferStorage bufferStorage(
    useHeatingCoil2=false,
    useHeatingRod=false,
    n=5,
    alphaHC1=100,
    useHeatingCoil1=false,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC1 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    data=AixLib.DataBase.Storage.Generic_New_2000l(
        hTank=0.9383,
        hUpperPorts=0.8954,
        hHC1Up=0.843,
        hHR=0.5,
        dTank=0.4768,
        hTS2=0.8933))
    annotation (Placement(transformation(extent={{-6,-30},{18,0}})));

  AixLib.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=1,
    p=200000)
    annotation (Placement(transformation(extent={{102,-58},{90,-46}})));

  AixLib.Fluid.HeatExchangers.HeaterCooler_u HeatingCoil(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    dp_nominal=25000,
    m_flow_nominal=pumpHP.m_flow_nominal,
    Q_flow_nominal=5520.86)
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-34,34})));

  DataBase.Tamb_TRYAachen_2a tamb_TRYAachen
    annotation (Placement(transformation(extent={{-212,32},{-192,52}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        291.15)
    annotation (Placement(transformation(extent={{36,-20},{26,-10}})));
  General.Carnot_calc carnot_calc
    annotation (Placement(transformation(extent={{4,-86},{24,-66}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-32,-68},{-22,-58}})));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-82,24},{-70,38}})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpHP(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=0.279,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.VeroLine50slash150dash4slash2
      per,
    addPowerToMedium=false,
    dp_nominal=135832.0143)
    annotation (Placement(transformation(extent={{-26,-46},{-46,-26}})));

  AixLib.Fluid.Movers.FlowControlled_dp pumpHC(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=building.dp_max_building,
    m_flow_nominal=building.m_flow_building,
    redeclare AixLib.Fluid.Movers.Data.Pumps.Wilo.TopS25slash10 per)
    annotation (Placement(transformation(extent={{62,-58},{42,-38}})));

  DataBase.Tamb_TRYAachen_2a T_amb
    annotation (Placement(transformation(extent={{-40,-86},{-28,-74}})));
  Controls.Control_Pump control_Pump(                 dp_max_demand=building.dp_max_building,
      dp_max_HP=50000)
    annotation (Placement(transformation(extent={{40,56},{60,76}})));
  Buildings.Building building(dp_max_building=100000)
    annotation (Placement(transformation(extent={{24,6},{44,26}})));
  HeatPumpandStorages.HeatPump_Carnot_VDI heatPump_Carnot_VDI(Q_flow_Biv=
        7127.46, m_flow_HP=pumpHP.m_flow_nominal)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-74,-16})));
equation
  connect(HeatingCoil.port_b, bufferStorage.fluidportTop1) annotation (Line(
        points={{-24,34},{2,34},{2,0.15},{1.8,0.15}}, color={0,127,255}));
  connect(fixedTemperature.port, bufferStorage.heatportOutside) annotation (
      Line(points={{26,-15},{22,-15},{22,-14.1},{17.7,-14.1}}, color={191,0,0}));
  connect(greaterThreshold.y, carnot_calc.HP_on) annotation (Line(points={{
          -21.5,-63},{-9.75,-63},{-9.75,-76},{3.4,-76}}, color={255,0,255}));
  connect(pumpHP.port_a, bufferStorage.fluidportBottom1) annotation (Line(
        points={{-26,-36},{-12,-36},{-12,-30.3},{1.95,-30.3}}, color={0,127,255}));
  connect(pumpHC.port_b, bufferStorage.fluidportBottom2) annotation (Line(
        points={{42,-48},{26,-48},{26,-30.15},{9.45,-30.15}}, color={0,127,255}));
  connect(bou.ports[1], pumpHC.port_a) annotation (Line(points={{90,-52},{76,
          -52},{76,-48},{62,-48}}, color={0,127,255}));
  connect(temperature.T, carnot_calc.T_supply) annotation (Line(points={{-71.8,
          31},{-40.9,31},{-40.9,-70},{3.6,-70}}, color={0,0,127}));
  connect(bufferStorage.TTop, control.T_Top1) annotation (Line(points={{-6,-1.8},
          {-20,-1.8},{-20,67.2},{-32,67.2}}, color={0,0,127}));
  connect(T_amb.y, carnot_calc.T_amb) annotation (Line(points={{-27.4,-80},{-12,
          -80},{-12,-81.2},{3.2,-81.2}}, color={0,0,127}));
  connect(control.Q_HeatingRod_OnOff, HeatingCoil.u) annotation (Line(points={{-11.4,
          82},{-52,82},{-52,40},{-46,40}},       color={0,0,127}));
  connect(control_Pump.dp_pump_HP, pumpHP.dp_in) annotation (Line(points={{60.4,
          72.2},{83.2,72.2},{83.2,-24},{-36,-24}}, color={0,0,127}));
  connect(control_Pump.dp_pump_demand, pumpHC.dp_in) annotation (Line(points={{
          60.6,60.2},{60.6,4.1},{52,4.1},{52,-36}}, color={0,0,127}));
  connect(bufferStorage.fluidportTop2, building.building_in) annotation (Line(
        points={{9.75,0.15},{16.875,0.15},{16.875,6},{24,6}}, color={0,127,255}));
  connect(building.building_out, pumpHC.port_a) annotation (Line(points={{44,6},
          {70,6},{70,-48},{62,-48}}, color={0,127,255}));
  connect(building.HeatDemand_OnOff, control_Pump.Q_demand) annotation (Line(
        points={{44.8,26},{38,26},{38,60.2},{39.4,60.2}}, color={0,0,127}));
  connect(building.Q_demand, control.Q_demand1) annotation (Line(points={{44.6,
          16},{4,16},{4,85},{-32,85}}, color={0,0,127}));
  connect(temperature.port, heatPump_Carnot_VDI.port_b1) annotation (Line(
        points={{-76,24},{-68,24},{-68,-6.2},{-64,-6.2}}, color={0,127,255}));
  connect(heatPump_Carnot_VDI.Q_flow_HP_out, control.Q_HP_actual1) annotation (
      Line(points={{-84,-5.8},{-56,-5.8},{-56,76},{-32,76}}, color={0,0,127}));
  connect(heatPump_Carnot_VDI.Q_flow_HP_out, control_Pump.Q_HP_actual)
    annotation (Line(points={{-84,-5.8},{-20,-5.8},{-20,72.2},{39.4,72.2}},
        color={0,0,127}));
  connect(heatPump_Carnot_VDI.Q_flow_HP_out, greaterThreshold.u) annotation (
      Line(points={{-84,-5.8},{-56,-5.8},{-56,-63},{-33,-63}}, color={0,0,127}));
  connect(pumpHP.port_b, heatPump_Carnot_VDI.port_a1) annotation (Line(points={
          {-46,-36},{-52,-36},{-52,-26},{-64,-26}}, color={0,127,255}));
  connect(heatPump_Carnot_VDI.port_b1, HeatingCoil.port_a) annotation (Line(
        points={{-64,-6.2},{-54,-6.2},{-54,34},{-44,34}}, color={0,127,255}));
  connect(control.switch_HeatPump_OnOff, heatPump_Carnot_VDI.HP_OnOff)
    annotation (Line(points={{-11.2,70},{-42,70},{-42,-26.8},{-74,-26.8}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
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
end HeatPump_Buffer_VDI;
