within VCLib.HeatPumpFlowSheets.HPS_model.Components.Generation;
package Partials
  partial model PartialGenerationCase
    "Partial generation case model containing heating rod and heat pump"

    /******************************* Parameters *******************************/
    replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium "Medium in the component"
        annotation (choicesAllMatching = true);

    parameter Boolean allowFlowReversal = true
      "= false to simplify equations, assuming, but not enforcing, no flow reversal"
      annotation(Dialog(tab="Assumptions"), Evaluate=true);
    parameter Modelica.SIunits.Pressure p_hydr = 2e5 "Hydraulic pressure in pipes" annotation(Dialog(group = "Demand"));

    // Generation
    parameter Modelica.SIunits.MassFlowRate m_flowGen = 0.25 "Mass flow rate through heat pump condenser" annotation(Dialog(group = "Generation"));
    parameter Modelica.SIunits.MassFlowRate m_flowNomGen = 0.2 "Nominal mass flow rate used in generation" annotation(Dialog(group = "Generation"));

    // Heating Rod settings
    parameter Real eta_hr = 0.97 "Heating rod efficiency" annotation(Dialog(group = "Heating Rod"));
    parameter Modelica.SIunits.Power P_elNomHr = 5000 "Nominal heating power of heating rod" annotation(Dialog(group = "Heating Rod"));

    /******************************* Variables *******************************/

    Modelica.SIunits.Power P_el_hr = heatingRod.P_el "Electric power demand of heating rod";

    /******************************* Components *******************************/

    Modelica.Fluid.Interfaces.FluidPort_a port_a(
      redeclare package Medium = Medium,
       m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
       h_outflow(start = Medium.h_default, nominal = Medium.h_default)) "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(
      redeclare package Medium = Medium,
      m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
       h_outflow(start = Medium.h_default, nominal = Medium.h_default)) "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{110,30},{90,50}})));

    Modelica.Blocks.Interfaces.BooleanInput hr_on "Heating rod activated"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-10,110})));
    Modelica.Blocks.Interfaces.BooleanInput hp_on "Heat pump activated"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-50,110})));
    Components.Generation.Heater.HeatingRod heatingRod(
      redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal,
      eta=eta_hr,
      P_elNom=P_elNomHr,
      m_flowNom=m_flowNomGen)
      annotation (Placement(transformation(extent={{14,32},{34,48}})));
    AixLib.Fluid.Sensors.TemperatureTwoPort TStoReturn(redeclare package Medium=Medium,allowFlowReversal=
          allowFlowReversal, m_flow_nominal=m_flowNomGen) annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={70,-40})));
    AixLib.Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium,nPorts=1, p=p_hydr) annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={34,-40})));
    Components.Controls.HeatpumpFlowControl heatpumpFlowControl(m_flowGen=
          m_flowGen)
      annotation (Placement(transformation(extent={{-40,58},{-20,74}})));
    AixLib.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium,
      use_m_flow_in=true,
      use_T_in=true,
      nPorts=1) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-30,-40})));
    Modelica.Blocks.Interfaces.RealInput T_amb
      "Current ambient air temperature in K"
      annotation (Placement(transformation(extent={{-130,26},{-90,66}})));
  equation

    connect(heatingRod.port_b, port_b) annotation (Line(points={{34,40},{100,40}}, color={0,127,255}));
    connect(heatingRod.OnOff, hr_on) annotation (Line(points={{13.4,45.4},{-10,45.4},{-10,110}}, color={255,0,255}));
    connect(TStoReturn.port_a, port_a) annotation (Line(points={{80,-40},{100,-40}}, color={0,127,255}));
    connect(bou.ports[1], TStoReturn.port_b) annotation (Line(points={{44,-40},{60,-40}}, color={0,127,255}));
    connect(hp_on, heatpumpFlowControl.Hp_OnOff) annotation (Line(points={{-50,110},{-50,82},{-35,82},{-35,75}}, color={255,0,255}));
    connect(hr_on, heatpumpFlowControl.Hr_OnOff) annotation (Line(points={{-10,110},{-10,82},{-24.8,82},{-24.8,75}}, color={255,0,255}));
    connect(boundary.T_in, TStoReturn.T) annotation (Line(points={{-34,-52},{-34,-64},{70,-64},{70,-51}}, color={0,0,127}));
    connect(heatpumpFlowControl.m_flowHp, boundary.m_flow_in)
      annotation (Line(points={{-30,57.4},{-30,4},{-4,4},{-4,-78},{-38,-78},{-38,-52}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-122,-102},{112,-176}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
  end PartialGenerationCase;

  partial model PartialGenerationCase_FixSupply
    "Generation case model containing heating rod and heat pump"
    extends HPS_model.Components.Generation.Partials.PartialGenerationCase;

    /******************************* Components *******************************/
    Modelica.Blocks.Interfaces.RealInput T_supSet "Supply set temperature in K"
      annotation (Placement(transformation(extent={{-130,-12},{-90,28}})));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-122,-102},{112,-176}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
  end PartialGenerationCase_FixSupply;
end Partials;
