within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Calculate_cp_dhl_time

  extends Modelica.Icons.Example;
  package Medium_calc =
      VCLib.Media.Refrigerants.R744.R744_I0_P10_100_T233_373_Horner;

  Pressure p;

  Temperature T;

  Medium_calc.ThermodynamicState dew_state;

  Medium_calc.ThermodynamicState bubble_state;

  Medium_calc.SaturationProperties satp;

  SpecificHeatCapacity cp_dew;

  SpecificEnthalpy h_dew;

  SpecificEnthalpy h_bubble;

  SpecificEnthalpy dh_l;

equation

  //p=1e5 + time*(5782000-1e5)/30; // R32

  p=10e5 + time*(7100000-10e5)/30; // R744

  //p=1e5 + time*(3800000-1e5)/30; // R134a

  //p=3e5 + time*(4901200-3e5)/30; // R410A

  //p=3e5 + time*(3100000-3e5)/30; // R290

  satp = Medium_calc.setSat_p(p);

  dew_state = Medium_calc.setDewState(satp);

  bubble_state = Medium_calc.setBubbleState(satp);

  T = dew_state.T;

  cp_dew = Medium_calc.specificHeatCapacityCp(dew_state);

  h_dew = Medium_calc.dewEnthalpy(satp);

  h_bubble = Medium_calc.bubbleEnthalpy(satp);

  dh_l = h_dew - h_bubble;

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
      StopTime=30,
      Interval=1,
      __Dymola_Algorithm=""));
end Calculate_cp_dhl_time;
