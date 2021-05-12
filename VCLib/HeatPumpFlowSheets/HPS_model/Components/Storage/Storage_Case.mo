within VCLib.HeatPumpFlowSheets.HPS_model.Components.Storage;
model Storage_Case
  "Storage using simple ports needs a case to connect to normal port"

  /******************************* Parameters *******************************/
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.Pressure p_hydr = 2e5 "Hydraulic pressure in pipes" annotation(Dialog(group = "Demand"));

  // Storage settings
  parameter Integer n_stoLayer = 4 "Number of layers in storage" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.Length d_sto = 0.5 "Storage diameter" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.Length h_sto = 1 "Storage height" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_stoIn = 100 "Internal heat transfer coefficient" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_stoOut = 10
                                                                     "External heat transfer coefficient" annotation(Dialog(group = "Storage"));

  /******************************* Variables *******************************/
  Modelica.SIunits.Temperature T_stoTop "Top temperature in storage";
  Modelica.SIunits.Temperature T_stoBot "Bottom temperature in storage";

  /******************************* Components *******************************/

  Storage storage(
    d=d_sto,
    h=h_sto,
    n=n_stoLayer,
    alpha_in=alpha_stoIn,
    alpha_out=alpha_stoOut)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_heatGenerator(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_heatGenerator(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-50},{-110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_consumer(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_consumer(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{10,90},{-10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  AixLib.Fluid.Sources.Boundary_pT bou_gen_in(
    redeclare package Medium = Medium,
    nPorts=1,
    p=p_hydr) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-68,40})));
  AixLib.Fluid.Sources.MassFlowSource_h bou_gen_back(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    use_h_in=true,
    h_in=inStream(bou_sto_gen_out.port_a.h_outflow),
    m_flow_in=bou_gen_in.ports[1].m_flow) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-68,-40})));
  AixLib.Fluid.Sources.MassFlowSource_h bou_dem_out(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    use_h_in=true,
    m_flow_in=bou_dem_in.ports[1].m_flow,
    h_in=inStream(bou_sto_con_out.port_a.h_outflow)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,78})));
  AixLib.Fluid.Sources.Boundary_pT bou_dem_in(
    redeclare package Medium = Medium,
    nPorts=1,
    p=p_hydr) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-76})));
  BaseClasses.Boundaries.Boundary_p bou_sto_gen_out(p=p_hydr)
    annotation (Placement(transformation(extent={{-40,-18},{-20,2}})));
  BaseClasses.Boundaries.Boundary_h_mflow bou_sto_gen_in(
    use_h_in=true,
    use_m_flow_in=true,
    m_flow_in=bou_gen_in.ports[1].m_flow,
    h_in=inStream(bou_gen_in.ports[1].h_outflow))
    annotation (Placement(transformation(extent={{-40,6},{-20,26}})));
  BaseClasses.Boundaries.Boundary_h_mflow bou_sto_con_in(
    use_m_flow_in=true,
    use_h_in=true,
    m_flow_in=bou_dem_in.ports[1].m_flow,
    h_in=inStream(bou_dem_in.ports[1].h_outflow)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-32})));
  BaseClasses.Boundaries.Boundary_p bou_sto_con_out(p=p_hydr) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,38})));
equation

  // Get temperatures in storage
  T_stoBot = storage.layer[1].T;
  T_stoTop = storage.layer[n_stoLayer].T;

  connect(storage.heatPort,heatPort)
    annotation (Line(points={{8,0},{100,0}}, color={191,0,0}));
  connect(bou_sto_gen_out.port_a, storage.port_b_HE)
    annotation (Line(points={{-20,-8},{-8.4,-8}}, color={0,127,255}));
  connect(bou_sto_gen_in.port_a, storage.port_a_HE) annotation (Line(points={{-20,
          16},{-14,16},{-14,8.8},{-8.4,8.8}}, color={0,127,255}));
  connect(bou_sto_con_in.port_a, storage.port_a)
    annotation (Line(points={{0,-22},{0,-10}}, color={0,127,255}));
  connect(bou_sto_con_out.port_a, storage.port_b)
    annotation (Line(points={{0,28},{0,10}}, color={0,127,255}));
  connect(port_a_heatGenerator, bou_gen_in.ports[1])
    annotation (Line(points={{-100,40},{-78,40}}, color={0,127,255}));
  connect(port_b_heatGenerator, bou_gen_back.ports[1])
    annotation (Line(points={{-100,-40},{-78,-40}}, color={0,127,255}));
  connect(port_a_consumer, bou_dem_in.ports[1])
    annotation (Line(points={{0,-100},{0,-86}}, color={0,127,255}));
  connect(port_b_consumer, bou_dem_out.ports[1])
    annotation (Line(points={{0,100},{0,88}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-112,-100},{142,-198}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Storage_Case;
