within VCLib.HeatPumpFlowSheets.HPS_model.Components.Demand;
model DemandCase_v2
  "Model including demand control as well as both demands - Using different storage model (see partial model)"

  /******************************* Parameters *******************************/
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.Pressure p_hydr = 2e5 "Hydraulic pressure in pipes" annotation(Dialog(group = "Demand"));

  //General storage settings
  parameter Modelica.SIunits.Temperature T_stoEnv = 291.15 "Temperature of storage surroundings (assumed 18°C)" annotation(Dialog(group = "General"));
  parameter Integer n_stoLayer = 4 "Number of layers in storage" annotation(Dialog(group = "General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_stoIn = 100 "Internal heat transfer coefficient" annotation(Dialog(group = "General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_stoOut = 10
                                                                     "External heat transfer coefficient" annotation(Dialog(group = "General"));
  // Specific storage settings
  parameter Modelica.SIunits.Length d_buf_sto = 0.5 "Diameter of buffer storage" annotation(Dialog(group = "Buffer Storage"));
  parameter Modelica.SIunits.Length h_buf_sto = 1 "Storage height" annotation(Dialog(group = "Buffer Storage"));
  parameter Modelica.SIunits.Length d_dhw_sto = 0.4 "Diameter of dhw storage" annotation(Dialog(group = "Dhw Storage"));
  parameter Modelica.SIunits.Length h_dhw_sto = 0.8 "Storage height" annotation(Dialog(group = "Dhw Storage"));

  // Heating demand settings
  parameter Modelica.SIunits.MassFlowRate m_flowDem = 0.2 "Mass flow rate in building" annotation(Dialog(group = "Heating"));
  parameter Modelica.SIunits.MassFlowRate m_flowNomDem = 0.2 "Nominal Mass flow rate in building" annotation(Dialog(group = "Heating"));
  parameter Modelica.SIunits.Temperature T_heatingThresh = 288.15 "Heating threshold temperature - assumed to be 15°C" annotation(Dialog(group = "Heating"));
  parameter String filename_Qdem = "D:/cve-cho/sciebo/03-Daten/01-Input_Daten/00-Daten_Hannah/Q_dem_buffer.mat" "Path to mat file with Q_dem data" annotation(Dialog(group = "Heating"));

  // Dhw demand settings
  parameter String filename_DHW = "D:/cve-cho/sciebo/03-Daten/01-Input_Daten/00-Daten_Hannah/DHW_buffer.mat" "Path to mat file with DHW data" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.Temperature T_WaterCold = 288.15 "Cold water temperature (new water)" annotation(Dialog(group = "Demand"));

  /******************************* Variables *******************************/
  Modelica.SIunits.Temperature T_stoTopDhw = dhwDemandCase.T_stoTop "Top temperature in storage";
  Modelica.SIunits.Temperature T_stoBotDhw = dhwDemandCase.T_stoBot "Bottom temperature in storage";
  Modelica.SIunits.Temperature T_stoTopBuf = buildingDemandCase.T_stoTop "Top temperature in storage";
  Modelica.SIunits.Temperature T_stoBotBuf = buildingDemandCase.T_stoBot "Bottom temperature in storage";

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

  Components.Controls.DemandControl demandControl(redeclare package Medium =
        Medium, p_hydr=p_hydr)
    annotation (Placement(transformation(extent={{-52,-2},{-32,18}})));
  Components.Demand.BuildingDemandCase_v2 buildingDemandCase(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    T_stoEnv=T_stoEnv,
    n_stoLayer=n_stoLayer,
    alpha_stoIn=alpha_stoIn,
    alpha_stoOut=alpha_stoOut,
    p_hydr=p_hydr,
    d_sto=d_buf_sto,
    h_sto=h_buf_sto,
    m_flowDem=m_flowDem,
    m_flowNomDem=m_flowNomDem,
    T_heatingThresh=T_heatingThresh,
    filename_Qdem=filename_Qdem)
    annotation (Placement(transformation(extent={{42,-40},{62,-20}})));
  Components.Demand.DhwDemandCase_v2 dhwDemandCase(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    T_stoEnv=T_stoEnv,
    n_stoLayer=n_stoLayer,
    alpha_stoIn=alpha_stoIn,
    alpha_stoOut=alpha_stoOut,
    p_hydr=p_hydr,
    d_sto=d_dhw_sto,
    h_sto=h_dhw_sto,
    filename_DHW=filename_DHW,
    T_WaterCold=T_WaterCold)
    annotation (Placement(transformation(extent={{40,18},{60,38}})));
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient air temperature in K"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-108}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-100})));
equation
  connect(port_b, demandControl.port_b) annotation (Line(points={{-100,-40},{-76,-40},{-76,4},{-52,4}}, color={0,127,255}));
  connect(port_a, demandControl.port_a) annotation (Line(points={{-100,40},{-76,40},{-76,12},{-52,12}}, color={0,127,255}));
  connect(dhw_on, demandControl.dhw_on) annotation (Line(points={{-40,112},{-40,44},{-46,44},{-46,19.2}}, color={255,0,255}));
  connect(demandControl.buffer_on, buffer_on) annotation (Line(points={{-42,19.2},{-42,40},{0,40},{0,112}}, color={255,0,255}));
  connect(demandControl.port_dhw_b, dhwDemandCase.port_a) annotation (Line(points={{-32,16},{-12,16},{-12,32},{40,32}}, color={0,127,255}));
  connect(demandControl.port_dhw_a, dhwDemandCase.port_b) annotation (Line(points={{-32,12},{-4,12},{-4,24},{40,24}}, color={0,127,255}));
  connect(demandControl.port_buf_b, buildingDemandCase.port_a) annotation (Line(points={{-32,4},{-4,4},{-4,-26},{42,-26}}, color={0,127,255}));
  connect(demandControl.port_buf_a, buildingDemandCase.port_b) annotation (Line(points={{-32,0},{-12,0},{-12,-34},{42,-34}}, color={0,127,255}));
  connect(buildingDemandCase.T_amb, T_amb) annotation (Line(points={{41.2,-22},{0,-22},{0,-108}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-126,-120},{130,-192}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end DemandCase_v2;
