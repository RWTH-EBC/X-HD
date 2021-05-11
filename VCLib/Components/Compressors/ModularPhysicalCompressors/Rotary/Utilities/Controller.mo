within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Controller

  extends
    ModularPhysicalCompressors.Rotary.Utilities.CompressorSpecifications;

  Modelica.Blocks.Interfaces.RealInput V_in
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
  Modelica.Blocks.Interfaces.RealOutput V_out
    annotation (Placement(transformation(extent={{80,30},{120,70}})));

  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

equation

  flange_a.tau = 0;

  V_out = if (flange_a.phi < pi) then V_v else V_in;

end Controller;
