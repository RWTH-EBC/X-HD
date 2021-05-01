within Configurations.Buildings;
model Building

 parameter Real Q_flow_building_max = -5776 "W";
 parameter Real dp_max_building = 900000 "Pa";
 parameter Real m_flow_building = 0.134 "kg/s" annotation(Evaluate=false);

  Configurations.General.Heatratio_calc
                         heatratio_calc
    annotation (Placement(transformation(extent={{-36,36},{-4,48}})));
  Modelica.Blocks.Sources.Constant dotQ_design_demand(k=-Heatdemand.Q_flow_nominal)
    annotation (Placement(transformation(extent={{-82,18},{-62,38}})));
  Modelica.Blocks.Interfaces.RealOutput Q_demand "Heat added to the fluid"
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a building_in(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b building_out(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}})));
  Modelica.Blocks.Interfaces.RealOutput HeatDemand_OnOff
    annotation (Placement(transformation(extent={{98,90},{118,110}})));
  AixLib.Fluid.HeatExchangers.HeaterCooler_u Heatdemand(
    show_T=true,
    final m_flow_nominal=m_flow_building,
    final dp_nominal=dp_max_building,
    final Q_flow_nominal=Q_flow_building_max,
    redeclare final package Medium = Medium)
    annotation (Placement(transformation(extent={{12,-52},{32,-32}})));

  Configurations.DataBase.dotQ_ref_demand_noDHW dotQ_ref_demand_noDHW
    annotation (Placement(transformation(extent={{-82,50},{-62,70}})));
  Modelica.Blocks.Interfaces.RealInput T_amb
    annotation (Placement(transformation(extent={{-120,-26},{-84,10}})));
  Modelica.Blocks.Interfaces.RealInput T_Thresh
    annotation (Placement(transformation(extent={{-120,-84},{-84,-48}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{8,22},{20,34}})));
  Modelica.Blocks.Sources.Constant noDemand_T_thresh(k=0)
    annotation (Placement(transformation(extent={{-34,-20},{-18,-4}})));
  Modelica.Blocks.Logical.Less less
    annotation (Placement(transformation(extent={{-68,-24},{-52,-8}})));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
equation

  connect(heatratio_calc.dotQ_design, dotQ_design_demand.y) annotation (Line(
        points={{-36.96,38.4},{-44.24,38.4},{-44.24,28},{-61,28}}, color={0,0,
          127}));
  connect(Heatdemand.port_a, building_in) annotation (Line(points={{12,-42},{
          -44,-42},{-44,-100},{-100,-100}}, color={0,127,255}));
  connect(Heatdemand.port_b, building_out) annotation (Line(points={{32,-42},{
          64,-42},{64,-100},{100,-100}}, color={0,127,255}));
  connect(Heatdemand.Q_flow, Q_demand) annotation (Line(points={{33,-36},{66,
          -36},{66,0},{106,0}}, color={0,0,127}));
  connect(dotQ_ref_demand_noDHW.y, heatratio_calc.dotQ_actual) annotation (Line(
        points={{-61,60},{-48,60},{-48,45.6},{-36.96,45.6}}, color={0,0,127}));
  connect(heatratio_calc.y_Heater, switch1.u1) annotation (Line(points={{-3.04,42},
          {0,42},{0,32.8},{6.8,32.8}},     color={0,0,127}));
  connect(noDemand_T_thresh.y, switch1.u3) annotation (Line(points={{-17.2,-12},
          {-2,-12},{-2,23.2},{6.8,23.2}}, color={0,0,127}));
  connect(T_amb, less.u1) annotation (Line(points={{-102,-8},{-86,-8},{-86,-16},
          {-69.6,-16}}, color={0,0,127}));
  connect(T_Thresh, less.u2) annotation (Line(points={{-102,-66},{-86,-66},{-86,
          -22.4},{-69.6,-22.4}}, color={0,0,127}));
  connect(less.y, switch1.u2) annotation (Line(points={{-51.2,-16},{-40,-16},{
          -40,28},{6.8,28}}, color={255,0,255}));
  connect(switch1.y, Heatdemand.u) annotation (Line(points={{20.6,28},{14,28},{
          14,-36},{10,-36}}, color={0,0,127}));
  connect(switch1.y, HeatDemand_OnOff) annotation (Line(points={{20.6,28},{60,
          28},{60,100},{108,100}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-60,40},{60,-100}},
          lineColor={0,0,0},
          fillColor={127,89,52},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-60,40},{0,100},{60,40},{-60,40}},
          lineColor={0,0,0},
          fillColor={188,33,38},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Building;
