within VCLib.Components.HeatExchangers.EpsNTU;
model epsNTUIBPSA
  extends AixLib.Fluid.Interfaces.PartialFourPort;

  parameter Modelica.Units.SI.Area A_heat "Wall heat transfer area";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer alphaPri=5000
    "Heat transfer coefficient";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer alphaSec=5000
    "Heat transfer coefficient";
  parameter Modelica.Units.SI.Temperature T_prim_start=373.15
    "Temperature start value, primary side";
  parameter Modelica.Units.SI.Temperature T_sec_start=303.15
    "Temperature start value, secondary side";
  parameter Modelica.Units.SI.MassFlowRate mflow_smooth=1e-4
    "Smoothing interval around zero mass flow rate";
equation
  connect(port_a1, epsNTU.portA_primary) annotation (Line(points={{-100,60},{
          -102,60},{-102,44.4},{-68,44.4}}, color={0,127,255}));
  connect(epsNTU.portB_primary, port_b1) annotation (Line(points={{60,44.4},{76,
          44.4},{76,42},{100,42},{100,60}}, color={255,128,0}));
  connect(epsNTU.portA_secondary, port_a2) annotation (Line(points={{60,-32.4},
          {100,-32.4},{100,-60}}, color={255,128,0}));
  connect(port_b2, epsNTU.portB_secondary) annotation (Line(points={{-100,-60},
          {-68,-60},{-68,-32.4}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-82,80},{78,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-82,46},{78,-46}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-62,58},{58,58}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{70,58},{50,68},{50,48},{70,58}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,0},{-10,-10},{-10,10},{10,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-64,-60},
          rotation=180),
        Line(
          points={{58,-60},{-62,-60}},
          color={0,0,0},
          smooth=Smooth.None)}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end epsNTUIBPSA;
