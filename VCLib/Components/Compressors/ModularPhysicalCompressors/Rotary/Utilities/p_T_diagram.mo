within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model p_T_diagram
  // Simulation setup: Interval length = 1s Start Time=0 Stop time = 100

  extends Modelica.Icons.Example;
  Temperature T;

  Pressure p_calc;
  Pressure p;

  package Medium_calc =
      VCLib.Media.Refrigerants.R744.R744_I0_P10_100_T233_373_Horner;

  //VCLib.Media.Refrigerants.R32.R32_IIR_P1_70_T233_373_Horner;
  //VCLib.Media.Refrigerants.R134a.R134a_IIR_P1_395_T233_455_Horner;
  //VCLib.Media.Refrigerants.R744.R744_I0_P10_100_T233_373_Horner;
  //VCLib.Media.Refrigerants.R410A_HEoS.R410a_IIR_P1_48_T233_473_Horner;
  //VCLib.Media.Refrigerants.R290.R290_IIR_P05_30_T263_343_Horner;

equation

  //p_calc = time*1e5;
  p_calc = 100e5/(1 + time/30);

  // R32
  //  p = 33000 + p_calc;

  // R134a
  // p = 100 + p_calc/5;

  // R744
   p =5.1e5 + p_calc/3;

  // R410a
  // p = 1000 + p_calc/4;

  // R290
  // p = 1000 + p_calc/7;
  // p = p_calc/10;

  //p = 8.131e5;

  T = Medium_calc.saturationTemperature(p);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100,
      Interval=100,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"));
end p_T_diagram;
