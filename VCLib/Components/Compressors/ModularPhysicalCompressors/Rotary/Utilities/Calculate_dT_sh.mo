within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Calculate_dT_sh
  extends Modelica.Icons.Example;
  package Medium_calc =
      VCLib.Media.Refrigerants.R32.R32_IIR_P1_70_T233_373_Horner;

  Medium_calc.SaturationProperties satT;
  Medium_calc.SaturationProperties satp;

  Medium_calc.ThermodynamicState dew_state_T_comp_in;
  Medium_calc.ThermodynamicState dew_state_p_comp_in;

  Temperature T_comp_in;
  Temperature T_sat_p_comp_in;
  Pressure p_sat_T_comp_in;
  Pressure p_comp_in;
  Real dT_sh;

equation

  T_comp_in = 273.15;

  p_comp_in = 6e5;

  satT = Medium_calc.setSat_T(T_comp_in);
  dew_state_T_comp_in = Medium_calc.setDewState(satT);
  p_sat_T_comp_in = dew_state_T_comp_in.p;

  satp = Medium_calc.setSat_p(p_comp_in);
  dew_state_p_comp_in = Medium_calc.setDewState(satp);
  T_sat_p_comp_in = dew_state_p_comp_in.T;

  dT_sh = T_comp_in - T_sat_p_comp_in;

end Calculate_dT_sh;
