within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model logp_h_diagram
 "Model that tests the implementation of the refrigerant properties"

  extends Modelica.Icons.Example;
  // Define the refrigerant that shall be tested
  //AixLib.Media.Refrigerants.R32.R32_IIR_P1_70_T233_373_Horner;
  //AixLib.Media.Refrigerants.R134a.R134a_IIR_P1_395_T233_455_Horner;
  //AixLib.Media.Refrigerants.R744.R744_I0_P10_100_T233_373_Horner;
  //AixLib.Media.Refrigerants.R410A_HEoS.R410a_IIR_P1_48_T233_473_Horner;
  //AixLib.Media.Refrigerants.R290.R290_IIR_P05_30_T263_343_Horner;

  package MediumPri =
      VCLib.Media.Refrigerants.R410a.R410a_IIR_P1_48_T233_473_Horner
    "Internal medium model";

  Real dewEnthalpy "Actual dew state";

  Real bubbleEnthalpy "Actual dew state";

  MediumPri.SaturationProperties satT
    "Actual saturation properties calculated with temperature";

  parameter Real pLoop=1e5;
  Modelica.Blocks.Sources.RealExpression dewenthalpy(y=dewEnthalpy) annotation (
     Placement(transformation(
        extent={{-13,10},{13,-10}},
        rotation=0,
        origin={-13,16})));

  Modelica.Blocks.Sources.RealExpression bubbleenthalpy(y=bubbleEnthalpy)
    annotation (Placement(transformation(
        extent={{-13,10},{13,-10}},
        rotation=0,
        origin={-13,-6})));

  Modelica.Blocks.Interfaces.RealOutput dewEnthalpyOutput
    "Value of Real output"
    annotation (Placement(transformation(extent={{12,6},{32,26}})));

  Modelica.Blocks.Interfaces.RealOutput bubbleEnthalpyOutput
    "Value of Real output"
    annotation (Placement(transformation(extent={{12,-16},{32,4}})));

equation
  satT = MediumPri.setSat_p(pLoop);
  dewEnthalpy = MediumPri.dewEnthalpy(satT);

  bubbleEnthalpy = MediumPri.bubbleEnthalpy(satT);

  connect(dewenthalpy.y, dewEnthalpyOutput)
    annotation (Line(points={{1.3,16},{22,16}}, color={0,0,127}));

  connect(bubbleenthalpy.y, bubbleEnthalpyOutput)
    annotation (Line(points={{1.3,-6},{22,-6}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end logp_h_diagram;
