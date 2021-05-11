within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Properties;
record WallMaterial
  //parameter Modelica.SIunits.Length s "Thickness of wall";
  parameter Modelica.Units.SI.Density rho "Density of wall";
  parameter Modelica.Units.SI.ThermalConductivity lambda
    "Thermal Conductivity of wall";
  parameter Modelica.Units.SI.SpecificHeatCapacity cP
    "Specific heat capacity of wall";
  parameter Modelica.Units.SI.Emissivity eps=0.95
    "Emissivity of inner wall surface";
//  parameter Integer n = 1 "number of discretized eleements";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WallMaterial;
