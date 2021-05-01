within Configurations.DataBase;
model Test_Table
  dotQ_HP_DIN_onoff dotQ_HP_DIN_onoff1(table=[0.0,1.0,2.0,3.0; 2.0,0.0,0.0,0.0;
        4.0,0.0,6.0,6.0; 6.0,0.0,6.0,6.0])
    annotation (Placement(transformation(extent={{-22,-6},{6,22}})));
  Modelica.Blocks.Sources.Step step(
    height=2,
    startTime=10,
    offset=-3) annotation (Placement(transformation(extent={{-82,8},{-62,28}})));
  Modelica.Blocks.Sources.Step step1(
    offset=1,
    height=1,
    startTime=10)
    annotation (Placement(transformation(extent={{-78,-26},{-58,-6}})));
equation
  connect(step.y, dotQ_HP_DIN_onoff1.u1) annotation (Line(points={{-61,18},{-44,
          18},{-44,16.4},{-24.8,16.4}}, color={0,0,127}));
  connect(step1.y, dotQ_HP_DIN_onoff1.u2) annotation (Line(points={{-57,-16},{
          -42,-16},{-42,-0.4},{-24.8,-0.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Test_Table;
