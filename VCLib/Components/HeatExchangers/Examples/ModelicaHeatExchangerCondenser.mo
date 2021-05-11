within VCLib.Components.HeatExchangers.Examples;
model ModelicaHeatExchangerCondenser
  "Testing a plate heat exchanger as condenser based on VDI approach"
  extends Modelica.Icons.Example;

  // Definition of media
  //
  replaceable package MediumPri =
    ExternalMedia.Examples.R410aCoolProp
    "Primary fluid"
    annotation (Dymola_choicesAllMatching=true);
  replaceable package MediumSec = AixLib.Media.Water
    "Secondary fluid"
    annotation (Dymola_choicesAllMatching=true);
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));

  // Definition of subcomponents
  //
  Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX basicHX(
    c_wall=500,
    use_T_start=true,
    k_wall=100,
    crossArea_1=4.5e-4,
    crossArea_2=4.5e-4,
    perimeter_1=0.075,
    perimeter_2=0.075,
    redeclare package Medium_1 = MediumPri,
    redeclare package Medium_2 = MediumSec,
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
    Twall_start(displayUnit="degC") = 323.15,
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
    p_a_start1=3000000,
    p_b_start1=3000000,
    T_start_1=373.15,
    p_a_start2=101325,
    p_b_start2=101325,
    T_start_2=303.15) "Model of a heat exchanger"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  AixLib.Fluid.Sources.MassFlowSource_T souPri(
    redeclare package Medium = MediumPri,
    m_flow=0.02,
    nPorts=1,
    T=373.15)
    "Source of primary fluid"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  AixLib.Fluid.Sources.MassFlowSource_T souSec(
    redeclare package Medium = MediumSec,
    m_flow=1,
    nPorts=1,
    T=303.15)
    "Source of secondary fluid"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));

  AixLib.Fluid.Sources.FixedBoundary sinSec(
    redeclare package Medium = MediumSec,
    nPorts=1,
    p=101325)
    "Sink of secondary fluid"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  AixLib.Fluid.Sources.FixedBoundary sinPri(
    redeclare package Medium = MediumPri,
    p=3000000,
    nPorts=1)
    "Sink of primary fluid"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));

equation
  // Connection of submodels
  //
  connect(souPri.ports[1], basicHX.port_a1) annotation (Line(points={{-60,30},{-40,
          30},{-40,-0.4},{-22,-0.4}}, color={0,127,255}));
  connect(sinPri.ports[1], basicHX.port_b1) annotation (Line(points={{60,30},{40,
          30},{40,-0.4},{22,-0.4}}, color={0,127,255}));
  connect(souSec.ports[1], basicHX.port_a2) annotation (Line(points={{60,-30},{30,
          -30},{30,-9.2},{22,-9.2}}, color={0,127,255}));
  connect(sinSec.ports[1], basicHX.port_b2) annotation (Line(points={{-60,-30},{
          -50,-30},{-30,-30},{-30,9.2},{-22,9.2}}, color={0,127,255}));

  annotation (experiment(StopTime=6400));
end ModelicaHeatExchangerCondenser;
