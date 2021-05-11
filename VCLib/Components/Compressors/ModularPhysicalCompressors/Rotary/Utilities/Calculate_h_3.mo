within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Calculate_h_3

    extends Modelica.Icons.Example;
  package Medium_calc =
     VCLib.Media.Refrigerants.R290.R290_IIR_P05_30_T263_343_Horner;

  Medium_calc.ThermodynamicState state_3;

  Medium_calc.SaturationProperties satp;

  Temperature T_3;

  Pressure p_3;
  Pressure p_min;
  Pressure p_max;

  SpecificEnthalpy h_3;

equation

  satp = Medium_calc.setSat_p(p_3);

  //state_3 = Medium_calc.setBubbleState(satp);
  state_3 = Medium_calc.setState_pT(p=p_3, T= T_3);

  h_3 = Medium_calc.specificEnthalpy(state_3);

  p_min = 1e5;
  p_max = 32e5;

  p_3 = p_min + (p_max - p_min)/100*time;

  //T_3 = state_3.T;
  T_3 = 273.15 + 40;

    // Critical Points

  // R32
  // p_crit = 5782000;
  // T_crit = 351.255;

  // R134a
  // p_crit = 4059280;
  // T_crit = 374.21;

  // R744
  // p_crit = 7377300;
  // T_crit = 304.1282;

  // R410a
  // p_crit = 4901200;
  // T_crit = 344.494;

  // R290
  // p_crit = 4251200;
  // T_crit = 369.89;
annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100,
      Interval=1,
      __Dymola_Algorithm=""));
end Calculate_h_3;
