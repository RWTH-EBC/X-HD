within Configurations.Controls;
model Control_Pump

  parameter Real dp_max_HP = 100000 "Pa";
  parameter Real m_flow_pump_max = 5.5/60 "kg/s";
  parameter Real dp_max_demand = 25000 "Pa";


  Modelica.Blocks.Interfaces.RealInput Q_HP_actual
    annotation (Placement(transformation(extent={{-126,42},{-86,82}})));
  Modelica.Blocks.Interfaces.RealOutput dp_pump_HP
    annotation (Placement(transformation(extent={{94,52},{114,72}})));
  Modelica.Blocks.Interfaces.RealOutput dp_pump_demand
    annotation (Placement(transformation(extent={{96,-68},{116,-48}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-76,56},{-64,68}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{8,56},{20,68}})));
  Modelica.Blocks.Sources.Constant const2(k=dp_max_HP)
    annotation (Placement(transformation(extent={{-64,78},{-52,90}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-64,36},{-52,48}})));
  Modelica.Blocks.Interfaces.RealInput Q_demand
    annotation (Placement(transformation(extent={{-126,-78},{-86,-38}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1
    annotation (Placement(transformation(extent={{-76,-64},{-64,-52}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{0,-6},{12,6}})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{-28,-64},{-16,-52}})));
  Modelica.Blocks.Sources.Constant const3(k=m_flow_pump_max)
    annotation (Placement(transformation(extent={{-36,22},{-24,34}})));
  Modelica.Blocks.Sources.Constant const4(k=dp_max_demand)
    annotation (Placement(transformation(extent={{-58,-82},{-46,-70}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_pump_demand
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-32,62},{-18,76}})));
  Modelica.Blocks.Interfaces.RealInput HeatingRod_actual
    annotation (Placement(transformation(extent={{-124,-20},{-84,20}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2
    annotation (Placement(transformation(extent={{-76,-6},{-64,6}})));
equation
  connect(Q_HP_actual, greaterThreshold.u)
    annotation (Line(points={{-106,62},{-77.2,62}}, color={0,0,127}));
  connect(const2.y, switch1.u1) annotation (Line(points={{-51.4,84},{6.8,84},{
          6.8,66.8}},   color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{-51.4,42},{-50,42},{
          -50,57.2},{6.8,57.2}},
                               color={0,0,127}));
  connect(switch1.y, dp_pump_HP)
    annotation (Line(points={{20.6,62},{58,62},{104,62}},
                                                   color={0,0,127}));
  connect(const1.y, switch2.u3) annotation (Line(points={{-51.4,42},{-44,42},{
          -44,-4.8},{-1.2,-4.8}},color={0,0,127}));
  connect(const1.y, switch3.u3) annotation (Line(points={{-51.4,42},{-44,42},{-44,
          -62.8},{-29.2,-62.8}}, color={0,0,127}));
  connect(Q_demand, greaterThreshold1.u)
    annotation (Line(points={{-106,-58},{-77.2,-58}}, color={0,0,127}));
  connect(greaterThreshold1.y, switch2.u2) annotation (Line(points={{-63.4,-58},
          {-36,-58},{-36,0},{-1.2,0}},      color={255,0,255}));
  connect(greaterThreshold1.y, switch3.u2)
    annotation (Line(points={{-63.4,-58},{-29.2,-58}}, color={255,0,255}));
  connect(const3.y, switch2.u1) annotation (Line(points={{-23.4,28},{-22,28},{
          -22,4.8},{-1.2,4.8}},      color={0,0,127}));
  connect(const4.y, switch3.u1) annotation (Line(points={{-45.4,-76},{-38,-76},{
          -38,-53.2},{-29.2,-53.2}}, color={0,0,127}));
  connect(switch2.y, m_flow_pump_demand)
    annotation (Line(points={{12.6,0},{12.6,0},{106,0}},   color={0,0,127}));
  connect(switch3.y, dp_pump_demand) annotation (Line(points={{-15.4,-58},{44,-58},
          {106,-58}}, color={0,0,127}));
  connect(greaterThreshold.y, or1.u1) annotation (Line(points={{-63.4,62},{-48,
          62},{-48,69},{-33.4,69}}, color={255,0,255}));
  connect(HeatingRod_actual, greaterThreshold2.u)
    annotation (Line(points={{-104,0},{-77.2,0},{-77.2,0}}, color={0,0,127}));
  connect(greaterThreshold2.y, or1.u2) annotation (Line(points={{-63.4,0},{-48,
          0},{-48,63.4},{-33.4,63.4}}, color={255,0,255}));
  connect(or1.y, switch1.u2) annotation (Line(points={{-17.3,69},{-4.65,69},{
          -4.65,62},{6.8,62}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Control_Pump;
