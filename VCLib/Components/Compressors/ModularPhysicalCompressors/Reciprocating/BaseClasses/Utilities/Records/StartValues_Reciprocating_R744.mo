within VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Utilities.Records;
record StartValues_Reciprocating_R744
  //Volumina
  Modelica.Units.SI.Volume V_gas(min=0.001);
  Modelica.Units.SI.Volume V_0(start=0);
  //State variables
  Modelica.Units.SI.Density d_gas(start=5);
  Modelica.Units.SI.Temperature T_gas(start=300);
  Modelica.Units.SI.Pressure p_gas(start=10e5) "Pressure inside the chamber";
  Modelica.Units.SI.SpecificInternalEnergy u_gas(start=50e3);
  Modelica.Units.SI.SpecificEnthalpy h_gas(start=0);
  VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.ThermodynamicState
    state_dh;
  VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.ThermodynamicState
    state_in;
  //Mass
  Modelica.Units.SI.Mass m_gas(start=5e-4);
  Modelica.Units.SI.Mass m_in(start=small);
  Modelica.Units.SI.Mass m_out;
  Modelica.Units.SI.MassFlowRate m_in_avg;
  Modelica.Units.SI.MassFlowRate m_out_avg;
  //Work
  Modelica.Units.SI.Work W_rev(start=0) "reversible work";
  Modelica.Units.SI.Work W_irr(start=0) "irreversible work";
  //Streams
  Modelica.Units.SI.EnergyFlowRate U_flow_in(start=0);
  Modelica.Units.SI.EnergyFlowRate U_flow_out(start=0);
  Modelica.Units.SI.SpecificEnthalpy h_in;
  //Iteration variables
  Modelica.Units.SI.SpecificEnthalpy h_delta;
  Integer n;
  //Heat Transfer Coefficients
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha(start=0.0001);
  Real c1;
  Modelica.Units.SI.Velocity v_pis_avg "average velocity of piston";
  constant Real small =  Modelica.Constants.small;
  //Isentropic efficiency
  Modelica.Units.SI.SpecificEntropy s_out_is
    "specific isentropic entropy for outgoing fluid";
  Modelica.Units.SI.SpecificEnthalpy h_out_is
    "specific insentropic enthaly for outgoing fluid";
  Modelica.Units.SI.Energy U_in;
  Modelica.Units.SI.Energy U_out;
  Real eta_is "isentropic efficiency";
  //Power
  Modelica.Units.SI.Power P "Power";
  Integer modi;
  Integer i "Counter";
  //volumetric efficiency
  Real lambda "volumetric efficiency";
  Modelica.Units.SI.Area Aeff_in_cor
    "Effective Area of inlet valve calculated by correlation";
  Modelica.Units.SI.Area Aeff_out_cor(max=5e-5)
    "Effective Area of outlet valve calculated by correlation";
  Real G_dot_out(min=small) "Mass flow density at valve outlet";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StartValues_Reciprocating_R744;
