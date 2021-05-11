within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Properties;
record ElementProperties
extends Modelica.Icons.Record;
  //Model with element properties
 //Inlet, outlet
  Modelica.Units.SI.AbsolutePressure p_in "pressure at inlet";
  Modelica.Units.SI.MassFlowRate m_in "mass flow rate at inlet";
  Modelica.Units.SI.AbsolutePressure p_out "pressure at outlet";
  Modelica.Units.SI.MassFlowRate m_out "mass flow rate at outlet";
 //geometry
  Modelica.Units.SI.Area A_square "Querschnittsfläche";
  Modelica.Units.SI.Area A_heat "Mantelfläche";
  Modelica.Units.SI.Volume V "Volume";
  Modelica.Units.SI.Length L "Length";
  Modelica.Units.SI.Length B "";
  Modelica.Units.SI.Length H "Height";
  Modelica.Units.SI.Diameter D "hyraulic diameter";
//thermodynamic
  Modelica.Units.SI.Temperature T "temperature of the fluid";
  Modelica.Units.SI.AbsolutePressure p "pressure of the fluid at pipe inlet";
  Modelica.Units.SI.SpecificEnthalpy h
    "specific enthalpy of the fluid at pipe inlet";
  Modelica.Units.SI.ThermalConductivity lambda
    "thermal conductivity of the fluid";
  Modelica.Units.SI.Density rho "density of the fluid";
  Modelica.Units.SI.DynamicViscosity eta "dynamic viscosity of the fluid";
  Modelica.Units.SI.PrandtlNumber Pr "Prandtl number of the fluid";
 Integer phase;
  Modelica.Units.SI.PrandtlNumber Pr0
    "Prandtl number if complete fluid was liquid";
  Modelica.Units.SI.Density dl "density of liquid phase";
  Modelica.Units.SI.Density dv "density of fluid phase";
  Modelica.Units.SI.ThermalConductivity lambda0
    "thermal conductivity of the fluid";
  Modelica.Units.SI.DynamicViscosity eta0
    "dynamic viscosity if if complete fluid was liquid";
 Real x_void "void fraction";
   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ElementProperties;
