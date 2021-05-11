within VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Utilities;
model test_State_dh

  parameter Modelica.Units.SI.Density d_min=2;
  parameter Modelica.Units.SI.Density d_max=20;
  parameter Modelica.Units.SI.SpecificEnthalpy h_min=550e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_max=640e3;
//parameter Modelica.SIunits.Density d = 4.6132;
//parameter Modelica.SIunits.SpecificEnthalpy h=542e3;
  Modelica.Units.SI.SpecificEnthalpy h_delta;
  Modelica.Units.SI.Density d(start=d_min);
  Modelica.Units.SI.SpecificEnthalpy h(start=h_min);
Integer n;
Real relError_h;

parameter Boolean wayOfCalc=false;
Real convd(start = (d_max-d_min)/80)
    "Conversion factor in K/s for temperature to satisfy unit check";
Real convh(start = (h_max-h_min)/(80*80))
    "Conversion factor in Pa/s for pressure to satisfy unit check";

protected
  Modelica.Units.SI.Time convChange(start=0)
    "Time to reset calculation of actual temperature or pressure";
  Modelica.Units.SI.Time convChangeTmp(start=0)
    "Temporary time to reset calculation of actual temperature or pressure";

algorithm
  if wayOfCalc then
    convd := (d_max - d_min)/80;
    convh := (h_max - h_min)/(80*80);
    convChange := if noEvent(delay(d,1)) >=
      d_max-convd then time else convChangeTmp;
  else
    convd := (d_max - d_min)/(80*80);
    convh := (h_max - h_min)/80;
    convChange := if noEvent(delay(h,1)) >=
      h_max-convh then time else convChangeTmp;
  end if;

equation
convChangeTmp = convChange;

if wayOfCalc then
    d = min((d_min + convd*(time - convChange)), d_max);
    h = min((h_min + convh*time), h_max);
  else
    d = min((d_min + convd*time), d_max);
    h = min((h_min + convh*(time - convChange)), h_max);
  end if;

  (state_dh,h_delta,n) =
    ModularPhysicalCompressors.ReciprocatingCompressor.Utilities.setState_dh(d=
    d, h=h);
  state_dT =
    ModularPhysicalCompressors.ReciprocatingCompressor.Medium.setState_dT(d=d,
    T=state_dh.T);
  relError_h = h_delta/h *100;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_State_dh;
