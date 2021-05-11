within VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Utilities;
function setState_dh
  "Return thermodynamic state of refrigerant as function of p and h"
extends Modelica.Icons.Function;
  input Modelica.Units.SI.Density d;
  input Modelica.Units.SI.SpecificEnthalpy h;
  output
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.ThermodynamicState
    state;
  output Modelica.Units.SI.SpecificEnthalpy h_del;
  output Integer i;

protected
  Modelica.Units.SI.Temperature T_start=373;
  Modelica.Units.SI.Temperature T_int;
  VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.SpecificHeatCapacity
    cp;                          //=Medium.specificHeatCapacityCp(Medium.ThermodynamicState(h=h,d=d,T=T_start, phase=0, p=Medium.pressure_dT(d=d, T=T_int)));
  Modelica.Units.SI.SpecificEnthalpy h_delta=1000e3;
  //Integer i = 1;
algorithm
  T_int :=T_start;
  cp :=
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.specificHeatCapacityCp(
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.ThermodynamicState(
              h=h,
              d=d,
              T=T_start,
              phase=0,
              p=60));
           //Medium.pressure_dT(d=d, T=T_int)));

  while abs(h_delta) > 1e2 and i<20 loop
    h_delta :=h -
      VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.specificEnthalpy_dT(
      d=d, T=T_int);
    T_int := T_int + h_delta/cp;
    i:=i + 1;
  end while;
  h_del :=h_delta;
  state :=
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.ThermodynamicState(
              d=d,
              p=
      VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.pressure_dT(
      d=d, T=T_int),
              T=T_int,
              h=h,
              phase=0);
end setState_dh;
