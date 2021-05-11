within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Examples.Robustheit.Robustheit_FVM;
model Test_Cond_1_Temp_FVM
  "Test model for robustness: temperature in a range between 0 and 100°C"
  extends Modelica.Icons.Example;

  // Definition of media
  //
  replaceable package MediumPri =
    Modelica.Media.R134a.R134a_ph
    "Primary fluid"
    annotation (Dymola_choicesAllMatching=true);
  replaceable package MediumSecCon =
      Modelica.Media.Water.WaterIF97OnePhase_ph
    "Secondary fluid"
    annotation (Dymola_choicesAllMatching=true);
  replaceable package MediumSecEva =
      Modelica.Media.Water.WaterIF97OnePhase_ph
    "Secondary fluid"
    annotation (Dymola_choicesAllMatching=true);

  // Further media models
  //
  // ExternalMedia.Examples.R410aCoolProp
  // WorkingVersion.Media.Refrigerants.R410a.R410a_IIR_P1_48_T233_473_Horner

  // Definition of subcomponents
  //

  AixLib.Fluid.Sources.MassFlowSource_T souPri(
    redeclare package Medium = MediumPri,
    m_flow=0.04,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1,
    T=275.15) "Source of primary fluid"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  // Definition of further variables
  //

  // Definition of controllers
  //

  Modelica.Blocks.Sources.Sine temperature_sou(
    phase(displayUnit="rad"),
    f=0.5,
    startTime=0,
    offset=323.15,
    amplitude=50)
    annotation (Placement(transformation(extent={{-60,78},{-80,98}})));
  HeatExchanger_FVM.FiniteVolumenHeatExchangers.SimpleHeatExchangers.Condenser
    condensor(
    redeclare package MediumPri = MediumPri,
    redeclare package MediumSec = MediumSecCon,
    s=0.002,
    B=0.2,
    k=1,
    H=0.07,
    n=5,
    L=0.5,
    T_start_cold=303.15,
    T_start_hot=373.15,
    p_start_cold=101325,
    p_start_hot=3000000) annotation (Placement(transformation(
          extent={{10,4},{-10,-16}})));
  AixLib.Fluid.Sources.MassFlowSource_T souSecCon(
    redeclare package Medium = MediumSecCon,
    m_flow=1,
    nPorts=1,
    T=298.15) "Source of secondary fluid"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,-80})));
  AixLib.Fluid.Sensors.EnthalpyFlowRate HConInl(
    redeclare package Medium = MediumSecCon,
    allowFlowReversal=false,
    m_flow_nominal=1,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Enthalpy flow rate at condenser's inlet at secondary side"
    annotation (Placement(transformation(extent={{70,-90},{50,-70}})));
  AixLib.Fluid.Sensors.EnthalpyFlowRate HConOut(
    redeclare package Medium = MediumSecCon,
    allowFlowReversal=false,
    m_flow_nominal=1,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Enthalpy flow rate at condenser's outlet at secondary side"
    annotation (Placement(transformation(extent={{-50,-90},{-70,-70}})));
  AixLib.Fluid.Sources.FixedBoundary sinSecCon(
    redeclare package Medium = MediumSecCon,
    nPorts=1,
    p=101325,
    T=318.15) "Sink of secondary fluid"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  AixLib.Fluid.Sources.Boundary_pT sinPri(
    redeclare package Medium = MediumPri,
    use_p_in=true,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant temperature_sin(k=273.15 + 5)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Sources.Constant massflow_sou(k=0.04)
    annotation (Placement(transformation(extent={{-40,40},{-60,60}})));
  Modelica.Blocks.Sources.Sine pressure_sin(
    f=0.5,
    startTime=0,
    amplitude=10000,
    offset=100000)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
equation
  // Connection of submodels
  //

  connect(HConInl.port_a, souSecCon.ports[1])
    annotation (Line(points={{70,-80},{82,-80}}, color={0,127,255}));
  connect(HConInl.port_b, condensor.port_in_cold) annotation (Line(points={{50,-80},
          {40,-80},{40,-12},{10,-12}}, color={0,127,255}));
  connect(sinSecCon.ports[1], HConOut.port_b)
    annotation (Line(points={{-80,-80},{-70,-80}}, color={0,127,255}));
  connect(HConOut.port_a, condensor.port_out_cold) annotation (Line(points={{-50,
          -80},{-40,-80},{-40,-12},{-10,-12}}, color={0,127,255}));
  connect(temperature_sin.y, sinPri.T_in)
    annotation (Line(points={{81,90},{96,90},{96,4},{82,4}}, color={0,0,127}));
  connect(temperature_sou.y, souPri.T_in) annotation (Line(points={{-81,88},
          {-96,88},{-96,4},{-82,4}},
                                color={0,0,127}));
  connect(massflow_sou.y, souPri.m_flow_in) annotation (Line(points={{-61,50},{
          -90,50},{-90,8},{-82,8}},
                                color={0,0,127}));
  connect(souPri.ports[1], condensor.port_in_hot) annotation (Line(points=
         {{-60,0},{-34,0},{-34,0},{-10,0}}, color={0,127,255}));
  connect(condensor.port_out_hot, sinPri.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(pressure_sin.y, sinPri.p_in) annotation (Line(points={{61,50},{
          90,50},{90,8},{82,8}}, color={0,0,127}));
  annotation (experiment(StopTime=6400));
end Test_Cond_1_Temp_FVM;
