within VCLib.Media.Refrigerants.Interfaces.PartialHybridTwoPhaseMediumFormula;
function dBubbleEntropy_dPressure
  "Calculates bubble point entropy derivative"
  input SaturationProperties sat "Saturation properties";
  output Real dsldp
    "Bubble point entropy derivative at constant Temperature";

protected
  ThermodynamicState state = setBubbleState(sat);
  Real dsdT = 0;
  Real dpdT = 0;
  Real dsTd = 0;
  Real dpTd = 0;
  Real dsTp = 0;
  Real dspT = 0;
  Real dTp = 0;

algorithm
  dsdT := specificEntropy_derd_T(state);
  dsTd := specificEntropy_derT_d(state);
  dsTp := dsTd - dsdT*pressure_derT_d(state)/pressure_derd_T(state);
  dspT := dsdT/pressure_derd_T(state);
  dTp := saturationTemperature_derp(sat.psat);

  dsldp := dspT + dsTp * dTp;

  annotation(Inline=false,
             LateInline=true);
end dBubbleEntropy_dPressure;
