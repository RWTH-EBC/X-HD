within VCLib.HeatPumpFlowSheets.HPS_model.Components.Controls;
model Counter_switchOn
  "counter for the number of times the machine switches on"
  Modelica.Blocks.Interfaces.BooleanInput IsOn "true when machine is on" annotation (
    Placement(transformation(extent = {{-120, -10}, {-80, 30}}), iconTransformation(extent = {{-120, -16}, {-90, 14}})));
  Modelica.Blocks.Interfaces.RealOutput Count "Connector of Real output signal" annotation (
    Placement(transformation(extent = {{100, -10}, {120, 10}}), iconTransformation(extent = {{100, -10}, {120, 10}})));
  Modelica.Blocks.Logical.Edge edge annotation (
    Placement(transformation(extent = {{-60, 0}, {-40, 20}})));
equation
  when edge.y then
    Count = pre(Count) + 1;
  end when;
  connect(IsOn, edge.u) annotation (
    Line(points = {{-100, 10}, {-62, 10}}, color = {255, 0, 255}, smooth = Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-100, 100}, {100, -100}},
            lineThickness =                                                                                                                                             1, fillColor = {215, 215, 215},
            fillPattern =                                                                                                                                                                                             FillPattern.Solid, pattern = LinePattern.None, lineColor = {0, 0, 0}), Line(points = {{-100, -80}, {-80, -80}, {-80, -60}, {-42, -60}, {-42, -40}, {-24, -40}, {-24, -20}, {-10, -20}, {-10, 0}, {18, 0}, {18, 20}, {46, 20}, {46, 40}, {64, 40}, {64, 60}, {78, 60}, {78, 80}, {100, 80}}, color = {255, 85, 255}, smooth = Smooth.None, thickness = 0.5)}),
    Documentation(revisions = "<html>
<p>10.01.2014,  Ana Constantin</p>
<p><ul>
<li>implemented</li>
</ul></p>
</html>"));
end Counter_switchOn;
