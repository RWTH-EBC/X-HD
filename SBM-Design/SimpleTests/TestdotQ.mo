within Configurations.SimpleTests;
model TestdotQ
  DataBase.dotQ_HP_noDHW dotQ_HP_DIN_noDHW
    annotation (Placement(transformation(extent={{-28,-28},{-8,-8}})));
  DataBase.Tamb_TRYAachen_2a tamb_TRYAachen
    annotation (Placement(transformation(extent={{-76,-28},{-56,-8}})));
equation
  connect(tamb_TRYAachen.y, dotQ_HP_DIN_noDHW.u[1])
    annotation (Line(points={{-55,-18},{-42,-18},{-30,-18}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestdotQ;
