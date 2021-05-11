within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities.Geometry;
model test_Volumes_2
Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(
        displayUnit="deg/s") = 314.15926535898)
  annotation (Placement(transformation(extent={{-82,36},{-62,56}})));
  Controller controller
    annotation (Placement(transformation(extent={{-36,-36},{-16,-16}})));
  Volumes volumes
    annotation (Placement(transformation(extent={{-6,26},{14,46}})));
equation
  connect(constantSpeed.flange, controller.flange_a)
    annotation (Line(points={{-62,46},{-26,46},{-26,-17}}, color={0,0,0}));
  connect(volumes.flange_a, controller.flange_a)
    annotation (Line(points={{4,45.8},{-26,45.8},{-26,-17}},
                                                          color={0,0,0}));
  connect(volumes.V2, controller.V_in) annotation (Line(points={{-6,43},{28,43},
          {28,38},{42,38},{42,-2},{-64,-2},{-64,-21},{-36,-21}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_Volumes_2;
