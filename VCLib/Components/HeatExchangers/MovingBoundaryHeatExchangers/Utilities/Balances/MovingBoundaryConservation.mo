within VCLib.Components.HeatExchangers.MovingBoundaryHeatExchangers.Utilities.Balances;
model MovingBoundaryConservation
  "Model to check the blanace equations of a moving boundary cell"

  // Definition of inputs describing mass balances of each regime
  //
  input Modelica.Units.SI.Mass mSC
    "Mass of the working fluid of the supercooled regime"
    annotation (Dialog(tab="General", group="Mass balances"));
  input Modelica.Units.SI.Mass mTP
    "Mass of the working fluid of the two-phase regime"
    annotation (Dialog(tab="General", group="Mass balances"));
  input Modelica.Units.SI.Mass mSH
    "Mass of the working fluid of the superheated regime"
    annotation (Dialog(tab="General", group="Mass balances"));
  input Modelica.Units.SI.MassFlowRate dmSCdt
    "Derivative of the working fluid's mass of the supercooled regime wrt. time"
    annotation (Dialog(tab="General", group="Mass balances"));
  input Modelica.Units.SI.MassFlowRate dmTPdt
    "Derivative of the working fluid's mass of the two-phase regime wrt. time"
    annotation (Dialog(tab="General", group="Mass balances"));
  input Modelica.Units.SI.MassFlowRate dmSHdt
    "Derivative of the working fluid's mass of the superheated regime wrt. time"
    annotation (Dialog(tab="General", group="Mass balances"));

  // Definition of inputs describing energy balances of each regime
  //
  input Modelica.Units.SI.InternalEnergy USC
    "Energy of the working fluid of the supercooled regime"
    annotation (Dialog(tab="General", group="Energy balances"));
  input Modelica.Units.SI.InternalEnergy UTP
    "Energy of the working fluid of the two-phase regime"
    annotation (Dialog(tab="General", group="Energy balances"));
  input Modelica.Units.SI.InternalEnergy USH
    "Energy of the working fluid of the superheated regime"
    annotation (Dialog(tab="General", group="Energy balances"));
  input Real dUSCdt(unit="J/s")
    "Derivative of the working fluid's energy of the supercooled regime wrt. time"
    annotation(Dialog(tab="General",group="Energy balances"));
  input Real dUTPdt(unit="J/s")
    "Derivative of the working fluid's energy of the two-phase regime wrt. time"
    annotation(Dialog(tab="General",group="Energy balances"));
  input Real dUSHdt(unit="J/s")
    "Derivative of the working fluid's energy of the superheated regime wrt. time"
    annotation(Dialog(tab="General",group="Energy balances"));

  // Definition of variables describing mass balances
  //
  Modelica.Units.SI.Mass mHX
    "Mass of the working fluid of all three flow regimes";
  Modelica.Units.SI.Mass mHInt
    "Mass of the working fluid of all three flow regimes";
  Modelica.Units.SI.Mass mSCInt
    "Mass of the working fluid of the supercooled regime calc. by integration";
  Modelica.Units.SI.Mass mTPInt
    "Mass of the working fluid of the two-phase regime calc. by integration";
  Modelica.Units.SI.Mass mSHInt
    "Mass of the working fluid of the superheated regime calc. by integration";

  // Definition of variables describing energy balances
  //
  Modelica.Units.SI.InternalEnergy UHX
    "Energy of the working fluid of all three flow regimes";
  Modelica.Units.SI.InternalEnergy UHXInt
    "Energy of the working fluid of all three flow regimes";
  Modelica.Units.SI.InternalEnergy USCInt
    "Energy of the working fluid of the supercooled regime calc. by integration";
  Modelica.Units.SI.InternalEnergy UTPInt
    "Energy of the working fluid of the two-phase regime calc. by integration";
  Modelica.Units.SI.InternalEnergy USHInt
    "Energy of the working fluid of the superheated regime calc. by integration";

  // Definition of variables describing deviations
  //
  Modelica.Units.SI.Mass dmSC
    "Differece of mass of the working fluid of the supercooled regime";
  Modelica.Units.SI.Mass dmTP
    "Differece of mass of the working fluid of the two-phase regime";
  Modelica.Units.SI.Mass dmSH
    "Differece of mass of the working fluid of the superheated regime";
  Modelica.Units.SI.InternalEnergy dUSC
    "Dofference of energy of the working fluid of the supercooled regime";
  Modelica.Units.SI.InternalEnergy dUTP
    "Dofference of energy of the working fluid of the two-phase regime";
  Modelica.Units.SI.InternalEnergy dUSH
    "Dofference of energy of the working fluid of the superheated regime";

initial equation
  mSCInt = mSC
    "Mass of the working fluid of the two-phase regime calc. by integration";
  mTPInt = mTP
    "Mass of the working fluid of the two-phase regime calc. by integration";
  mSHInt = mSH
    "Mass of the working fluid of the superheated regime calc. by integration";
  USCInt = USC
    "Mass of the working fluid of the two-phase regime calc. by integration";
  UTPInt = UTP
    "Mass of the working fluid of the two-phase regime calc. by integration";
  USHInt = USH
    "Mass of the working fluid of the superheated regime calc. by integration";

equation
  // Calculate overall mass and energy of the working fluid
  //
  mHX = mSC + mTP + mSH
    "Mass of the working fluid of all three flow regimes";
  mHInt = mSCInt + mTPInt + mSHInt
    "Mass of the working fluid of all three flow regimes";
  UHX = USC + UTP + USH
    "Energy of the working fluid of all three flow regimes";
  UHXInt = USCInt + UTPInt + USHInt
    "Energy of the working fluid of all three flow regimes";

  // Calculate mass and energy of the working fluid by integration
  //
  der(mSCInt) = dmSCdt
    "Mass of the working fluid of the two-phase regime calc. by integration";
  der(mTPInt) = dmTPdt
    "Mass of the working fluid of the two-phase regime calc. by integration";
  der(mSHInt) = dmSHdt
    "Mass of the working fluid of the superheated regime calc. by integration";
  der(USCInt) = dUSCdt
    "Mass of the working fluid of the two-phase regime calc. by integration";
  der(UTPInt) = dUTPdt
    "Mass of the working fluid of the two-phase regime calc. by integration";
  der(USHInt) = dUSHdt
    "Mass of the working fluid of the superheated regime calc. by integration";

  // Calculate differences
  //
  dmSC = mSC - mSCInt
    "Differece of mass of the working fluid of the supercooled regime";
  dmTP = mTP - mTPInt
    "Differece of mass of the working fluid of the two-phase regime";
  dmSH = mSH - mSHInt
    "Differece of mass of the working fluid of the superheated regime";
  dUSC = USC - USCInt
    "Dofference of energy of the working fluid of the supercooled regime";
  dUTP = UTP - UTPInt
    "Dofference of energy of the working fluid of the two-phase regime";
  dUSH = USH - USHInt
    "Dofference of energy of the working fluid of the superheated regime";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={135,135,135},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere,
          extent={{-100,-100},{100,100}},
          radius=25),
        Text(
          extent={{-80,80},{80,20}},
          lineColor={0,0,0},
          textString="d(m)/dt = ...",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-80,-20},{80,-80}},
          lineColor={0,0,0},
          textString="d(U)/dt = ...",
          textStyle={TextStyle.Bold})}),                         Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MovingBoundaryConservation;
