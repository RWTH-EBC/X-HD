within VCLib.HeatPumpFlowSheets.BaseClasses;
partial model PartialOpenFlowsheet
  extends PartialCompression;

  // Definition of media
  //
  replaceable package MediumSecCon = AixLib.Media.Water
    "Secondary fluid"
    annotation (Dymola_choicesAllMatching=true);
  replaceable package MediumSecEva = Modelica.Media.Air.DryAirNasa
    constrainedby Modelica.Media.Air.DryAirNasa
    "Secondary fluid"
    annotation (Dymola_choicesAllMatching=true);

  /********************************* Parameters *******************************/
   parameter Modelica.Media.Interfaces.Types.Temperature TCon_in=303.15
    "Input from script" annotation (Evaluate=false, Dialog(group="API Input"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_con=0.129463609781144
    "Input from script" annotation (Evaluate=false, Dialog(group="API Input"));
  parameter Modelica.Media.Interfaces.Types.Temperature TEva_in=255.15
    "Input from scrupt" annotation (Evaluate=false, Dialog(group="API Input"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_eva=0.454807797520892
    "Input from script" annotation (Evaluate=false, Dialog(group="API Input"));

  //

  parameter Modelica.Media.Interfaces.Types.Temperature T_4_init=248.08916572672
    "Temperature at state 4 - for init"  annotation (Dialog(group="Init"));

  parameter Modelica.Media.Interfaces.Types.Temperature T_3_init=304.15511144352
    "Temperature at state 3 - for init"  annotation (Evaluate=false, Dialog(group="Init"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_ref_init=0.00587837416279702
    "m_flow_rate - for init" annotation (Dialog(group="Init"));

  // Fixed initials:
  parameter Real n_init=0.3 "For a good init"
                                         annotation (Dialog(group="Init"));
  parameter Real opening_init=0.3 "For a good init"
                                         annotation (Dialog(group="Init"));

  parameter
    VCLib.Media.Refrigerants.Interfaces.PartialHybridTwoPhaseMediumFormula.ThermodynamicState
    state_4=MediumPri.setState_ph(p1_init, MediumPri.specificEnthalpy(
      MediumPri.setState_px(p2_init, 0)));
  parameter
    VCLib.Media.Refrigerants.Interfaces.PartialHybridTwoPhaseMediumFormula.ThermodynamicState
    state_3=MediumPri.setState_px(p2_init, 0);
  parameter Modelica.Media.Interfaces.Types.Temperature TCon_in_init=303.15
    "Input from script" annotation (Dialog(group="Init"));

  parameter Modelica.Media.Interfaces.Types.Temperature TEva_in_init=253.15
    "Input from scrupt" annotation (Dialog(group="Init"));
  // Surface areas heat exchanger
  parameter Modelica.Units.SI.Area A_eva=15
    "Heat transfer area wihtin evaporator";
  parameter Modelica.Units.SI.Area A_con=5
    "Heat transfer area wihtin condenser";

  // Definition of subcomponents
  //
  AixLib.Fluid.Sources.MassFlowSource_T souSecCon(
    redeclare package Medium = MediumSecCon,
    use_m_flow_in=false,
    nPorts=1,
    use_T_in=false,
    m_flow=m_flow_con,
    T=TCon_in) "Source of secondary fluid"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  AixLib.Fluid.Sources.FixedBoundary sinSecCon(
    redeclare package Medium = MediumSecCon,
    p=101325,
    nPorts=1) "Sink of secondary fluid"
    annotation (Placement(transformation(extent={{100,80},{80,100}})));

  AixLib.Fluid.Sources.MassFlowSource_T souSecEva(
    redeclare package Medium = MediumSecEva,
    use_m_flow_in=false,
    nPorts=1,
    m_flow=m_flow_eva,
    use_T_in=false,
    T=TEva_in)
              "Source of secondary fluid"
    annotation (Placement(transformation(extent={{100,-100},{80,-80}})));
  AixLib.Fluid.Sources.FixedBoundary sinSecEva(
    redeclare package Medium = MediumSecEva,
    p=101325,
    nPorts=1) "Sink of secondary fluid"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

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
    dp_start(displayUnit="bar") = -2600000,
    VDis=19e-6,
    piPreMax=20,
    risTim=5,
    pInl0=400000,
    TInl0=273.15) "Model of a simple compressor" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={70,0})));

  AixLib.Fluid.Sensors.TemperatureTwoPort TEvaInlSec(
    allowFlowReversal=true,
    m_flow_nominal=m_flow_eva,
    redeclare package Medium = MediumSecEva,
    T_start=TEva_in)
    "Temperature at evaporator's inlet" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={60,-90})));
  AixLib.Fluid.Sensors.TemperatureTwoPort TEvaOutSec(
    allowFlowReversal=true,
    m_flow_nominal=m_flow_eva,
    tau=1,
    redeclare package Medium = MediumSecEva)
    "Temperature at evaporator's inlet" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-60,-90})));
  AixLib.Fluid.Sensors.TemperatureTwoPort TConInlSec(
    allowFlowReversal=true,
    m_flow_nominal=m_flow_con,
    redeclare package Medium = MediumSecCon,
    T_start=TCon_in)
    "Temperature at evaporator's inlet" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-66,90})));
  AixLib.Fluid.Sensors.TemperatureTwoPort TConOutSec(
    allowFlowReversal=true,
    m_flow_nominal=m_flow_con,
    redeclare package Medium = MediumSecCon)
    "Temperature at evaporator's inlet" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={66,90})));

  Modelica.Units.SI.TemperatureDifference superHeating=TEvaOut.T -
      MediumPri.saturationTemperature(compressor.port_a.p)
    "Superheating of working fluid";
  Modelica.Units.SI.TemperatureDifference subCooling=
      MediumPri.saturationTemperature(compressor.port_b.p) - TConOut.T
    "Superheating of working fluid";
  AixLib.Fluid.Sensors.TemperatureTwoPort TConOut(
    redeclare package Medium = MediumPri,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_ref_init,
    T_start=T_3_init)
    "Temperature at condenser's inlet" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-68,60})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_ref_out annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={178,54}), iconTransformation(extent={{-20,-20},{20,20}}, origin=
           {176,88})),     HideResult=true);
  Modelica.Blocks.Interfaces.RealOutput Q_con_out annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={178,18}), iconTransformation(extent={{-20,-20},{20,20}}, origin=
           {176,52})),     HideResult=true);
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
  Modelica.Blocks.Sources.RealExpression h_5
    annotation (Placement(transformation(extent={{132,8},{152,28}})));
  Modelica.Blocks.Interfaces.RealOutput T_con_out annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={178,90}),  iconTransformation(extent={{-20,-20},{20,20}},
          origin={192,62})), HideResult=true);
  Components.Storage.TwoPhaseSeparator tank(
    redeclare package Medium = MediumPri,
    dp_start=0,
    m_flow_start_a=m_flow_ref_init,
    m_flow_start_b=m_flow_ref_init,
    m_flow_nominal=m_flow_ref_init,
    show_tankProperties=true,
    show_tankPropertiesDetailed=true,
    VTanInn(displayUnit="l") = 0.0025,
    steSta=false,
    pTan0=p2_init,
    hTan0=state_3.h) "Model of an ideal two-phase seperator" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,60})));
  replaceable AixLib.Fluid.Interfaces.PartialFourPort condenser(redeclare
      package Medium1 = MediumPri, redeclare package Medium2 = MediumSecCon)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{22,94},{-20,52}})));
  replaceable AixLib.Fluid.Interfaces.PartialFourPort evaporator(redeclare
      package Medium1 = MediumPri, redeclare package Medium2 = MediumSecEva)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-24,-86},
            {18,-44}})));
equation

  // Connection of submodels
  //

  connect(souSecEva.ports[1], TEvaInlSec.port_a)
    annotation (Line(points={{80,-90},{70,-90}}, color={0,127,255}));
  connect(sinSecEva.ports[1], TEvaOutSec.port_b)
    annotation (Line(points={{-80,-90},{-70,-90}}, color={0,127,255}));
  connect(TConInlSec.port_a, souSecCon.ports[1])
    annotation (Line(points={{-76,90},{-80,90}}, color={0,127,255}));
  connect(TConOutSec.port_b, sinSecCon.ports[1])
    annotation (Line(points={{76,90},{80,90}}, color={0,127,255}));
  connect(h_2.y, m_flow_ref_out) annotation (Line(points={{147,56},{162,56},{
          162,54},{178,54}}, color={0,0,127}));
  connect(h_3.y, P_el_out)
    annotation (Line(points={{151,-20},{178,-20}},
                                                 color={0,0,127}));
  connect(h_5.y, Q_con_out)
    annotation (Line(points={{153,18},{178,18}}, color={0,0,127}));
  connect(TConOutSec.T, T_con_out)
    annotation (Line(points={{66,101},{66,122},{122,122},{122,90},{178,90}},
                                                           color={0,0,127}));
  connect(TConOut.port_a, tank.port_b) annotation (Line(points={{-58,60},{-50,60}},
                              color={0,127,255}));
  connect(TConInlSec.port_b, condenser.port_a2) annotation (Line(points={{-56,90},
          {-44,90},{-44,84},{-20,84},{-20,85.6}}, color={0,127,255}));
  connect(condenser.port_b2, TConOutSec.port_a) annotation (Line(points={{22,85.6},
          {28,85.6},{28,86},{32,86},{32,90},{56,90}}, color={0,127,255}));
  connect(condenser.port_b1, tank.port_a) annotation (Line(points={{-20,60.4},{-26,
          60.4},{-26,60},{-30,60}}, color={0,127,255}));
  connect(evaporator.port_a2, TEvaInlSec.port_b) annotation (Line(points={{18,-77.6},
          {32,-77.6},{32,-90},{50,-90}}, color={0,127,255}));
  connect(evaporator.port_b2, TEvaOutSec.port_a) annotation (Line(points={{-24,-77.6},
          {-34,-77.6},{-34,-90},{-50,-90}}, color={0,127,255}));
  connect(condenser.port_a1, TConInl.port_b) annotation (Line(points={{22,60.4},
          {42,60.4},{42,60},{70,60},{70,54}}, color={0,127,255}));
  connect(evaporator.port_b1, TEvaOut.port_a) annotation (Line(points={{18,-52.4},
          {34,-52.4},{34,-50},{70,-50}}, color={0,127,255}));
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
end PartialOpenFlowsheet;
