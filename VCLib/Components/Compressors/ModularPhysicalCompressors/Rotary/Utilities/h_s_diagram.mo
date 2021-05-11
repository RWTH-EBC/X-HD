within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model h_s_diagram
  // Simulation setup: Interval Length 1s, Start time 0, Stop time 99

  extends Modelica.Icons.Example;
  package Medium_calc =
      VCLib.Media.Refrigerants.R32.R32_IIR_P1_70_T233_373_Horner;

  //VCLib.Media.Refrigerants.R32.R32_IIR_P1_70_T233_373_Horner;
  //VCLib.Media.Refrigerants.R134a.R134a_IIR_P1_395_T233_455_Horner;
  //VCLib.Media.Refrigerants.R744.R744_I0_P10_100_T233_373_Horner;
  //VCLib.Media.Refrigerants.R410A_HEoS.R410a_IIR_P1_48_T233_473_Horner;
  //VCLib.Media.Refrigerants.R290.R290_IIR_P05_30_T263_343_Horner;

  SpecificEntropy s_bubble;
  SpecificEntropy s_dew;
  SpecificEntropy s_crit;
  SpecificEntropy s;
  SpecificEnthalpy h_bubble;
  SpecificEnthalpy h_dew;
  SpecificEnthalpy h_crit;
  SpecificEnthalpy h_1;
  SpecificEnthalpy h_2;

  Pressure p;
  Pressure p_1;
  Pressure p_2;
  Pressure p_crit "Pressure at critical point";
  Temperature T_crit "Temperature at critical point";

  Medium_calc.ThermodynamicState state_crit "Critical point state";
  Medium_calc.SaturationProperties satT
    "Actual saturation properties calculated with temperature";
  Medium_calc.ThermodynamicState state_1;
    Medium_calc.ThermodynamicState state_2;

  Real factor;

equation

  // Critical Point

  // R32
  p_crit = 5782000;
  T_crit = 351.255;

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

  state_crit = Medium_calc.setState_pT(p=p_crit, T=T_crit);
  s_crit = abs(Medium_calc.specificEntropy(state_crit));
  h_crit = abs(Medium_calc.specificEnthalpy(state_crit));

  // Simulation variables

  factor = p_crit/100;

  // dew and sat lines

  p = p_crit - time*factor;

  satT = Medium_calc.setSat_p(p);

  h_dew = abs(Medium_calc.dewEnthalpy(satT));
  s_dew = abs(Medium_calc.dewEntropy(satT));

  h_bubble = abs(Medium_calc.bubbleEnthalpy(satT));
  s_bubble = abs(Medium_calc.bubbleEntropy(satT));

  // Isobares

  p_2 = 62.93e5;
  p_1 = 8.131e5;
  s = 600 + time*8;
  state_1 = Medium_calc.setState_ps(p=p_1, s=s);
  state_2 = Medium_calc.setState_ps(p=p_2, s=s);
  h_1 = Medium_calc.specificEnthalpy(state_1);
  h_2 = Medium_calc.specificEnthalpy(state_2);

end h_s_diagram;
