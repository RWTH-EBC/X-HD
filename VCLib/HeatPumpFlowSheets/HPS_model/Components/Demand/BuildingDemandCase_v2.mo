within VCLib.HeatPumpFlowSheets.HPS_model.Components.Demand;
model BuildingDemandCase_v2
  "Demand side model for building heating using storage - using different storage model (see partial)"
  extends HPS_model.Components.Demand.PartialDemandCase_v2;

  /******************************* Parameters *******************************/

  parameter Modelica.SIunits.MassFlowRate m_flowDem = 0.2 "Mass flow rate in building" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.MassFlowRate m_flowNomDem = 0.2 "Nominal Mass flow rate in building" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.Temperature T_heatingThresh = 288.15 "Heating threshold temperature - assumed to be 15°C" annotation(Dialog(group = "Demand"));
  parameter String filename_Qdem = "D:/cve-cho/sciebo/03-Daten/01-Input_Daten/00-Daten_Hannah/Q_dem_buffer.mat" "Path to mat file with Q_dem data" annotation(Dialog(group = "Demand"));

  /******************************* Components *******************************/

  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient air temperature in K"
    annotation (Placement(transformation(extent={{-128,60},{-88,100}}),
        iconTransformation(extent={{-128,60},{-88,100}})));
  Components.Demand.Building building(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    T_heatingThresh=T_heatingThresh,
    filename_Q_dem=filename_Qdem,
    m_flowNom=m_flowNomDem)
    annotation (Placement(transformation(extent={{22,36},{42,52}})));
  AixLib.Fluid.Sources.MassFlowSource_T boundary1(
                                                 redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-32})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={42,-88})));
  Modelica.Blocks.Sources.RealExpression dummyZero
    annotation (Placement(transformation(extent={{94,-108},{74,-88}})));
  Modelica.Blocks.Sources.RealExpression dummyMassFlowDemand(y=m_flowDem)
    annotation (Placement(transformation(extent={{94,-92},{74,-72}})));
  AixLib.Fluid.Sources.Boundary_pT bou1(
                                       redeclare package Medium = Medium,nPorts=1, p=p_hydr) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={84,-26})));
  AixLib.Fluid.Sensors.TemperatureTwoPort TBuildingReturn(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flowNomDem) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={84,8})));
equation
  connect(storage.port_a_consumer, boundary1.ports[1]) annotation (Line(points={{0,-10},
          {0,-22}},                                                                               color={0,127,255}));
  connect(boundary1.m_flow_in,switch1. y)
    annotation (Line(points={{-8,-44},{-8,-88},{31,-88}},
                                                        color={0,0,127}));
  connect(building.OnOff,switch1. u2) annotation (Line(points={{42.6,51.2},{136,51.2},{136,-88},{54,-88}},
                                     color={255,0,255}));
  connect(dummyMassFlowDemand.y,switch1. u1) annotation (Line(points={{73,-82},{
          64,-82},{64,-80},{54,-80}}, color={0,0,127}));
  connect(switch1.u3,dummyZero. y)
    annotation (Line(points={{54,-96},{73,-96},{73,-98}}, color={0,0,127}));
  connect(building.port_b,TBuildingReturn. port_a)
    annotation (Line(points={{42,44},{84,44},{84,18}}, color={0,127,255}));
  connect(bou1.ports[1],TBuildingReturn. port_b)
    annotation (Line(points={{84,-16},{84,-2}}, color={0,127,255}));
  connect(TBuildingReturn.T, boundary1.T_in) annotation (Line(points={{95,8},{
          102,8},{102,-56},{-4,-56},{-4,-44}},                                                                     color={0,0,127}));
  connect(storage.port_b_consumer, building.port_a) annotation (Line(points={{0,10},{0,44},{22,44}}, color={0,127,255}));
  connect(T_amb, building.T_amb) annotation (Line(points={{-108,80},{0,80},{0,49.8},{21,49.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end BuildingDemandCase_v2;
