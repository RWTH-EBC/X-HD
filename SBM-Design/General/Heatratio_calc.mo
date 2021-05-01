within Configurations.General;
model Heatratio_calc
  Modelica.Blocks.Interfaces.RealInput dotQ_design
    annotation (Placement(transformation(extent={{-126,-80},{-86,-40}})));
  Modelica.Blocks.Interfaces.RealInput dotQ_actual
    annotation (Placement(transformation(extent={{-126,40},{-86,80}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{36,-10},{56,10}})));
  Modelica.Blocks.Interfaces.RealOutput y_Heater
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0)
    annotation (Placement(transformation(extent={{-64,50},{-44,70}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(division.y, y_Heater)
    annotation (Line(points={{57,0},{106,0},{106,0}}, color={0,0,127}));
  connect(dotQ_actual, greaterThreshold.u)
    annotation (Line(points={{-106,60},{-106,60},{-66,60}}, color={0,0,127}));
  connect(greaterThreshold.y, switch1.u2)
    annotation (Line(points={{-43,60},{-43,0},{-16,0}}, color={255,0,255}));
  connect(switch1.y, division.u1)
    annotation (Line(points={{7,0},{20,0},{20,6},{34,6}}, color={0,0,127}));
  connect(dotQ_actual, switch1.u1) annotation (Line(points={{-106,60},{-62,60},
          {-62,8},{-16,8}}, color={0,0,127}));
  connect(const.y, switch1.u3) annotation (Line(points={{-39,-10},{-28,-10},{
          -28,-8},{-16,-8}}, color={0,0,127}));
  connect(dotQ_design, division.u2) annotation (Line(points={{-106,-60},{26,-60},
          {26,-6},{34,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={194,200,198},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-44,18},{56,-12}},
          lineColor={28,108,200},
          fillColor={194,200,198},
          fillPattern=FillPattern.Solid,
          textString="Heat ratio calc"),
        Text(
          extent={{-82,70},{-42,50}},
          lineColor={0,0,0},
          fillColor={194,200,198},
          fillPattern=FillPattern.Solid,
          textString="dotQ_actual"),
        Text(
          extent={{-80,-50},{-36,-72}},
          lineColor={0,0,0},
          fillColor={194,200,198},
          fillPattern=FillPattern.Solid,
          textString="dotQ_design"),
        Text(
          extent={{70,8},{104,-8}},
          lineColor={0,0,0},
          fillColor={194,200,198},
          fillPattern=FillPattern.Solid,
          textString="u")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Heatratio_calc;
