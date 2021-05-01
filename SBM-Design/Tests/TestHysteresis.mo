within Configurations.Tests;
model TestHysteresis
  Modelica.Blocks.Sources.Pulse pulse(
    period=60,
    width=50,
    amplitude=1.1)
    annotation (Placement(transformation(extent={{-60,-8},{-40,12}})));
  DataBase.Hyteresis_crossed hyteresis_crossed(
    uLow=0,
    uHigh=1.2,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{-12,-12},{8,8}})));
equation
  connect(pulse.y, hyteresis_crossed.u) annotation (Line(points={{-39,2},{-24,2},
          {-24,-2.2},{-12.6,-2.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestHysteresis;
