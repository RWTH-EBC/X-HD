within VCLib.HeatPumpFlowSheets.HPS_model.Components.Demand;
partial model PartialDemandCase_v2
  "Partial model for single demands - changed storage model since parameters weren't tuneable in FMU anymore"

  /******************************* Parameters *******************************/
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Storage settings
  parameter Modelica.SIunits.Temperature T_stoEnv = 291.15 "Temperature of storage surroundings (assumed 18°C)" annotation(Dialog(group = "Storage"));
  parameter Integer n_stoLayer = 4 "Number of layers in storage" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.Length d_sto = 0.5 "Storage diameter" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.Length h_sto = 1 "Storage height" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_stoIn = 100 "Internal heat transfer coefficient" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_stoOut = 10
                                                                     "External heat transfer coefficient" annotation(Dialog(group = "Storage"));

  parameter Modelica.SIunits.Pressure p_hydr = 2e5 "Hydraulic pressure in pipes" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.Temperature T_start = 293.15 "Storage start temperature";

  /******************************* Variables *******************************/
  Modelica.SIunits.Temperature T_stoTop "Top temperature in storage";
  Modelica.SIunits.Temperature T_stoBot "Bottom temperature in storage";

  /******************************* Components *******************************/

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium,
     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-50},{-110,-30}})));

  HPS_model.Components.Storage.Storage_Case storage(
    redeclare package Medium = Medium,
    n_stoLayer=n_stoLayer,
    d_sto=d_sto,
    h_sto=h_sto,
    alpha_stoIn=alpha_stoIn,
    alpha_stoOut=alpha_stoOut)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  //     layer(each T = T_start)

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        T_stoEnv)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={33,1})));
equation

  // Get temperatures in storage
  T_stoBot = storage.T_stoBot;
  T_stoTop = storage.T_stoTop;

  connect(storage.heatPort, fixedTemperature.port) annotation (Line(points={{10,0},{
          24,0},{24,1},{26,1}},                                                                          color={191,0,0}));
  connect(port_b, storage.port_b_heatGenerator) annotation (Line(points={{-100,-40},
          {-54,-40},{-54,-4},{-10,-4}},                                                                            color={0,127,255}));
  connect(port_a, storage.port_a_heatGenerator) annotation (Line(points={{-100,40},
          {-54,40},{-54,4},{-10,4}},                                                                               color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-126,-100},{120,-176}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialDemandCase_v2;
