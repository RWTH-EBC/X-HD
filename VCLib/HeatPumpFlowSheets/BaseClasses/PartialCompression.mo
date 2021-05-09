within VCLib.HeatPumpFlowSheets.BaseClasses;
partial model PartialCompression
  extends Modelica.Icons.Example;

  // Definition of media
  //
  replaceable package MediumPri =
      VCLib.Media.Refrigerants.R290.R290_IIR_P05_30_T263_343_Horner
    constrainedby
    VCLib.Media.Refrigerants.Interfaces.PartialHybridTwoPhaseMediumFormula
    "Primary fluid"
    annotation (choicesAllMatching=true);

  /********************************* Parameters *******************************/

  // Timing parameters when regulator should start (used for switch s. diagram)
  parameter Modelica.Units.SI.Time t_control_comp=50
    "Threshold duration when control shall be used";                                                   // t_control_valve/2

  // Definition of subcomponents
  //
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure p2_init(displayUnit="Pa")=
       1938752.05861882 "Output of python map - tbd set by new script"
                                                   annotation (Dialog(group="Init"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure p1_init=329408.36136944
    "Output of python map - tbd set by new script" annotation (Dialog(group="Init"));

  parameter Real n=0.3 "Input from script"
                                         annotation (Evaluate=false, Dialog(group="API Input"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_ref_init=0.00587837416279702
    "m_flow_rate - for init" annotation (Dialog(group="Init"));
  parameter Modelica.Media.Interfaces.Types.Temperature T_2_init=383.8780485312
    "Temperature at state 2 - for init"  annotation (Dialog(group="Init"));
   parameter Modelica.Media.Interfaces.Types.Temperature T_1_init=253.14992284826
    "Temperature at state 1 - for init"  annotation (Dialog(group="Init"));
  VCLib.Components.Compressors.SimpleCompressors.RotaryCompressors.RotaryCompressor
    compressor(
    redeclare package Medium = MediumPri,
    rotSpeMax=125,
    useInpFil=true,
    redeclare model EngineEfficiency =
        VCLib.Components.Compressors.Utilities.EngineEfficiency.SpecifiedEfficiencies.Generic_VarRef_VarDisVol_RotaryScroll,
    redeclare model VolumetricEfficiency =
        VCLib.Components.Compressors.Utilities.VolumetricEfficiency.SpecifiedEfficiencies.Generic_VarRef_VarDisVol_RotaryScroll,
    redeclare model IsentropicEfficiency =
        VCLib.Components.Compressors.Utilities.IsentropicEfficiency.SpecifiedEfficiencies.Generic_VarRef_VarDisVol_RotaryScroll,
    allowFlowReversal=false,
    m_flow_nominal=0.04,
    show_staEff=true,
    show_qua=true,
    dp_start(displayUnit="bar") = p1_init - p2_init,
    VDis=19e-6,
    piPreMax=20,
    risTim=5,
    rotSpe0=n*compressor.rotSpeMax,
    pInl0=p1_init,
    TInl0=T_1_init) "Model of a simple compressor" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={70,0})));

  AixLib.Fluid.Sensors.TemperatureTwoPort TEvaOut(
    redeclare package Medium = MediumPri,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_ref_init,
    tau=1,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    T_start=T_1_init)
    "Temperature at evaporator's outlet" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-40})));
  AixLib.Fluid.Sensors.TemperatureTwoPort TConInl(
    redeclare package Medium = MediumPri,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_ref_init,
    T_start=T_2_init)
    "Temperature at condenser's inlet" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,44})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    fixedTemperature(T=TAmb)
    annotation (Placement(transformation(extent={{126,-10},{106,10}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow_ref_out annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={178,54}), iconTransformation(extent={{-20,-20},{20,20}}, origin=
           {176,88})),     HideResult=true);
  Modelica.Blocks.Interfaces.RealOutput P_el_out annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={178,-20}), iconTransformation(extent={{-20,-20},{20,20}},
          origin={176,14})),
                           HideResult=true);
  Modelica.Blocks.Interfaces.RealOutput T_max_out annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={176,-58})), HideResult=true);
  Modelica.Blocks.Sources.RealExpression h_2(y=compressor.port_a.m_flow)
    annotation (Placement(transformation(extent={{126,46},{146,66}})));
  Modelica.Blocks.Sources.RealExpression h_3(y=compressor.comPro.PEle)
    annotation (Placement(transformation(extent={{130,-30},{150,-10}})));
  parameter Modelica.Units.SI.Temperature TAmb
    "Ambient temperature of compressor";
equation

  // Connection of submodels
  //
  connect(compressor.port_a, TEvaOut.port_b)
    annotation (Line(points={{70,-20},{70,-30}}, color={0,127,255}));
  connect(TConInl.port_a, compressor.port_b)
    annotation (Line(points={{70,34},{70,20}}, color={0,127,255}));

  connect(compressor.heatPort, fixedTemperature.port)
    annotation (Line(points={{90,0},{106,0}}, color={191,0,0}));
  connect(TConInl.T, T_max_out) annotation (Line(points={{59,44},{40,44},{40,-58},{176,
          -58}},                         color={0,0,127}));
  connect(h_2.y, m_flow_ref_out) annotation (Line(points={{147,56},{162,56},{
          162,54},{178,54}}, color={0,0,127}));
  connect(h_3.y, P_el_out)
    annotation (Line(points={{151,-20},{178,-20}},
                                                 color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-100,-100},{160,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{160,100}})));
end PartialCompression;
