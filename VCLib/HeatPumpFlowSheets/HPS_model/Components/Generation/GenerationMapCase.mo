within VCLib.HeatPumpFlowSheets.HPS_model.Components.Generation;
model GenerationMapCase
  extends Partials.PartialGenerationCase_FixSupply(boundary(nPorts=1));

  /******************************* Parameters *******************************/

  parameter String filename = "D:/cve-cho/sciebo/03-Daten/08-Kennfeld/Heatpumps.sdf" "Path to sdf file" annotation(Dialog(group="Heat Pump"));
  parameter String dataset_COP = "/Refigerants/R410A/COP" "Path within svg file to COP dataset" annotation(Dialog(group="Heat Pump"));
  parameter String dataset_Qflow = "/Refigerants/R410A/Q_dot_heating" "Path within svg file to Qflow dataset" annotation(Dialog(group="Heat Pump"));
  parameter String dataset_QflowRef = "/Refigerants/R410A/Q_dot_ref" "Path within svg file to QflowRef value" annotation(Dialog(group="Heat Pump"));

  parameter Modelica.SIunits.Power Q_flowNomHp = 5000 "Nominal heating power of heat pump" annotation(Dialog(group="Heat Pump"));
  parameter Real ratio_Qmin = 0.5 "Ratio of minimum partial load heating power to nominal heating power of heat pump" annotation(Dialog(group="Heat Pump"));
  parameter Modelica.SIunits.Volume V_con = 0.001 "Volume of condenser" annotation(Dialog(group="Heat Pump"));

  /******************************* Variables *******************************/

  Modelica.SIunits.Power P_el "Total power demand of heat generation";

  /******************************* Components *******************************/

  Components.Generation.Heater.SimpleHeatPump_Map_OneFlow heatPump(
    redeclare package Medium = Medium,
    V_con=V_con,
    filename=filename,
    dataset_COP=dataset_COP,
    dataset_Qflow=dataset_Qflow,
    dataset_QflowRef=dataset_QflowRef,
    ratio_Qmin=ratio_Qmin,
    allowFlowReversal=allowFlowReversal,
    Q_flowNom=Q_flowNomHp,
    m_flowNom=m_flowNomGen)
    annotation (Placement(transformation(extent={{-78,16},{-58,36}})));
equation

  P_el = P_el_hr + heatPump.P_el*1.25;

  connect(hp_on, heatpumpFlowControl.Hp_OnOff) annotation (Line(points={{-50,110},{-50,82},{-35,82},{-35,75}}, color={255,0,255}));
  connect(T_supSet, heatPump.T_supplySet) annotation (Line(points={{-110,8},{-98,
          8},{-98,10},{-86,10},{-86,24},{-78,24}}, color={0,0,127}));
  connect(T_amb, heatPump.T_amb) annotation (Line(points={{-110,46},{-86,46},{-86,
          30},{-78,30}}, color={0,0,127}));
  connect(boundary.ports[1], heatPump.port_a) annotation (Line(points={{-30,-30},
          {-32,-30},{-32,-10},{-50,-10},{-50,20},{-58,20}}, color={0,127,255}));
  connect(heatPump.port_b, heatingRod.port_a) annotation (Line(points={{-58,32},
          {-42,32},{-42,40},{14,40}}, color={0,127,255}));
  connect(hp_on, heatPump.OnOff) annotation (Line(points={{-50,110},{-50,82},{-68,
          82},{-68,36}}, color={255,0,255}));
end GenerationMapCase;
