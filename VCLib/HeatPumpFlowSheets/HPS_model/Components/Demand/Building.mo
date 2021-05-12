within VCLib.HeatPumpFlowSheets.HPS_model.Components.Demand;
model Building
  "Heating demand in building - Black-box model loading table data, only heating demand (no cooling)"
  extends AixLib.Fluid.Interfaces.PartialTwoPort;
  /******************************* Parameters *******************************/
  parameter Modelica.SIunits.Temperature T_heatingThresh = 288.15 "Heating threshold temperature - assumed to be 15°C";
  parameter String filename_Q_dem = "D:/cve-cho/sciebo/03-Daten/01-Input_Daten/00-Daten_Hannah/Q_dem_buffer.mat" "Path to mat file with Q_dem data";
  parameter Modelica.SIunits.Volume V_pipes = 0.005 "Volume within pipes";
  parameter Modelica.SIunits.MassFlowRate m_flowNom = 0.2 "Nominal mass flow rate within pipes";

  /******************************* Components *******************************/

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow HeatFlowBuilding
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={42,18})));
  Modelica.Blocks.Sources.CombiTimeTable TimeTable_QDem(
    tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    tableName="Q_dem",
    fileName=filename_Q_dem) annotation (Placement(visible=true, transformation(
          extent={{-100,80},{-80,100}},rotation=0)));
  Modelica.Blocks.Interfaces.RealInput T_amb
    "Current ambient air temperature in K"   annotation (
    Placement(visible = true, transformation(origin = {-110, 58}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 58}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  AixLib.Fluid.MixingVolumes.MixingVolume vol(nPorts=2, redeclare package
      Medium =                                                                   Medium,
    m_flow_nominal=m_flowNom,
    V=V_pipes,
    allowFlowReversal=allowFlowReversal)      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={68,18})));
  Modelica.Blocks.Sources.RealExpression dummyZero
    annotation (Placement(transformation(extent={{-64,58},{-44,78}})));
  Modelica.Blocks.Sources.RealExpression dummyTHeatingThresh(y=T_heatingThresh)
    annotation (Placement(transformation(extent={{-122,24},{-102,44}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterZero
    annotation (Placement(transformation(extent={{-64,80},{-44,100}})));
  Modelica.Blocks.Logical.Switch switch_smallerZero
    annotation (Placement(transformation(extent={{-22,80},{-2,100}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-24,10},{-4,30}})));
  Modelica.Blocks.Math.Gain gain_negative(k=-1) annotation (Placement(visible=true,
        transformation(
        origin={15,19},
        extent={{-9,-9},{9,9}},
        rotation=0)));
  Modelica.Blocks.Logical.LessEqual lessThresholdTemperature
    annotation (Placement(transformation(extent={{-82,40},{-62,60}})));
  Modelica.Blocks.Interfaces.BooleanOutput OnOff
    "Defining whether heat demand is needed or not"
    annotation (Placement(transformation(extent={{96,62},{116,82}})));
equation
  connect(HeatFlowBuilding.port, vol.heatPort)
    annotation (Line(points={{52,18},{58,18}},color={191,0,0}));
  connect(port_a, vol.ports[1])
    annotation (Line(points={{-100,0},{66,0},{66,8}},  color={0,127,255}));
  connect(port_b, vol.ports[2])
    annotation (Line(points={{100,0},{70,0},{70,8}},  color={0,127,255}));
  connect(TimeTable_QDem.y[1], greaterZero.u)
    annotation (Line(points={{-79,90},{-66,90}}, color={0,0,127}));
  connect(dummyZero.y, switch_smallerZero.u3) annotation (Line(points={{-43,68},
          {-36,68},{-36,82},{-24,82}}, color={0,0,127}));
  connect(greaterZero.y, switch_smallerZero.u2)
    annotation (Line(points={{-43,90},{-24,90}}, color={255,0,255}));
  connect(TimeTable_QDem.y[1], switch_smallerZero.u1) annotation (Line(points={{
          -79,90},{-72,90},{-72,108},{-38,108},{-38,98},{-24,98}}, color={0,0,127}));
  connect(switch1.y, gain_negative.u) annotation (Line(points={{-3,20},{0,20},{
          0,19},{4.2,19}},
                         color={0,0,127}));
  connect(gain_negative.y, HeatFlowBuilding.Q_flow) annotation (Line(points={{24.9,
          19},{27.45,19},{27.45,18},{32,18}}, color={0,0,127}));
  connect(dummyZero.y, switch1.u3) annotation (Line(points={{-43,68},{-38,68},{
          -38,12},{-26,12}},
                         color={0,0,127}));
  connect(switch_smallerZero.y, switch1.u1) annotation (Line(points={{-1,90},{
          14,90},{14,44},{-32,44},{-32,28},{-26,28}},
                                                   color={0,0,127}));
  connect(lessThresholdTemperature.y, switch1.u2)
    annotation (Line(points={{-61,50},{-38,50},{-38,20},{-26,20}},
                                                 color={255,0,255}));
  connect(lessThresholdTemperature.u2, dummyTHeatingThresh.y) annotation (Line(
        points={{-84,42},{-96,42},{-96,34},{-101,34}},color={0,0,127}));
  connect(T_amb, lessThresholdTemperature.u1) annotation (Line(points={{-110,58},
          {-88,58},{-88,50},{-84,50}}, color={0,0,127}));
  connect(greaterZero.y, OnOff) annotation (Line(points={{-43,90},{-34,90},{-34,
          118},{72,118},{72,72},{106,72}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},
            {100,80}}), graphics={Rectangle(
          extent={{-100,80},{100,-80}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})));
end Building;
