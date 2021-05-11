within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities.Geometry;
model test_Volumes

Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(
      displayUnit="deg/s") = 314.15926535898)
  annotation (Placement(transformation(extent={{-82,38},{-62,58}})));
  Volumes volumes_independent
    annotation (Placement(transformation(extent={{34,38},{54,58}})));
equation
  connect(constantSpeed.flange, volumes_independent.flange_a)
    annotation (Line(points={{-62,48},{-10,48},{-10,57.8},{44,57.8}},
                                                color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_Volumes;
