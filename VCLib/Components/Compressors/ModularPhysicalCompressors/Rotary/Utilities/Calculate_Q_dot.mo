within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Calculate_Q_dot

  extends Modelica.Icons.Example;
  package Medium_calc =
      VCLib.Media.Refrigerants.R290.R290_IIR_P05_30_T263_343_Horner;

  Medium_calc.SaturationProperties satp;
  Medium_calc.ThermodynamicState state_1;

  Medium_calc.SaturationProperties satT;
  Medium_calc.ThermodynamicState state_2;
   Medium_calc.ThermodynamicState state_2_g;
      Medium_calc.ThermodynamicState state_2_f;
         Medium_calc.ThermodynamicState state_3;

  Pressure p_1;
  Pressure p_2;

  Temperature T_2;
  Temperature T_2_g;
  Temperature T_2_f;
  Temperature T_3;

  SpecificHeatCapacity c_p_g;
  SpecificHeatCapacity c_p_f;
  SpecificEnthalpy delta_h_v;
  SpecificEnthalpy delta_h_g;
  SpecificEnthalpy delta_h_f;
  SpecificEnthalpy delta_h_total;

  SpecificEntropy s_2;

equation

  //T_2 = 273.15 + 60;

  T_2_g = T_2 - 40;

  T_2_f = T_2_g;

  T_3 = T_2_f - 5;

  //p_2 = state_2_g.p;

  p_1 = 3e5;

  p_2 = p_1 + 5e5;

  satp = Medium_calc.setSat_p(p_1);

  state_1 = Medium_calc.setDewState(satp);

  s_2 = Medium_calc.specificEntropy(state_1);

  satT = Medium_calc.setSat_T(T_2_g);

  state_2_g = Medium_calc.setDewState(satT);

  state_2_f = Medium_calc.setBubbleState(satT);

  state_2 = Medium_calc.setState_ps(p=p_2,s=s_2);

  state_3 = Medium_calc.setState_pT(p=p_2, T=T_3);

  c_p_g = Medium_calc.specificHeatCapacityCp(state_2);

  c_p_f = Medium_calc.specificHeatCapacityCp(state_3);

  delta_h_v = Medium_calc.specificEnthalpy(state_2_g)-Medium_calc.specificEnthalpy(state_2_f);

  delta_h_g = c_p_g * (T_2-T_2_g);

  delta_h_f = c_p_f * (T_2_f - T_3);

  delta_h_total = delta_h_v + delta_h_g + delta_h_f;

  delta_h_total = 450000;

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

end Calculate_Q_dot;
