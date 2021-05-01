within Configurations.General;
model Calc_HP_HeatingPower
  parameter Real T_NA = 261.15 "K";
  parameter Real T_Biv_para = 271.15 "K"; //Bivalence temperature used for parameterization of heat pump characteristic (here: based on DIN or VDI: bivalence temperature is -2 °C)
  parameter Real Q_flow_NA_HP_para = 0.46*Q_HL "W"; //Assumption based on DIN 4701
  parameter Real Q_NA_Building = 9710.1 "W"; //without DHW
  parameter Real Q_flow_HP_Biv_para = 8248.21 "W"; //Heat pump heating load at T_Biv_para; here, the guidelines provided by German standards DIN 15450/VDI4645 are used
  parameter Real gradient_HP = (Q_flow_HP_Biv_para-0.46*Q_NA_Building)/(T_Biv_para-T_NA); //gradient of the heat pump performance characteristic in dotQ/T diagram
  parameter Real Q_flow_HP_Biv = 8248.21 "W";
  parameter Real Q_flow_HP_max = 20000 "W";
  Real Q_flow_HP;
  Real Q_flow_NA_HP;

  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient temperature in K"
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow_HP_rel
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));

equation
  Q_flow_NA_HP = Q_flow_NA_HP_para+(Q_flow_HP_Biv-Q_flow_HP_Biv_para);
  //The heat pump heating load at standard outside temperature is calculated based on assumptions of DIN 4701
  //Assumption: Heat pump heating load at standard outside temperatur is 0.46* Building heat load

  Q_flow_HP = gradient_HP*(T_amb - T_NA) + Q_flow_NA_HP;
  //for different Heat pump sizes, it is assumed that the gradient of the heat pump characteristic stays the same
  Q_flow_HP_rel =Q_flow_HP/Q_flow_HP_max;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Calc_HP_HeatingPower;
