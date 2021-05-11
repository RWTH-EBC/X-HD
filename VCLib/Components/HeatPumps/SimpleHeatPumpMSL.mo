within VCLib.Components.HeatPumps;
model SimpleHeatPumpMSL
  "Model of a simple heat pump using MSL heat exchangers"
  extends Modelica.Icons.Example;

  // Definition of media
  //
  replaceable package MediumPri =
    ExternalMedia.Examples.R410aCoolProp
    "Primary fluid"
    annotation (Dymola_choicesAllMatching=true);
  replaceable package MediumSecCon = AixLib.Media.Water
    "Secondary fluid"
    annotation (Dymola_choicesAllMatching=true);
  replaceable package MediumSecEva = AixLib.Media.Water
    "Secondary fluid"
    annotation (Dymola_choicesAllMatching=true);
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  // Further media models
  //
  // ExternalMedia.Examples.R410aCoolProp
  // WorkingVersion.Media.Refrigerants.R410a.R410a_IIR_P1_48_T233_473_Horner

  // Definition of subcomponents
  //
  Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX condenser(
    c_wall=500,
    use_T_start=true,
    k_wall=100,
    crossArea_1=4.5e-4,
    crossArea_2=4.5e-4,
    perimeter_1=0.075,
    perimeter_2=0.075,
    redeclare package Medium_1 = MediumPri,
    redeclare package Medium_2 = MediumSecCon,
    modelStructure_1=Modelica.Fluid.Types.ModelStructure.av_b,
    modelStructure_2=Modelica.Fluid.Types.ModelStructure.a_vb,
    length=20,
    area_h_1=0.075*20,
    area_h_2=0.075*20,
    redeclare model HeatTransfer_1 =
      Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.LocalPipeFlowHeatTransfer
        (alpha0=6000),
    redeclare model HeatTransfer_2 =
      Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer (
         alpha0=2000),
    rho_wall=8000,
    dT(displayUnit="K") = 10,
    m_flow_start_1=0.02,
    m_flow_start_2=1,
    s_wall=0.001,
    redeclare model FlowModel_1 =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
        use_Ib_flows=false,
        show_Res=true,
        dp_nominal(displayUnit="Pa") = 10,
        m_flow_nominal=0.05),
    redeclare model FlowModel_2 =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
        use_Ib_flows=false,
        show_Res=true,
        dp_nominal(displayUnit="Pa") = 10,
        m_flow_nominal=1.5),
    nNodes=1,
    Twall_start(displayUnit="degC") = 274.65,
    p_a_start1=3000000,
    p_b_start1=3000000,
    T_start_1=343.15,
    p_a_start2=101325,
    p_b_start2=101325,
    T_start_2=303.15) "Model of a heat exchanger"
    annotation (Placement(transformation(extent={{20,80},{-20,40}})));

  AixLib.Fluid.Sources.MassFlowSource_T souSecCon(
    redeclare package Medium = MediumSecCon,
    m_flow=1,
    nPorts=1,
    T=303.15) "Source of secondary fluid"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  AixLib.Fluid.Sources.FixedBoundary sinSecCon(
    redeclare package Medium = MediumSecCon,
    nPorts=1,
    p=101325) "Sink of secondary fluid"
    annotation (Placement(transformation(extent={{100,80},{80,100}})));

  Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX evaporator(
    c_wall=500,
    use_T_start=true,
    k_wall=100,
    crossArea_1=4.5e-4,
    crossArea_2=4.5e-4,
    perimeter_1=0.075,
    perimeter_2=0.075,
    redeclare package Medium_1 = MediumPri,
    redeclare package Medium_2 = MediumSecEva,
    modelStructure_1=Modelica.Fluid.Types.ModelStructure.av_b,
    modelStructure_2=Modelica.Fluid.Types.ModelStructure.a_vb,
    length=20,
    area_h_1=0.075*20,
    area_h_2=0.075*20,
    redeclare model HeatTransfer_1 =
      Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.LocalPipeFlowHeatTransfer
        (alpha0=6000),
    redeclare model HeatTransfer_2 =
      Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer (
         alpha0=2000),
    rho_wall=8000,
    dT(displayUnit="K") = 10,
    m_flow_start_1=0.02,
    m_flow_start_2=1,
    s_wall=0.001,
    redeclare model FlowModel_1 =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
        use_Ib_flows=false,
        show_Res=true,
        dp_nominal(displayUnit="Pa") = 10,
        m_flow_nominal=0.05),
    redeclare model FlowModel_2 =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow (
        use_Ib_flows=false,
        show_Res=true,
        dp_nominal(displayUnit="Pa") = 10,
        m_flow_nominal=1.5),
    nNodes=1,
    Twall_start(displayUnit="degC") = 323.15,
    p_a_start1=500000,
    p_b_start1=500000,
    T_start_1=253.15,
    p_a_start2=101325,
    p_b_start2=101325,
    T_start_2=275.15) "Model of a heat exchanger"
    annotation (Placement(transformation(extent={{-20,-80},{20,-40}})));

  AixLib.Fluid.Sources.MassFlowSource_T souSecEva(
    redeclare package Medium = MediumSecEva,
    m_flow=1,
    nPorts=1,
    T=275.15) "Source of secondary fluid"
    annotation (Placement(transformation(extent={{100,-100},{80,-80}})));
  AixLib.Fluid.Sources.FixedBoundary sinSecEva(
    redeclare package Medium = MediumSecEva,
    nPorts=1,
    p=101325) "Sink of secondary fluid"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  ExpansionValves.SimpleExpansionValves.IsenthalpicExpansionValve
    expansionValve(
    useInpFil=true,
    calcProc=VCLib.Components.ExpansionValves.Utilities.Types.CalcProc.flowCoefficient,
    mFlowNom=0.04,
    redeclare model FlowCoefficient =
      ExpansionValves.Utilities.FlowCoefficient.SpecifiedFlowCoefficients.Poly_R22R407CR410A_EEV_15_22,
    redeclare package Medium = MediumPri,
    allowFlowReversal=false,
    dp_start=25,
    m_flow_nominal=0.04,
    show_staOut=true,
    risTim=20,
    dpNom=2500000) "Model of an simple expansion valve" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-70,0})));

  Compressors.SimpleCompressors.RotaryCompressors.RotaryCompressor compressor(
    redeclare package Medium = MediumPri,
    VDis=13.2e-6,
    rotSpeMax=125,
    piPreMax=10,
    useInpFil=true,
    risTim=25,
    redeclare model EngineEfficiency =
      Compressors.Utilities.EngineEfficiency.SpecifiedEfficiencies.Generic_VarRef_VarDisVol_RotaryScroll,
    redeclare model VolumetricEfficiency =
      Compressors.Utilities.VolumetricEfficiency.SpecifiedEfficiencies.Generic_VarRef_VarDisVol_RotaryScroll,
    redeclare model IsentropicEfficiency =
      Compressors.Utilities.IsentropicEfficiency.SpecifiedEfficiencies.Generic_VarRef_VarDisVol_RotaryScroll,
    allowFlowReversal=false,
    m_flow_nominal=0.04,
    show_staEff=true,
    show_qua=true,
    dp_start(displayUnit="bar") = -2600000,
    pInl0=400000,
    TInl0=273.15) "Model of a simple compressor" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={70,0})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambientTemperature(T=275.15)
    "Prescribed ambient temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,0})));

  AixLib.Fluid.Sensors.TemperatureTwoPort TEvaInl(
    redeclare package Medium = MediumPri,
    allowFlowReversal=true,
    m_flow_nominal=0.04,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Temperature at evaporator's inlet" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-40})));
  AixLib.Fluid.Sensors.TemperatureTwoPort TEvaOut(
    redeclare package Medium = MediumPri,
    allowFlowReversal=true,
    m_flow_nominal=0.04,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Temperature at evaporator's outlet" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-40})));
  AixLib.Fluid.Sensors.TemperatureTwoPort TConInl(
    redeclare package Medium = MediumPri,
    allowFlowReversal=true,
    m_flow_nominal=0.04,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Temperature at condenser's inlet" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,40})));
  AixLib.Fluid.Sensors.TemperatureTwoPort TConOut(
    redeclare package Medium = MediumPri,
    allowFlowReversal=true,
    m_flow_nominal=0.04,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Temperature at condenser's outlet" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,40})));
  AixLib.Fluid.Sensors.EnthalpyFlowRate HConInl(
    redeclare package Medium = MediumSecCon,
    allowFlowReversal=false,
    m_flow_nominal=1,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Enthalpy flow rate at condenser's inlet at secondary side"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  AixLib.Fluid.Sensors.EnthalpyFlowRate HConOut(
    redeclare package Medium = MediumSecCon,
    allowFlowReversal=false,
    m_flow_nominal=1,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Enthalpy flow rate at condenser's outlet at secondary side"
    annotation (Placement(transformation(extent={{40,76},{60,96}})));

  // Definition of further variables
  //
  Modelica.Units.SI.HeatFlowRate heatCapacity=HConOut.H_flow - HConInl.H_flow
    "Heat capacity delivered by heat pump";
  Modelica.Units.SI.TemperatureDifference superHeating=TEvaOut.T -
      MediumPri.saturationTemperature(preEvaInl.p)
    "Superheating of working fluid";
  Real COP = heatCapacity/compressor.comPro.PEle
    "Current COP";

  // Definition of controllers
  //
  AixLib.Controls.Continuous.LimPID compressorController(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.1,
    yMax=125,
    yMin=10) "Controller of the compressor"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));
  AixLib.Controls.Continuous.LimPID valveController(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.1,
    yMax=1,
    yMin=0.1) "Controller of the expansion valve"
    annotation (Placement(transformation(extent={{-10,0},{-30,20}})));
  Modelica.Blocks.Sources.RealExpression currentSuperheating(y=superHeating)
    "Current superheating" annotation (Placement(transformation(
        extent={{-6,-10},{6,10}},
        rotation=90,
        origin={-20,-14})));
  Modelica.Blocks.Sources.RealExpression setHeatCapacity(y=60)
    "Set point of heat capacity" annotation (Placement(transformation(
        extent={{-6,-10},{6,10}},
        rotation=0,
        origin={-4,-10})));
  Modelica.Blocks.Sources.RealExpression setSuperheating(y=1)
    "Set point of superheating" annotation (Placement(transformation(
        extent={{-6,10},{6,-10}},
        rotation=180,
        origin={4,10})));
  Modelica.Blocks.Sources.RealExpression currentHeatCapacity(y=heatCapacity)
    "Current heat capacity" annotation (Placement(transformation(
        extent={{-6,10},{6,-10}},
        rotation=90,
        origin={20,-34})));

  AixLib.Fluid.Sensors.Pressure preEvaInl(redeclare package Medium = MediumPri)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  // Connection of submodels
  //
  connect(souSecEva.ports[1], evaporator.port_a2) annotation (Line(points={{80,-90},
          {30,-90},{30,-69.2},{22,-69.2}}, color={0,127,255}));
  connect(evaporator.port_b2, sinSecEva.ports[1]) annotation (Line(points={{-22,
          -50.8},{-32,-50.8},{-32,-90},{-80,-90}}, color={0,127,255}));
  connect(ambientTemperature.port, compressor.heatPort) annotation (Line(points={{110,
          1.33227e-015},{90,1.33227e-015},{90,-1.33227e-015}},
                                               color={191,0,0}));
  connect(expansionValve.port_b, TEvaInl.port_a)
    annotation (Line(points={{-70,-20},{-70,-30}}, color={0,127,255}));
  connect(TEvaInl.port_b, evaporator.port_a1) annotation (Line(points={{-70,-50},
          {-70,-60.4},{-22,-60.4}}, color={0,127,255}));
  connect(compressor.port_a, TEvaOut.port_b)
    annotation (Line(points={{70,-20},{70,-30}}, color={0,127,255}));
  connect(TEvaOut.port_a, evaporator.port_b1) annotation (Line(points={{70,-50},
          {70,-60.4},{22,-60.4}}, color={0,127,255}));
  connect(condenser.port_a1, TConInl.port_b)
    annotation (Line(points={{22,60.4},{70,60.4},{70,50}}, color={0,127,255}));
  connect(TConInl.port_a, compressor.port_b)
    annotation (Line(points={{70,30},{70,20}}, color={0,127,255}));
  connect(condenser.port_b1, TConOut.port_a) annotation (Line(points={{-22,60.4},
          {-70,60.4},{-70,50}}, color={0,127,255}));
  connect(TConOut.port_b, expansionValve.port_a)
    annotation (Line(points={{-70,30},{-70,20}}, color={0,127,255}));
  connect(souSecCon.ports[1], HConInl.port_a)
    annotation (Line(points={{-80,90},{-60,90}}, color={0,127,255}));
  connect(HConInl.port_b, condenser.port_a2) annotation (Line(points={{-40,90},{
          -30,90},{-30,69.2},{-22,69.2}}, color={0,127,255}));
  connect(sinSecCon.ports[1], HConOut.port_b)
    annotation (Line(points={{80,90},{80,86},{60,86}}, color={0,127,255}));
  connect(HConOut.port_a, condenser.port_b2) annotation (Line(points={{40,86},{30,
          86},{30,50.8},{22,50.8}}, color={0,127,255}));

  connect(valveController.y, expansionValve.manVarVal)
    annotation (Line(points={{-31,10},{-48.8,10}}, color={0,0,127}));
  connect(valveController.u_m, currentSuperheating.y)
    annotation (Line(points={{-20,-2},{-20,-4},{-20,-7.4}}, color={0,0,127}));
  connect(compressorController.u_s, setHeatCapacity.y)
    annotation (Line(points={{8,-10},{2.6,-10}}, color={0,0,127}));
  connect(valveController.u_s, setSuperheating.y)
    annotation (Line(points={{-8,10},{-2.6,10}}, color={0,0,127}));
  connect(compressorController.u_m, currentHeatCapacity.y)
    annotation (Line(points={{20,-22},{20,-27.4}}, color={0,0,127}));
  connect(setHeatCapacity.y, compressor.manVarCom) annotation (Line(points={{
          2.6,-10},{26,-10},{26,-12},{50,-12}}, color={0,0,127}));
  connect(TEvaInl.port_b, preEvaInl.port) annotation (Line(points={{-70,-50},{-70,
          -60.4},{-50,-60}}, color={0,127,255}));
  annotation (experiment(StopTime=6400));
end SimpleHeatPumpMSL;
