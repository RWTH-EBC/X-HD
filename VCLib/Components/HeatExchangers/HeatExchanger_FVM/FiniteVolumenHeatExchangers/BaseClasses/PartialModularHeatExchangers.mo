within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.BaseClasses;
partial model PartialModularHeatExchangers
  "Base class for all models of modular moving boundary heat exchanger"

  // Definition of parameters describing modular approach
  //
  parameter Boolean useModPortsb_a = false
    "= true, if model uses 'ModularPort_a'; otherwise model uses simple ports"
    annotation (Dialog(tab="General",group="Modular approach"));
  parameter Integer nHeaExc = 1
    "Number of inlet and outlet ports"
    annotation(Dialog(tab="General",group="Modular approach"));

  // Definition of general parameters
  //
  parameter
    VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.ApplicationHX
    appHX=VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.ApplicationHX.Condenser
    "Application of the heat exchangver (e.g. evaporator or condenser)"
    annotation (Dialog(tab="General", group="General"));
  parameter
    VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.TypeHX
    typHX=VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.TypeHX.CounterCurrent
    "Type of the heat exchangver (e.g. counter-current heat exchanger)"
    annotation (Dialog(tab="General", group="General"));

  replaceable package Medium1 =
    AixLib.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Secondary fluid in the component"
    annotation (Dialog(tab="General",group="General"),
                choicesAllMatching = true);
  replaceable package Medium2 =
    Modelica.Media.R134a.R134a_ph
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Working fluid in the component"
    annotation (Dialog(tab="General",group="General"),
                choicesAllMatching = true);

  // Definition of submodels
  //

  // Definition of parameters describing moving boundary cell
  //

  parameter Boolean useHeaCoeModPri[nHeaExc]=
    fill(false,nHeaExc)
    "= true, if model is used to calculate coefficients of heat transfers"
    annotation (Dialog(tab="Moving boundary", group="Heat transfer"));
  replaceable model CoefficientOfHeatTransferSCPri =
    VCLib.Components.HeatExchangers.MovingBoundaryHeatExchangers.Utilities.HeatTransfers.ConstantCoefficientOfHeatTransfer
    constrainedby PartialCoefficientOfHeatTransfer
    "Model describing the calculation method of the coefficient of heat 
    transfer of the supercooled regime"
    annotation (Dialog(tab="Moving boundary", group="Heat transfer",
                enable = useHeaCoeModPri),
                choicesAllMatching=true);

  parameter
    VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.CalculationHeatFlow
    heaFloCalPri[nHeaExc]=fill(VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.CalculationHeatFlow.
       E_NTU, nHeaExc)
    "Choose the way of calculating the heat flow between the wall and medium"
    annotation (Dialog(tab="Moving boundary", group="Heat transfer"));

  // Definition of parameters describing secondary fluid
  //
  parameter Boolean useHeaCoeModSec[nHeaExc]=
    fill(false,nHeaExc)
    "= true, if model is used to calculate coefficients of heat transfers"
    annotation (Dialog(tab="Secondary fluid", group="Heat transfer"));
  replaceable model CoefficientOfHeatTransferSec =
    VCLib.Components.HeatExchangers.MovingBoundaryHeatExchangers.Utilities.HeatTransfers.ConstantCoefficientOfHeatTransfer
    "Model describing the calculation method of the coefficient of heat 
    transfer"
    annotation (Dialog(tab="Secondary fluid", group="Heat transfer",
                enable = useHeaCoeModSec),
                choicesAllMatching=true);

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer AlpSCSec[nHeaExc]=fill(
      100, nHeaExc) "Effective coefficient of heat transfer between the wall and fluid of the
    supercooled regime" annotation (Dialog(
      tab="Secondary fluid",
      group="Heat transfer",
      enable=not useHeaCoeModSec));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer AlpTPSec[nHeaExc]=fill(
      100, nHeaExc) "Effective coefficient of heat transfer between the wall and fluid of the
    two-phase regime" annotation (Dialog(
      tab="Secondary fluid",
      group="Heat transfer",
      enable=not useHeaCoeModSec));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer AlpSHSec[nHeaExc]=fill(
      100, nHeaExc) "Effective coefficient of heat transfer between the wall and fluid of the
    superheated regime" annotation (Dialog(
      tab="Secondary fluid",
      group="Heat transfer",
      enable=not useHeaCoeModSec));

  parameter
    VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.CalculationHeatFlow
    heaFloCalSec[nHeaExc]=fill(VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.CalculationHeatFlow.
       E_NTU, nHeaExc)
    "Choose the way of calculating the heat flow between the wall and medium"
    annotation (Dialog(tab="Secondary fluid", group="Heat transfer"));

  // Definition of parameters descrbing sensors
  //
  parameter Modelica.Units.SI.Time tau=1 "Time constant at nominal flow rate (use tau=0 for steady-state sensor,
    but see user guide for potential problems)"
    annotation (Dialog(tab="Sensors", group="General"));

  parameter Boolean transferHeat=false
    "if true, temperature T converges towards TAmb when no flow"
    annotation (Dialog(tab="Sensors", group="Temperature"));
  parameter Modelica.Units.SI.Temperature TAmb=Medium1.T_default
    "Fixed ambient temperature for heat transfer"
    annotation (Dialog(tab="Sensors", group="Temperature"));
  parameter Modelica.Units.SI.Time tauHeaTra=1200
    "Time constant for heat transfer, default 20 minutes"
    annotation (Dialog(tab="Sensors", group="Temperature"));

  parameter Modelica.Blocks.Types.Init initTypeSen=
    Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
    annotation (Dialog(tab="Sensors", group="Initialisation"));
  parameter Modelica.Units.SI.Temperature TIniSen=Medium1.T_default
    "Initial or guess value of output (= state)"
    annotation (Dialog(tab="Sensors", group="Initialisation"));

  // Definitions of parameters describing assumptions
  //
  parameter Boolean allowFlowReversal1 = true
    "= false to simplify equations, assuming, but not enforcing, 
    no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions",group="General"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= false to simplify equations, assuming, but not enforcing, 
    no flow reversal for medium 2"
    annotation(Dialog(tab="Assumptions",group="General"), Evaluate=true);

  // Definitions of parameters describing advanced options
  //
  parameter Medium2.MassFlowRate m_flow_nominalPri=0.035
    "Nominal mass flow rate of the primary fluid"
    annotation (Dialog(tab="Advanced", group="Nominal conditions"));
  parameter Medium2.MassFlowRate m_flow_smallPri=1e-6*m_flow_nominalPri
    "Small mass flow rate  of the primary fluid for regularization of zero flow"
    annotation (Dialog(tab="Advanced", group="Nominal conditions"));

  parameter Medium1.MassFlowRate m_flow_nominalSec=0.5
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation (Dialog(tab="Advanced", group="Nominal conditions"));
  parameter Medium1.MassFlowRate m_flow_smallSec=1E-4*m_flow_nominalSec
    "For bi-directional flow, temperature is regularized in the region 
    |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation (Dialog(tab="Advanced", group="Nominal conditions"));

  parameter Modelica.Units.SI.AbsolutePressure pIni[nHeaExc]=fill(2e5, nHeaExc)
    "Start value of absolute pressure"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Modelica.Units.SI.SpecificEnthalpy dhIni[nHeaExc]=fill(10, nHeaExc)
    "Difference between inlet and outlet enthalpies 
    (hInl = hOut+dh0) at initialisation"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Boolean useFixStaValPri[nHeaExc]=
    fill(false,nHeaExc)
    "= true, if start values are fixed"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Real dhSCTPdtIni[nHeaExc]=
    fill(1e-5,nHeaExc)
    "Guess value of dhSCTPdt"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Real dhTPSHtIni[nHeaExc]=
    fill(1e-5,nHeaExc)
    "Guess value of dhTPSHdt"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Real dhOutdtIni[nHeaExc]=
    fill(1e-5,nHeaExc)
    "Guess value of dhOutDesdt"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Real dlenSCdtIni[nHeaExc]=
    fill(1e-5,nHeaExc)
    "Guess value of dtlenSCdt"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Real dlenTPdtIni[nHeaExc]=
    fill(1e-5,nHeaExc)
    "Guess value of dlenTPdt"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Real dlenSHdtIni[nHeaExc]=
    fill(1e-5,nHeaExc)
    "Guess value of dlenSHdt"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Medium2.MassFlowRate
    m_flow_startInl[nHeaExc]=
    fill(0.5*m_flow_nominalPri,nHeaExc)
    "Guess value of m_flow_startInl"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Medium2.MassFlowRate
    m_flow_startSCTP[nHeaExc]=
    fill(0.5*m_flow_nominalPri,nHeaExc)
    "Guess value of m_flow_startSCTP"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Medium2.MassFlowRate
    m_flow_startTPSH[nHeaExc]=
    fill(0.5*m_flow_nominalPri,nHeaExc)
    "Guess value of m_flow_startTPSH"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));
  parameter Medium2.MassFlowRate
    m_flow_startOut[nHeaExc]=
    fill(0.5*m_flow_nominalPri,nHeaExc)
    "Guess value of m_flow_startOut"
    annotation (Dialog(tab="Advanced", group="Initialisation moving boundary"));

  parameter Boolean iniSteStaWal[nHeaExc]=
    fill(false,nHeaExc)
    "=true, if temperatures of different regimes are initialised steady state"
    annotation (Dialog(tab="Advanced", group="Initialisation wall"));
  parameter Modelica.Units.SI.Temperature TSCIniWal[nHeaExc]=fill(293.15,
      nHeaExc) "Temperature of supercooled regime at initialisation"
    annotation (Dialog(tab="Advanced", group="Initialisation wall"));
  parameter Modelica.Units.SI.Temperature TTPIniWal[nHeaExc]=fill(293.15,
      nHeaExc) "Temperature of two-phase regime at initialisation"
    annotation (Dialog(tab="Advanced", group="Initialisation wall"));
  parameter Modelica.Units.SI.Temperature TSHIniWal[nHeaExc]=fill(293.15,
      nHeaExc) "Temperature of superheated regime at initialisation"
    annotation (Dialog(tab="Advanced", group="Initialisation wall"));

  parameter Boolean iniSteStaSec[nHeaExc]=
    fill(false,nHeaExc)
    "=true, if temperatures of different regimes are initialised steady state"
    annotation (Dialog(tab="Advanced", group="Initialisation secondary"));
  parameter Modelica.Units.SI.Temperature TSCIniSec[nHeaExc]=fill(293.15,
      nHeaExc) "Temperature of supercooled regime at initialisation"
    annotation (Dialog(tab="Advanced", group="Initialisation secondary"));
  parameter Modelica.Units.SI.Temperature TTPIniSec[nHeaExc]=fill(293.15,
      nHeaExc) "Temperature of two-phase regime at initialisation"
    annotation (Dialog(tab="Advanced", group="Initialisation secondary"));
  parameter Modelica.Units.SI.Temperature TSHIniSec[nHeaExc]=fill(293.15,
      nHeaExc) "Temperature of superheated regime at initialisation"
    annotation (Dialog(tab="Advanced", group="Initialisation secondary"));

  parameter Real lenMin[nHeaExc]=
    fill(1e-4,nHeaExc)
    "Threshold length of switching condition"
    annotation (Dialog(tab="Advanced", group="Convergence"));
  parameter Real tauVoiFra[nHeaExc]=
    fill(125,nHeaExc)
    "Time constant to describe convergence of void fraction if flow state 
    changes"
    annotation (Dialog(tab="Advanced", group="Convergence"));
  parameter Modelica.Units.SI.Frequency tauTem[nHeaExc]=fill(1, nHeaExc)
    "Time constant describing convergence of wall temperatures of inactive regimes"
    annotation (Dialog(tab="Advanced", group="Convergence"));

  parameter Boolean calBalEquPri=true
    "= true, if balance equations are computed"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  parameter Boolean calBalEquWal=true
    "= true, if balance equations are computed"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));

  // Definition of connectors
  //
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nHeaExc](
    redeclare each final package Medium = Medium1,
     m_flow(each min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
     h_outflow(each start = Medium1.h_default))
    "Fluid connectors a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},
        rotation=-90,
        origin={50,100})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nHeaExc](
    redeclare each final package Medium = Medium1,
    m_flow(each max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(each start = Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-10,40},{10,-40}},
        rotation=90,
        origin={-50,100})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare each final package Medium = Medium2,
     m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
     h_outflow(start = Medium2.h_default)) if not useModPortsb_a
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a2[nHeaExc](
    redeclare each final package Medium = Medium2,
     m_flow(each min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
     h_outflow(each start = Medium2.h_default)) if useModPortsb_a
    "Fluid connectors a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-40},{-90,40}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare each final package Medium = Medium2,
    m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium2.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // Definition of bus connectors
  //
  AixLib.Controls.Interfaces.ModularHeatPumpControlBus dataBus
    "Connector that contains all relevant control signals" annotation (
      Placement(transformation(extent={{-20,-120},{20,-80}})));

  // Definition of instances of submodels
  //
  AixLib.Fluid.Sensors.MassFlowRate senMasFloSec[nHeaExc](redeclare each
      package Medium =      Medium1, each final allowFlowReversal=
        allowFlowReversal1)
    "Mass flow sensors at outlets of secondary sides of heat exchangers"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-40,40})));
  AixLib.Fluid.Sensors.Pressure senPreSec[nHeaExc](redeclare each package
      Medium =         Medium1)
    "Pressure sensors at outlets of secondary sides of heat exchangers"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,70})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTemInlSec[nHeaExc](
    redeclare each package Medium = Medium1,
    each final m_flow_nominal=m_flow_nominalSec,
    each final tau=tau,
    each final initType=initTypeSen,
    each final T_start=TIniSen,
    each final transferHeat=transferHeat,
    each final TAmb=TAmb,
    each final tauHeaTra=tauHeaTra,
    each final allowFlowReversal=allowFlowReversal1,
    each final m_flow_small=m_flow_smallSec)
    "Temperature sensors at inlets of secondary sides of heat exchangers"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,10})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTemOutSec[nHeaExc](
    redeclare each package Medium = Medium1,
    each final m_flow_nominal=m_flow_nominalSec,
    each final tau=tau,
    each final initType=initTypeSen,
    each final T_start=TIniSen,
    each final transferHeat=transferHeat,
    each final TAmb=TAmb,
    each final tauHeaTra=tauHeaTra,
    each final allowFlowReversal=allowFlowReversal1,
    each final m_flow_small=m_flow_smallSec)
    "Temperature sensors at outlets of secondary sides of heat exchangers"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-40,10})));

  VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.SimpleHeatExchangers.Condenser
    heaExc[nHeaExc]
    annotation (Placement(transformation(extent={{10,-40},{-10,-20}})));
equation
  // Connection of secondary fluid side
  //
  connect(ports_a1, senTemInlSec.port_a)
    annotation (Line(points={{50,100},{48,100},{48,88},{40,88},{40,20}},
                color={0,127,255}));
  connect(senTemOutSec.port_b, senMasFloSec.port_a)
    annotation (Line(points={{-40,20},{-40,30}}, color={0,127,255}));
  connect(senMasFloSec.port_b, senPreSec.port)
    annotation (Line(points={{-40,50},{-40,70}}, color={0,127,255}));
  connect(senPreSec.port,ports_b1)
    annotation (Line(points={{-40,70},{-40,70},{-40,88},{-50,88},{-50,100}},
                color={0,127,255}));

  // Connection of primary fluid side
  //
  if not useModPortsb_a then
    for i in 1:nHeaExc loop
      connect(port_a2,heaExc[i].port_a2);
    end for;
  else
    connect(ports_a2,heaExc.port_a2);
  end if;

  // Connection of sensor signals
  //
  if appHX == VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types.ApplicationHX.Evaporator then
    /* Evaorator */
    connect(senPreSec.p, dataBus.senBus.meaPreEvaSou);
    connect(senTemInlSec.T, dataBus.senBus.meaTemEvaSouInl);
    connect(senTemOutSec.T, dataBus.senBus.meaTemEvaSouOut);
    connect(senMasFloSec.m_flow, dataBus.senBus.meaMasFloEvaSou);
  else
    /* Condenser */
    connect(senPreSec.p, dataBus.senBus.meaPreConSin);
    connect(senTemInlSec.T, dataBus.senBus.meaTemConSinInl);
    connect(senTemOutSec.T, dataBus.senBus.meaTemConSinOut);
    connect(senMasFloSec.m_flow, dataBus.senBus.meaMasFloConSin);
  end if;

  connect(senTemInlSec.port_b, heaExc.port_in_cold) annotation (Line(
        points={{40,0},{26,0},{26,-24},{10,-24}}, color={0,127,255}));
  connect(heaExc.port_out_cold, senTemOutSec.port_a) annotation (Line(
        points={{-10,-24},{-26,-24},{-26,0},{-40,0}}, color={0,127,
          255}));
  connect(ports_a2, heaExc.port_in_hot) annotation (Line(points={{
          -100,0},{-56,0},{-56,-36},{-10,-36}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-60,60},{20,68}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-60,60},{20,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,60},{-60,40},{-10,40},{-18,42},{-24,44},{-32,46},{-32,54},
              {-24,56},{-18,58},{-10,60},{-60,60}},
          lineColor={28,108,200},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,60},{-60,36}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,32},{20,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.CrossDiag),
        Line(
          points={{-32,60},{-40,56},{-34,52},{-40,46},{-34,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-14,60},{-10,54},{-18,50},{-10,46},{-14,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Rectangle(
          extent={{-60,10},{20,18}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-60,10},{20,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,10},{-60,-10},{-10,-10},{-18,-8},{-24,-6},{-32,-4},{-32,4},
              {-24,6},{-18,8},{-10,10},{-60,10}},
          lineColor={28,108,200},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,10},{-60,-14}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-18},{20,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.CrossDiag),
        Line(
          points={{-32,10},{-40,6},{-34,2},{-40,-4},{-34,-10}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-14,10},{-10,4},{-18,0},{-10,-4},{-14,-10}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Rectangle(
          extent={{-60,-40},{20,-32}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-60,-40},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,-40},{-60,-60},{-10,-60},{-18,-58},{-24,-56},{-32,-54},{-32,
              -46},{-24,-44},{-18,-42},{-10,-40},{-60,-40}},
          lineColor={28,108,200},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-40},{-60,-64}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-68},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.CrossDiag),
        Line(
          points={{-32,-40},{-40,-44},{-34,-48},{-40,-54},{-34,-60}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-14,-40},{-10,-46},{-18,-50},{-10,-54},{-14,-60}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-80,44},{-80,-58}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-100,0},{-80,0}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Ellipse(
          extent={{-82,2},{-78,-2}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,44},{-60,44}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-80,-8},{-60,-8}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-80,-58},{-60,-58}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Ellipse(
          extent={{-82,-6},{-78,-10}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{20,-8},{60,-8}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{20,44},{60,44}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{20,-58},{60,-58}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{60,44},{60,-58}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{60,0},{100,0}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Ellipse(
          extent={{58,2},{62,-2}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{58,-6},{62,-10}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,80},{50,80}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-70,80},{-50,80}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-70,80},{-70,-42}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{30,80},{30,-42}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{20,-42},{30,-42}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{20,58},{30,58}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-70,58},{-60,58}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-70,8},{-60,8}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{20,8},{30,8}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-70,-42},{-60,-42}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{50,100},{50,80}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-50,100},{-50,80}},
          color={0,127,255},
          smooth=Smooth.Bezier,
          thickness=0.5)}),
        Diagram(
          coordinateSystem(preserveAspectRatio=false),
          graphics={
          Line(points={{30,10},{0,10},{0,-100}}, color={0,0,127}),
          Line(points={{-50,82},{0,82},{0,10}},   color={0,0,127}),
          Line(points={{-28,40},{-6,40},{0,40}},  color={0,0,127}),
          Line(points={{-28,10},{-6,10},{0,10}},  color={0,0,127})}));
end PartialModularHeatExchangers;
