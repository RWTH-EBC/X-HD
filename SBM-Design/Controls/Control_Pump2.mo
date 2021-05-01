within Configurations.Controls;
model Control_Pump2

  parameter Real dp_max_pump_heatgeneration "Pa";
  parameter Real dp_max_demand "Pa"; //pressure loss of building or DHW

  parameter Real HeatingLoad "W"
                                annotation(Evaluate=false);
  parameter Real Q_flow_NA_HP "W"
                                 annotation(Evaluate=false);

  parameter Real m_flow_HC "kg/s"
                                 annotation(Evaluate=false);
  parameter Real m_flow_HP = (Q_HR_nominal + (Q_flow_NA_HP+ gradient_HP*(T_thresh-T_NA)))/(4180*T_diff)  "kg/s"
                                                                                                               annotation(Evaluate=false);


  parameter Real T_Biv "K"
                          annotation(Evaluate=false);
  //temperature at bivalence point
  parameter Real T_NA "K"
                         annotation(Evaluate=false);
  //standard outside temperature
  parameter Real T_thresh "K"
                             annotation(Evaluate=false);
  //heating threshold temperatur
  parameter Real T_diff = 10 "K"
                                annotation(Evaluate=false);
  //Temperature difference over heat generator and/or building

  parameter Real Q_Biv "W"
                          annotation(Evaluate=false);
  parameter Real Q_HR_nominal "W"
                                 annotation(Evaluate=false);
  parameter Real gradient_HP annotation(Evaluate=false);
  //gradient of heat pump on/off characteristic; should be given by Heat pump model

  Modelica.Blocks.Interfaces.RealInput Q_HP_actual
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-88,120})));
  Modelica.Blocks.Interfaces.RealOutput dp_pump_HP
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,-100})));
  Modelica.Blocks.Interfaces.RealOutput dp_pump_demand
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-100})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-88,66})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-88,2})));
  Modelica.Blocks.Sources.Constant const2(final k=dp_max_pump_heatgeneration)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-56,46})));
  Modelica.Blocks.Sources.Constant const1(final k=0)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-40,88})));
  Modelica.Blocks.Interfaces.RealInput Q_demand
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={90,120})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={90,66})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={66,-26})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={92,20})));
  Modelica.Blocks.Sources.Constant const3(final k=m_flow_HC)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={50,40})));
  Modelica.Blocks.Sources.Constant const4(final k=dp_max_demand)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={92,48})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_pump_demand
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-100})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-88,34})));
  Modelica.Blocks.Interfaces.RealInput HeatingRod_actual
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,66})));
equation
  connect(Q_HP_actual, greaterThreshold.u)
    annotation (Line(points={{-88,120},{-88,120},{-88,73.2}},
                                                    color={0,0,127}));
  connect(const2.y, switch1.u1) annotation (Line(points={{-56,39.4},{-56,39.4},
          {-56,40},{-56,18},{-83.2,18},{-83.2,9.2}},
                        color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{-40,81.4},{-34,81.4},
          {-34,9.2},{-92.8,9.2}},
                               color={0,0,127}));
  connect(switch1.y, dp_pump_HP)
    annotation (Line(points={{-88,-4.6},{-88,-4.6},{-88,-58},{-88,-58},{-88,
          -100},{-90,-100}},                       color={0,0,127}));
  connect(const1.y, switch2.u3) annotation (Line(points={{-40,81.4},{-34,81.4},
          {-34,10},{62,10},{62,-18},{62,-18},{61.2,-18},{61.2,-18.8}},
                                 color={0,0,127}));
  connect(const1.y, switch3.u3) annotation (Line(points={{-40,81.4},{62,81.4},{
          62,30},{74,30},{74,27.2},{87.2,27.2}},
                                 color={0,0,127}));
  connect(Q_demand, greaterThreshold1.u)
    annotation (Line(points={{90,120},{90,120},{90,96},{90,96},{90,73.2},{92,
          73.2},{90,73.2}},                           color={0,0,127}));
  connect(greaterThreshold1.y, switch2.u2) annotation (Line(points={{90,59.4},{
          66,59.4},{66,4},{66,-18.8}},      color={255,0,255}));
  connect(greaterThreshold1.y, switch3.u2)
    annotation (Line(points={{90,59.4},{92,59.4},{92,28},{92,28},{92,28},{92,
          27.2}},                                      color={255,0,255}));
  connect(const3.y, switch2.u1) annotation (Line(points={{50,33.4},{50,2},{70,2},
          {70,-20},{70.8,-20},{70.8,-18.8}},
                                     color={0,0,127}));
  connect(const4.y, switch3.u1) annotation (Line(points={{92,41.4},{96,41.4},{
          96,26},{96,28},{96.8,28},{96.8,27.2}},
                                     color={0,0,127}));
  connect(switch2.y, m_flow_pump_demand)
    annotation (Line(points={{66,-32.6},{66,-36},{68,-36},{68,-70},{90,-70},{90,
          -84},{90,-100}},                                 color={0,0,127}));
  connect(switch3.y, dp_pump_demand) annotation (Line(points={{92,13.4},{0,13.4},
          {0,-34},{0,-100}},
                      color={0,0,127}));
  connect(greaterThreshold.y, or1.u1) annotation (Line(points={{-88,59.4},{-88,
          59.4},{-88,41.2}},        color={255,0,255}));
  connect(HeatingRod_actual, greaterThreshold2.u)
    annotation (Line(points={{0,120},{1.33227e-015,120},{1.33227e-015,73.2}},
                                                            color={0,0,127}));
  connect(greaterThreshold2.y, or1.u2) annotation (Line(points={{-1.33227e-015,
          59.4},{0,59.4},{0,56},{-2,56},{-92,56},{-92,52},{-92,42},{-92.8,42},{
          -92.8,41.2}},                color={255,0,255}));
  connect(or1.y, switch1.u2) annotation (Line(points={{-88,27.4},{-88,27.4},{
          -88,16},{-88,20},{-88,11.2},{-88,9.2}},
                               color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineThickness=0.5,
          fillColor={213,255,170},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-70,60},{80,-60}},
          lineThickness=0.5,
          textString="PumpControl",
          pattern=LinePattern.None),
        Text(
          extent={{-108,80},{-56,58}},
          lineColor={28,108,200},
          lineThickness=0.5,
          textString="HP"),
        Text(
          extent={{-30,78},{26,58}},
          lineColor={28,108,200},
          lineThickness=0.5,
          textString="HR"),
        Text(
          extent={{50,82},{96,56}},
          lineColor={217,67,180},
          lineThickness=0.5,
          textString="Demand"),
        Text(
          extent={{-2,-16},{94,-82}},
          lineColor={0,140,72},
          lineThickness=0.5,
          textString="m_flow_demand"),
        Text(
          extent={{-40,-32},{32,-112}},
          lineColor={162,29,33},
          lineThickness=0.5,
          textString="dp_demand"),
        Text(
          extent={{-94,-56},{-50,-90}},
          lineColor={162,29,33},
          lineThickness=0.5,
          textString="dp_HP")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Control_Pump2;
