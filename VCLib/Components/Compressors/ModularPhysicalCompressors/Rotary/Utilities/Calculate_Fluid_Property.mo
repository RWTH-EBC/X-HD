within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Calculate_Fluid_Property
  extends Modelica.Icons.Example;
  package Medium_calc =
    VCLib.Media.Refrigerants.R134a.R134a_IIR_P1_395_T233_455_Horner;

  Medium_calc.ThermodynamicState state_1;
    Medium_calc.SaturationProperties satp;
      Medium_calc.ThermodynamicState dew_state;

  SpecificEnthalpy h_1;
  SpecificEnthalpy h_2_is;
  SpecificEnthalpy h_dew;

  SpecificHeatCapacity cp;

  SpecificEntropy s_1;
  Temperature T_1;

  Real Pr;
  Real Kappa_1;

  Pressure p_1;
  Pressure p_2;

  Density rho_1;

  Real PI;

equation

  PI = 1;
  T_1 = 273.15;
  p_1 = 2.45e5;
  //p_1 = 10e5;
  p_2 = p_1*PI;

  satp = Medium_calc.setSat_p(p_1);
  dew_state = Medium_calc.setDewState(satp);
  h_dew = Medium_calc.specificEnthalpy(dew_state);

  cp = Medium_calc.specificHeatCapacityCp(state_1);

  state_1 = Medium_calc.setState_pT(p=p_1, T=T_1);
  Kappa_1 = Medium_calc.isentropicExponent(state_1);

  // Medium_calc.density_pT()
  rho_1 = Medium_calc.density(state_1);

  s_1 = Medium_calc.specificEntropy(state_1);
  h_1 = Medium_calc.specificEnthalpy(state_1);

 // h_1 = Medium_calc.specificEnthalpy_ps(p=p_1, s=s_1);
  h_2_is = Medium_calc.specificEnthalpy_ps(p=p_2, s=s_1);

  Pr = Medium.prandtlNumber(state_1);

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

end Calculate_Fluid_Property;
