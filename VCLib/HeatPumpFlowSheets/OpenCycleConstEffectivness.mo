within VCLib.HeatPumpFlowSheets;
model OpenCycleConstEffectivness
  extends BaseClasses.PartialOpenFlowsheet(
    n=0.8,
    redeclare AixLib.Fluid.HeatExchangers.ConstantEffectiveness evaporator(
      m1_flow_nominal=m_flow_ref_init,
      m2_flow_nominal=m_flow_eva,
      dp1_nominal=0,
      dp2_nominal=0,
      eps=1),
    redeclare AixLib.Fluid.HeatExchangers.ConstantEffectiveness condenser(
      m1_flow_nominal=m_flow_ref_init,
      m2_flow_nominal=m_flow_con,
      dp1_nominal=0,
      dp2_nominal=0,
      eps=1),                              TAmb=TEva_in);
  parameter Modelica.Units.SI.Time t_control_valve=50
    "Threshold duration when control shall be used";

  AixLib.Fluid.Sources.FixedBoundary sinExpValve(
    redeclare package Medium = MediumPri,
    use_p=true,
    p=p2_init,
    use_T=false,
    h=state_4.h,
    nPorts=1) "Sink for ref before exp-valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,34})));

  AixLib.Fluid.Sources.FixedBoundary souExpValve(
    redeclare package Medium = MediumPri,
    use_p=true,
    p=p1_init,
    use_T=false,
    h=state_4.h,
    nPorts=1) "Source for ref before exp-valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-30})));

  Modelica.Blocks.Sources.Ramp     ramp(
    height=(n - n_init)*compressor.rotSpeMax,
    duration=200,
    offset=n_init*compressor.rotSpeMax,
    startTime=t_control_valve)
    annotation (Placement(transformation(extent={{-2,-22},{18,-2}})));
equation

  connect(sinExpValve.ports[1], TConOut.port_b)
    annotation (Line(points={{-80,44},{-80,60},{-78,60}}, color={0,127,255}));
  connect(evaporator.port_a1, souExpValve.ports[1]) annotation (Line(points={{-24,
          -52.4},{-78,-52.4},{-78,-40},{-80,-40}}, color={0,127,255}));
  connect(ramp.y, compressor.manVarCom)
    annotation (Line(points={{19,-12},{50,-12}}, color={0,0,127}));
  annotation (experiment(
      StopTime=500,
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
end OpenCycleConstEffectivness;
