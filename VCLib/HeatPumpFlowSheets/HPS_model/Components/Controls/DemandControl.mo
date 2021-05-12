within VCLib.HeatPumpFlowSheets.HPS_model.Components.Controls;
model DemandControl "Controller deciding which storage will be loaded"

  /******************************* Parameters *******************************/
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.SIunits.Pressure p_hydr = 2e5 "Hydraulic pressure in pipes" annotation(Dialog(group = "Demand"));

  /******************************* Variables *******************************/

  Modelica.SIunits.MassFlowRate m_flowGen = port_a.m_flow "Mass flow rate within generation pipes";
  Modelica.SIunits.SpecificEnthalpy h_gen = inStream(port_a.h_outflow) "Specific enthalpy of inlet stream";

  /******************************* Components *******************************/

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium,
     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default)) "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default)) "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-50},{-110,-30}})));

  Modelica.Blocks.Interfaces.BooleanInput dhw_on
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,112})));
  Modelica.Blocks.Interfaces.BooleanInput buffer_on
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,112})));
  Modelica.Fluid.Interfaces.FluidPort_a port_dhw_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) "Port connecting from dhw demand"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_dhw_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) "Port connecting into dhw demand"
    annotation (Placement(transformation(extent={{110,70},{90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_buf_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) "Port connecting from heating demand"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_buf_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) "Port connecting to heating demand"
    annotation (Placement(transformation(extent={{110,-50},{90,-30}})));
  AixLib.Fluid.Sources.MassFlowSource_h bou_dhw_in(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    use_h_in=true,
    h_in=h_gen)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={68,80})));
  AixLib.Fluid.Sources.Boundary_pT bou_dhw_out(
    redeclare package Medium = Medium,
    nPorts=1,
    p=p_hydr) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,40})));
  AixLib.Fluid.Sources.MassFlowSource_h bou_buf_in(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    use_h_in=true,
    h_in=h_gen)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={68,-40})));
  AixLib.Fluid.Sources.Boundary_pT bou_buf_out(
    redeclare package Medium = Medium,
    nPorts=1,
    p=p_hydr) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-80})));
  AixLib.Fluid.Sources.MassFlowSource_h bou_gen_in(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    use_h_in=true)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-68,-40})));
  AixLib.Fluid.Sources.Boundary_pT bou_gen_out(
    redeclare package Medium = Medium,
    nPorts=1,
    p=p_hydr) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-68,40})));
  Modelica.Blocks.Sources.RealExpression dummyZero annotation (Placement(transformation(extent={{-30,26},
            {-10,46}})));
  Modelica.Blocks.Sources.RealExpression dummyMassFlow(y=m_flowGen) annotation (Placement(transformation(extent={{-30,0},
            {-10,20}})));
  Modelica.Blocks.Logical.Or or1 annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-48,70})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-32,-28},{-44,-16}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-32,-62},{-44,-50}})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{28,78},{40,90}})));
  Modelica.Blocks.Logical.Switch switch4
    annotation (Placement(transformation(extent={{32,-38},{44,-26}})));
  Modelica.Blocks.Sources.RealExpression dummyEnthalpyDhw(y=inStream(port_dhw_a.h_outflow))
    annotation (Placement(transformation(extent={{14,-82},{-6,-62}})));
  Modelica.Blocks.Sources.RealExpression dummyEnthalpyBuf(y=inStream(port_buf_a.h_outflow))
    annotation (Placement(transformation(extent={{30,-62},{10,-42}})));
equation
  connect(port_a, bou_gen_out.ports[1]) annotation (Line(points={{-100,40},{-78,40}}, color={0,127,255}));
  connect(port_b, bou_gen_in.ports[1]) annotation (Line(points={{-100,-40},{-78,-40}}, color={0,127,255}));
  connect(bou_buf_in.ports[1], port_buf_b) annotation (Line(points={{78,-40},{100,-40}}, color={0,127,255}));
  connect(bou_buf_out.ports[1], port_buf_a) annotation (Line(points={{80,-80},{100,-80}}, color={0,127,255}));
  connect(bou_dhw_out.ports[1], port_dhw_a) annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(bou_dhw_in.ports[1], port_dhw_b) annotation (Line(points={{78,80},{100,80}}, color={0,127,255}));
  connect(dhw_on, or1.u2) annotation (Line(points={{-40,112},{-40,88},{-52.8,88},
          {-52.8,77.2}}, color={255,0,255}));
  connect(buffer_on, or1.u1) annotation (Line(points={{0,112},{0,84},{-48,84},{
          -48,77.2}}, color={255,0,255}));
  connect(dhw_on, switch3.u2) annotation (Line(points={{-40,112},{-40,88},{14,
          88},{14,84},{26.8,84}}, color={255,0,255}));
  connect(switch3.y, bou_dhw_in.m_flow_in) annotation (Line(points={{40.6,84},{
          46,84},{46,88},{56,88}}, color={0,0,127}));
  connect(dummyZero.y, switch3.u3) annotation (Line(points={{-9,36},{20,36},{20,
          79.2},{26.8,79.2}}, color={0,0,127}));
  connect(dummyMassFlow.y, switch3.u1) annotation (Line(points={{-9,10},{16,10},
          {16,88.8},{26.8,88.8}}, color={0,0,127}));
  connect(buffer_on, switch4.u2)
    annotation (Line(points={{0,112},{0,-32},{30.8,-32}}, color={255,0,255}));
  connect(switch4.y, bou_buf_in.m_flow_in)
    annotation (Line(points={{44.6,-32},{56,-32}}, color={0,0,127}));
  connect(dummyMassFlow.y, switch4.u1) annotation (Line(points={{-9,10},{16,10},
          {16,-27.2},{30.8,-27.2}}, color={0,0,127}));
  connect(dummyZero.y, switch4.u3) annotation (Line(points={{-9,36},{20,36},{20,
          -36.8},{30.8,-36.8}}, color={0,0,127}));
  connect(or1.y, switch1.u2) annotation (Line(points={{-48,63.4},{-48,-8},{-16,
          -8},{-16,-22},{-30.8,-22}}, color={255,0,255}));
  connect(bou_gen_in.m_flow_in, switch1.y) annotation (Line(points={{-56,-32},{
          -54,-32},{-54,-30},{-50,-30},{-50,-22},{-44.6,-22}}, color={0,0,127}));
  connect(bou_gen_in.h_in, switch2.y) annotation (Line(points={{-56,-36},{-50,
          -36},{-50,-56},{-44.6,-56}}, color={0,0,127}));
  connect(dummyZero.y, switch1.u3) annotation (Line(points={{-9,36},{20,36},{20,
          -36},{-16,-36},{-16,-26.8},{-30.8,-26.8}}, color={0,0,127}));
  connect(dummyMassFlow.y, switch1.u1) annotation (Line(points={{-9,10},{16,10},
          {16,-17.2},{-30.8,-17.2}}, color={0,0,127}));
  connect(buffer_on, switch2.u2)
    annotation (Line(points={{0,112},{0,-56},{-30.8,-56}}, color={255,0,255}));
  connect(switch2.u3, dummyEnthalpyDhw.y) annotation (Line(points={{-30.8,-60.8},
          {-16,-60.8},{-16,-72},{-7,-72}}, color={0,0,127}));
  connect(switch2.u1, dummyEnthalpyBuf.y) annotation (Line(points={{-30.8,-51.2},
          {-10.4,-51.2},{-10.4,-52},{9,-52}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-124,-106},{156,-154}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end DemandControl;
