within VCLib.HeatPumpFlowSheets;
model PIControlledEV
  extends BaseClasses.PartialStandardFlowsheet(
    t_control_valve=100,
    opening_init=0.28,
    n=0.5,
    TEva_in=253.15,
    T_3_init(displayUnit="K"),
    T_4_init(displayUnit="K"),
    T_1_init(displayUnit="K"),
    T_2_init(displayUnit="K"),
    p1_init(displayUnit="Pa"),
    t_control_comp=100,
    redeclare package MediumPri =
        VCLib.Media.Refrigerants.R410a.R410a_IIR_P1_48_T233_473_Horner,
    redeclare
      AixLib.Fluid.Actuators.Valves.ExpansionValves.SimpleExpansionValves.IsenthalpicExpansionValve
      expansionValve(
    useInpFil=false,
    calcProc=AixLib.Fluid.Actuators.Valves.ExpansionValves.Utilities.Types.CalcProc.flowCoefficient,
    mFlowNom=m_flow_ref_init,
    dpNom=p2_init - p1_init,
    redeclare model FlowCoefficient =
        AixLib.Fluid.Actuators.Valves.ExpansionValves.Utilities.FlowCoefficient.SpecifiedFlowCoefficients.Poly_R410a_EEV_18,
    redeclare package Medium = MediumPri,
    dp_start=p2_init - p1_init,
    m_flow_start=m_flow_ref_init,
    m_flow_nominal=m_flow_ref_init),
    redeclare Components.HeatExchangers.EpsNTU.epsNTUIBPSA evaporator(
      A_heat=A_eva,
      alphaPri=5000,
      alphaSec=100,
      T_prim_start=T_4_init,
      T_sec_start=TEva_in,
      mflow_smooth=m_flow_ref_init*1e-4),
    redeclare Components.HeatExchangers.EpsNTU.epsNTUIBPSA condenser(A_heat=A_con,
      T_prim_start=T_2_init,
      T_sec_start=TCon_in,
      mflow_smooth=m_flow_ref_init*1e-4),
    TAmb=TEva_in,
    souSecCon(use_T_in=false),
    souSecEva(use_T_in=true));
  AixLib.Controls.Continuous.LimPID valveController1(
    yMax=1,
    yMin=0,
    y_start=opening_init,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    k=-0.97,
    Ti=4.3,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Controller of the expansion valve" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-46,18})));
  Modelica.Blocks.Sources.Constant dT_sh_set(k=dT_superheating_set) annotation (
     Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-22,18})));
  Modelica.Blocks.Sources.RealExpression superHeating_internal(y=superHeating)
    annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=180,
        origin={-57,-23})));
  Modelica.Blocks.Sources.Ramp     ramp(
    height=(n - n_init)*compressor.rotSpeMax,
    duration=200,
    offset=n_init*compressor.rotSpeMax,
    startTime=t_control_valve)
    annotation (Placement(transformation(extent={{4,-22},{20,-6}})));
  Modelica.Blocks.Sources.Ramp     TConSet1(
    height=TEva_in - TEva_in_init,
    duration=(TEva_in - TEva_in_init)*200,
    offset=TEva_in_init,
    startTime=t_control_valve)                  annotation (Placement(
        transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={122,-90})));
  Modelica.Blocks.Sources.Ramp     ramp1(
    height=(n - n_init),
    duration=200,
    offset=n_init,
    startTime=t_control_valve)
    annotation (Placement(transformation(extent={{8,12},{24,28}})));
equation
  connect(superHeating_internal.y, valveController1.u_m) annotation (Line(
        points={{-44.9,-23},{-36,-23},{-36,-8},{-46,-8},{-46,8.4}},
                 color={0,0,127}));
  connect(dT_sh_set.y, valveController1.u_s)
    annotation (Line(points={{-28.6,18},{-36.4,18}}, color={0,0,127}));
  connect(TConSet1.y, souSecEva.T_in) annotation (Line(points={{115.4,-90},{110,
          -90},{110,-86},{102,-86}}, color={0,0,127}));
  connect(valveController1.y, expansionValve.manVarVal) annotation (Line(points={{-54.8,
          18},{-62,18},{-62,4.25},{-75.07,4.25}}, color={0,0,127}));
  connect(ramp.y, compressor.manVarCom) annotation (Line(points={{20.8,-14},{
          33.4,-14},{33.4,-12},{50,-12}}, color={0,0,127}));
  annotation (experiment(
      StopTime=400,
      Interval=1,
      Tolerance=0.001,
      __Dymola_Algorithm="Cvode"), __Dymola_experimentFlags(Advanced(
        InlineMethod=0,
        InlineOrder=2,
        InlineFixedStep=0.001)));
end PIControlledEV;
