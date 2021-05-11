within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Calculate_p_comp_in
   extends Modelica.Icons.Example;
  package Medium_calc =
      VCLib.Media.Refrigerants.R410a.R410a_IIR_P1_48_T233_473_Horner;

  Medium_calc.SaturationProperties satT;
  SpecificEnthalpy h_in;
  SpecificEnthalpy h_out_is;
  SpecificEntropy s_in;

  Medium_calc.ThermodynamicState dew_state;
  Medium_calc.ThermodynamicState state_in;

  Temperature T_comp_in;
  Temperature T_sat;
  Pressure p_comp_in;
  Pressure p_comp_out;
  Real dT_sh;

  Real PI;

equation

  T_comp_in = 261.15;

  dT_sh = 5;
  T_sat = T_comp_in - dT_sh;
  satT = Medium_calc.setSat_T(T_sat);
  dew_state = Medium_calc.setDewState(satT);
  p_comp_in = dew_state.p;

  state_in = Medium_calc.setState_pT(p=p_comp_in, T=T_comp_in);

  h_in = Medium_calc.specificEnthalpy(state_in);
  s_in = Medium_calc.specificEntropy(state_in);

  PI = 3;

  p_comp_out = p_comp_in*PI;

  h_out_is = Medium_calc.specificEnthalpy_ps(p=p_comp_out, s=s_in);

end Calculate_p_comp_in;
