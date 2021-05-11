within VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Utilities.Records;
record DataBaseDefinition
  "Base data definition for geometrical quantities of reciprocating compressor"

  constant String name
  "Short description of the record";
  constant Modelica.Units.SI.Diameter D_pis "Diameter of piston";
  constant Modelica.Units.SI.Length H "Hub";
  constant Modelica.Units.SI.Area A_env "Area of piston to enviroment";
  constant Real alpha_env "Heat flow coefficient, pistion-->ambient [W/m2K]";
  constant Real pistonRod_ratio "Ratio of rod and crankshaft";
  constant Modelica.Units.SI.Area Aeff_in "Effective area valve in";
  constant Modelica.Units.SI.Area Aeff_out "Effective area valve out";
  constant Real c_dead "Relative dead Volume of the piston";
  constant Modelica.Units.SI.Pressure p_rub "Rubbing pressure";
  constant Modelica.Units.SI.ThermalConductance G_wall_env
    "Thermal conductance between wall and ambient";

   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DataBaseDefinition;
