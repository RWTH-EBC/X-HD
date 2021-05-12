within VCLib.HeatPumpFlowSheets.HPS_model.Components.Demand;
model DhwDemandCase_v2
  "Dhw demand system - using different storage model (see partial model)"
  extends PartialDemandCase_v2;

  /******************************* Parameters *******************************/

  parameter String filename_DHW = "D:/cve-cho/sciebo/03-Daten/01-Input_Daten/00-Daten_Hannah/DHW_buffer.mat" "Path to mat file with DHW data" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.Temperature T_WaterCold = 288.15 "Cold water temperature (new water)" annotation(Dialog(group = "Demand"));

  /******************************* Components *******************************/

  Dhw dhw(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    filename_DHW=filename_DHW,
    T_WaterCold=T_WaterCold,
    p_hydr=p_hydr)
    annotation (Placement(transformation(extent={{44,22},{64,38}})));
equation
  connect(storage.port_b_consumer, dhw.port_a) annotation (Line(points={{0,10},{0,30},{44,30}}, color={0,127,255}));
  connect(storage.port_a_consumer, dhw.port_b) annotation (Line(points={{0,-10},{0,-30},{80,-30},{80,30},{64,30}}, color={0,127,255}));
end DhwDemandCase_v2;
