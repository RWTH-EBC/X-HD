within VCLib.HeatPumpFlowSheets.HPS_model.Components.Demand;
model Dhw "Dhw demand in building - Black-box model loading table data"
  extends AixLib.Fluid.Interfaces.PartialTwoPort;
  /******************************* Parameters *******************************/
protected
  parameter Modelica.SIunits.Density d_Water = 1000 "Density of liquid water";
  parameter Modelica.SIunits.Time sec_hour = 3600 "Seconds per hour";
public
  parameter String filename_DHW = "D:/cve-cho/sciebo/03-Daten/01-Input_Daten/00-Daten_Hannah/DHW_buffer.mat" "Path to mat file with DHW data";
  parameter Modelica.SIunits.Temperature T_WaterCold = 288.15 "Cold water temperature (new water)";
  parameter Modelica.SIunits.Pressure p_hydr = 2e5 "Hydraulic pressure in pipes";

  /******************************* Components *******************************/

  Modelica.Blocks.Sources.CombiTimeTable TimeTable_DHW(
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    tableName="DHW",
    fileName=filename_DHW) annotation (Placement(visible=true, transformation(
          extent={{-100,34},{-80,54}}, rotation=0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-50,34},{-30,54}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-10,34},{10,54}})));
  Modelica.Blocks.Math.Gain massFlowRate(k=d_Water/sec_hour/1000)
    "Transform Volume l to massflowrate"
    annotation (Placement(transformation(extent={{-50,62},{-30,82}})));
  Modelica.Blocks.Sources.RealExpression dummyZero
    annotation (Placement(transformation(extent={{-50,6},{-30,26}})));
  AixLib.Fluid.Sources.MassFlowSource_T boundary_source(redeclare package
      Medium =                                                                   Medium,
    nPorts=1,
    use_m_flow_in=true,
    T=T_WaterCold)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  AixLib.Fluid.Sources.Boundary_ph bou_sink(redeclare package Medium=Medium, nPorts=1, p=p_hydr)
    annotation (Placement(transformation(extent={{-56,-10},{-76,10}})));
equation
  connect(TimeTable_DHW.y[1], greaterThreshold.u)
    annotation (Line(points={{-79,44},{-52,44}}, color={0,0,127}));
  connect(greaterThreshold.y,switch1. u2)
    annotation (Line(points={{-29,44},{-12,44}}, color={255,0,255}));
  connect(TimeTable_DHW.y[1], massFlowRate.u) annotation (Line(points={{-79,44},
          {-66,44},{-66,72},{-52,72}}, color={0,0,127}));
  connect(massFlowRate.y, switch1.u1) annotation (Line(points={{-29,72},{-20,72},
          {-20,52},{-12,52}}, color={0,0,127}));
  connect(dummyZero.y, switch1.u3) annotation (Line(points={{-29,16},{-22,16},{-22,
          36},{-12,36}}, color={0,0,127}));
  connect(port_a, bou_sink.ports[1])
    annotation (Line(points={{-100,0},{-76,0}}, color={0,127,255}));
  connect(boundary_source.ports[1], port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(switch1.y, boundary_source.m_flow_in)
    annotation (Line(points={{11,44},{26,44},{26,8},{58,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -80},{100,80}}), graphics={
                                  Rectangle(
          extent={{-100,80},{100,-80}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})));
end Dhw;
