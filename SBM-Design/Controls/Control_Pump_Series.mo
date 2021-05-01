within Configurations.Controls;
model Control_Pump_Series

  //Pressure differences within the whole cycle (Series integration only has one cycle for Heat pump, Storage and Building)
  parameter Real dp_max_Cycle = 100000 "Pa";
  parameter Real m_flow_Cycle = (Q_HR_nominal + (Q_flow_NA_HP+ gradient_HP*(T_thresh-T_NA)))/(4180*T_diff)  "kg/s"
                                                                                                                  annotation(Evaluate=false);

  parameter Real HeatingLoad "W" annotation(Evaluate=false);


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

  //Heat flows characterizing the heat generators
  parameter Real Q_flow_NA_HP "W" annotation(Evaluate=false);
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
        origin={0,-104})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-88,66})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,-16})));
  Modelica.Blocks.Sources.Constant const2(final k=dp_max_Cycle)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={52,-4})));
  Modelica.Blocks.Sources.Constant const1(final k=0)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-48,-2})));
  Modelica.Blocks.Interfaces.RealInput Q_demand
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={90,120})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={90,66})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,30})));
  Modelica.Blocks.Interfaces.RealInput HeatingRod_actual
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,66})));
  Modelica.Blocks.Logical.Or or2
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,8})));
equation
  connect(Q_HP_actual, greaterThreshold.u)
    annotation (Line(points={{-88,120},{-88,120},{-88,73.2}},
                                                    color={0,0,127}));
  connect(const2.y, switch1.u1) annotation (Line(points={{45.4,-4},{4.8,-4},{4.8,
          -8.8}},       color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{-41.4,-2},{-34,-2},{-34,
          -8.8},{-4.8,-8.8}},  color={0,0,127}));
  connect(switch1.y, dp_pump_HP)
    annotation (Line(points={{-1.33227e-15,-22.6},{-1.33227e-15,-104},{0,-104}},
                                                   color={0,0,127}));
  connect(Q_demand, greaterThreshold1.u)
    annotation (Line(points={{90,120},{90,120},{90,96},{90,96},{90,73.2},{92,
          73.2},{90,73.2}},                           color={0,0,127}));
  connect(HeatingRod_actual, greaterThreshold2.u)
    annotation (Line(points={{0,120},{1.33227e-015,120},{1.33227e-015,73.2}},
                                                            color={0,0,127}));
  connect(greaterThreshold.y, or1.u2) annotation (Line(points={{-88,59.4},{-88,37.2},
          {-4.8,37.2}}, color={255,0,255}));
  connect(greaterThreshold2.y, or1.u1)
    annotation (Line(points={{0,59.4},{0,37.2}}, color={255,0,255}));
  connect(or1.y, or2.u2) annotation (Line(points={{0,23.4},{-4,23.4},{-4,15.2},{
          -4.8,15.2}}, color={255,0,255}));
  connect(greaterThreshold1.y, or2.u1) annotation (Line(points={{90,59.4},{46,59.4},
          {46,15.2},{0,15.2}}, color={255,0,255}));
  connect(or2.y, switch1.u2)
    annotation (Line(points={{0,1.4},{0,-8.8}}, color={255,0,255}));
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
end Control_Pump_Series;
