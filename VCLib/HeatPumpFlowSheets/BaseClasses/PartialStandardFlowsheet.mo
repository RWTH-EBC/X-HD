within VCLib.HeatPumpFlowSheets.BaseClasses;
partial model PartialStandardFlowsheet
  extends PartialOpenFlowsheet;

  // Set parameter for regulators
  parameter Modelica.Units.SI.TemperatureDifference dT_superheating_set=5
    "Set superheating temperature difference";
  parameter Modelica.Units.SI.Time t_control_valve=1200
    "Threshold duration when control shall be used";

  Modelica.Blocks.Interfaces.RealOutput opening_out annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={176,-86}), iconTransformation(extent={{-20,-20},{20,20}},
          origin={220,-94})), HideResult=true);
  replaceable
    AixLib.Fluid.Actuators.Valves.ExpansionValves.BaseClasses.PartialExpansionValve
    expansionValve(useInpFil=false, redeclare package Medium = MediumPri)
    annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-17.5,-15.5},{17.5,15.5}},
        rotation=270,
        origin={-91.5,-4.5})));
equation

  connect(TConOut.port_b, expansionValve.port_a) annotation (Line(points={{-78,
          60},{-91.5,60},{-91.5,13}}, color={0,127,255}));
  connect(expansionValve.port_b, evaporator.port_a1) annotation (Line(points={{
          -91.5,-22},{-91.5,-56},{-24,-56},{-24,-52.4}}, color={0,127,255}));
  connect(expansionValve.curManVarVal, opening_out) annotation (Line(points={{
          -75.225,-13.425},{-56,-13.425},{-56,-42},{-128,-42},{-128,-104},{120,
          -104},{120,-86},{176,-86}}, color={0,0,127}));
  annotation (experiment(
      StopTime=100,
      Interval=1,
      Tolerance=0.001,
      __Dymola_Algorithm="Cvode"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(Advanced(
        InlineMethod=0,
        InlineOrder=2,
        InlineFixedStep=0.001)),
      Documentation(info = "<html>
      <p>Heat pump model using simple components.</p>
</html>", revisions = "<html>
<p>xx.xx.2017, Mirko Engelpracht</p>
<p><ul>
<li>implemented</li>
</ul></p>
<p>01.07.2019, Christoph Höges</p>
<p><ul>
<li>Adjusted regulator parameters and external data in order to generate map automatically.</li>
</ul></p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})));
end PartialStandardFlowsheet;
