within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Calculate_cp_dhl_array

  extends Modelica.Icons.Example;
  package Medium_calc =
      VCLib.Media.Refrigerants.R32.R32_IIR_P1_70_T233_373_Horner;

  parameter Integer a = 20; // Anzahl Zeilen

  parameter Real b = (5782000)/(a-1); // Druck Schrittweite

  Pressure p[a,1];

  Temperature T[a,1];

  Medium_calc.ThermodynamicState dew_state[a,1];

  Medium_calc.ThermodynamicState bubble_state[a,1];

  Medium_calc.SaturationProperties satp[a,1];

  SpecificHeatCapacity cp_dew[a,1];

  SpecificEnthalpy h_dew[a,1];

  SpecificEnthalpy h_bubble[a,1];

  SpecificEnthalpy dh_l[a,1];

equation

  p[1,1]=1e5;

  satp[1,1] = Medium_calc.setSat_p(p[1,1]);

  dew_state[1,1] = Medium_calc.setDewState(satp[1,1]);

  bubble_state[1,1] = Medium_calc.setBubbleState(satp[1,1]);

  T[1,1] = dew_state[1,1].T;

  cp_dew[1,1] = Medium_calc.specificHeatCapacityCp(dew_state[1,1]);

  h_dew[1,1] = Medium_calc.dewEnthalpy(satp[1,1]);

  h_bubble[1,1] = Medium_calc.bubbleEnthalpy(satp[1,1]);

  dh_l[1,1] = h_dew[1,1] - h_bubble[1,1];

  for i in 2:a loop

  p[i,1] = p[i-1,1]+b;

  satp[i,1] = Medium_calc.setSat_p(p[i,1]);

  dew_state[i,1] = Medium_calc.setDewState(satp[i,1]);

  bubble_state[i,1] = Medium_calc.setBubbleState(satp[i,1]);

  T[i,1] = dew_state[i,1].T;

  cp_dew[i,1] = Medium_calc.specificHeatCapacityCp(dew_state[i,1]);

  h_dew[i,1] = Medium_calc.dewEnthalpy(satp[i,1]);

  h_bubble[i,1] = Medium_calc.bubbleEnthalpy(satp[i,1]);

  dh_l[i,1] = h_dew[i,1] - h_bubble[i,1];

  end for;

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

end Calculate_cp_dhl_array;
