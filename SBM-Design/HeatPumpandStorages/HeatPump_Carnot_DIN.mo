within Configurations.HeatPumpandStorages;
model HeatPump_Carnot_DIN

  parameter Real dp_HP = 25000 "Pa"
                                   annotation(Evaluate=false);
  parameter Real m_flow_HP = 0.26 "kg/s"
                                        annotation(Evaluate=false);

  parameter Real T_NA = 261.15 "K"
                                  annotation(Evaluate=false);
  parameter Real T_Biv_para = 271.15 "K"
                                        annotation(Evaluate=false); //Bivalence temperature used for parameterization of heat pump characteristic (here: based on DIN or VDI: bivalence temperature is -2 °C)
  parameter Real Q_flow_HP_Biv_para = 8248.21 "W" annotation(Evaluate=false); //Heat pump heating load at T_Biv_para; here, the guidelines provided by German standards DIN 15450/VDI4645 are used
  parameter Real Q_flow_HP_Biv = 8248.21 "W" annotation(Evaluate=false);
  parameter Real Q_NA_Building = 9710.1 "W" annotation(Evaluate=false); //without DHW
  parameter Real Q_flow_NA_HP_para = 0.46*Q_NA_Building "W" annotation(Evaluate=false); //Assumption based on DIN 4701
  parameter Real Q_flow_NA_HP = Q_flow_NA_HP_para+(Q_flow_HP_Biv-Q_flow_HP_Biv_para)
                                                                                    annotation(Evaluate=false);
  parameter Real gradient_HP = (Q_flow_HP_Biv_para-0.46*Q_NA_Building)/(T_Biv_para-T_NA)
                                                                                        annotation(Evaluate=false); //gradient of the heat pump performance characteristic in dotQ/T diagram

  parameter Real T_Max = 327.15 "K";
  parameter Real Q_flow_HP_max = gradient_HP*(T_Max-T_NA)+Q_flow_NA_HP "W" annotation(Evaluate=false); //Maximum temperatur that occurs during year


  AixLib.Fluid.HeatExchangers.HeaterCooler_u Heater_Ideal(
    show_T=true,
    final m_flow_nominal=m_flow_HP,
    final dp_nominal=dp_HP,
    final Q_flow_nominal=Q_flow_HP_max,
    redeclare package Medium = Medium,
    T_start=318.15)
    annotation (Placement(transformation(extent={{6,22},{26,42}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{88,-110},{108,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_HP_out "Heat added to the fluid"
    annotation (Placement(transformation(extent={{92,90},{112,110}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-18,68},{-8,78}})));
  Modelica.Blocks.Interfaces.RealInput T_amb annotation (Placement(
        transformation(extent={{-122,16},{-86,52}}), iconTransformation(extent=
            {{-116,-8},{-100,8}})));
  Modelica.Blocks.Interfaces.BooleanInput HP_onoff
    annotation (Placement(transformation(extent={{-124,60},{-84,100}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-58,74},{-46,86}})));
  Modelica.Blocks.Sources.Constant Q_HP(k=1)
    annotation (Placement(transformation(extent={{-78,86},{-66,98}})));
  Modelica.Blocks.Sources.Constant Q_HP1(k=0)
    annotation (Placement(transformation(extent={{-78,64},{-66,76}})));
  General.Calc_HP_HeatingPower calc_HP_HeatingPower(
    final T_NA=T_NA,
    final T_Biv_para=T_Biv_para,
    final Q_flow_NA_HP_para=Q_flow_NA_HP_para,
    final Q_NA_Building=Q_NA_Building,
    final Q_flow_HP_Biv_para=Q_flow_HP_Biv_para,
    final gradient_HP=gradient_HP,
    final Q_flow_HP_Biv=Q_flow_HP_Biv,
    final Q_flow_HP_max=Q_flow_HP_max)
    annotation (Placement(transformation(extent={{-56,24},{-24,46}})));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
equation


  connect(Heater_Ideal.port_b, port_b1)
    annotation (Line(points={{26,32},{26,-100},{98,-100}},
                                                        color={0,127,255}));
  connect(Heater_Ideal.port_a, port_a1)
    annotation (Line(points={{6,32},{6,-100},{-100,-100}}, color={0,127,255}));
  connect(Heater_Ideal.Q_flow, Q_flow_HP_out) annotation (Line(points={{27,38},
          {30,38},{30,100},{102,100}},color={0,0,127}));
  connect(product.y, Heater_Ideal.u) annotation (Line(points={{-7.5,73},{-2,73},
          {-2,38},{4,38}}, color={0,0,127}));
  connect(Q_HP.y, switch1.u1) annotation (Line(points={{-65.4,92},{-62,92},{-62,
          84.8},{-59.2,84.8}}, color={0,0,127}));
  connect(HP_onoff, switch1.u2)
    annotation (Line(points={{-104,80},{-59.2,80}}, color={255,0,255}));
  connect(switch1.y, product.u1) annotation (Line(points={{-45.4,80},{-32,80},{
          -32,76},{-19,76}}, color={0,0,127}));
  connect(Q_HP1.y, switch1.u3) annotation (Line(points={{-65.4,70},{-62,70},{
          -62,75.2},{-59.2,75.2}}, color={0,0,127}));
  connect(T_amb, calc_HP_HeatingPower.T_amb) annotation (Line(points={{-104,34},
          {-80,34},{-80,35},{-56.96,35}}, color={0,0,127}));
  connect(calc_HP_HeatingPower.Q_flow_HP_rel, product.u2) annotation (Line(
        points={{-23.36,35},{-23.36,52.5},{-19,52.5},{-19,70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{100,100},{-100,-100}},
          pattern=LinePattern.None,
          lineThickness=1,
          lineColor={0,0,0},
          fillColor={212,35,19},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,72},{72,-72}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="HeatPump
Carnot"),
        Rectangle(
          extent={{-98,98},{100,-100}},
          pattern=LinePattern.None,
          lineThickness=1),
        Rectangle(
          extent={{-100,100},{-32,22}},
          pattern=LinePattern.None,
          lineThickness=1)}),                                    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPump_Carnot_DIN;
