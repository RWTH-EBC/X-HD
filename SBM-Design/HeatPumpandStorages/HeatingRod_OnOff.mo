within Configurations.HeatPumpandStorages;
model HeatingRod_OnOff
  parameter Real m_flow_nominal = 0.26 "kg/s" annotation(Evaluate=false);
  parameter Real Q_design = 6641.61 "W" annotation(Evaluate=false);
  parameter Real dp_max_HR = 10000 "Pa";
  AixLib.Fluid.HeatExchangers.HeaterCooler_u Heater_ideal(
    final Q_flow_nominal=Q_design,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_max_HR,
    redeclare package Medium = Medium)
                                    annotation (Placement(transformation(
        extent={{-16,-13},{16,13}},
        rotation=0,
        origin={58,-59})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{86,-70},{106,-50}}),
        iconTransformation(extent={{20,-142},{60,-102}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-106,-70},{-86,-50}}),
        iconTransformation(extent={{-62,-142},{-22,-102}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_HeatingRod
    "Heat added to the fluid"
    annotation (Placement(transformation(extent={{98,80},{118,100}}),
        iconTransformation(extent={{78,60},{118,100}})));
  Modelica.Blocks.Interfaces.BooleanInput u1
    "Connector of second Boolean input signal" annotation (Placement(
        transformation(extent={{-120,50},{-80,90}}),    iconTransformation(
          extent={{-120,50},{-80,90}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-38,0},{-18,20}})));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
equation
  connect(Heater_ideal.port_b, port_b1) annotation (Line(points={{74,-59},{74,
          -59},{74,-60},{96,-60}},
                                 color={0,127,255}));
  connect(Heater_ideal.port_a, port_a1) annotation (Line(points={{42,-59},{-42,
          -59},{-42,-60},{-96,-60}},
                                   color={0,127,255}));
  connect(Heater_ideal.Q_flow, Q_flow_HeatingRod) annotation (Line(points={{75.6,
          -51.2},{75.6,34},{76,34},{76,90},{108,90}},
                                                    color={0,0,127}));
  connect(booleanToReal.u, u1) annotation (Line(points={{-40,10},{-68,10},{-68,
          70},{-100,70}}, color={255,0,255}));
  connect(booleanToReal.y, Heater_ideal.u) annotation (Line(points={{-17,10},{
          12,10},{12,-51.2},{38.8,-51.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-60,100},{60,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-32,54},{34,-18}},
          lineColor={0,0,0},
          textString="HR")}),                                    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatingRod_OnOff;
