within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.SimpleHeatExchangers;
model Condenser
  import Condenser_funktionsfaehig =
    VCLib.Components.HeatExchangers.HeatExchanger_FVM;

  Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.WallCells.WallElement wallElement[n](
    B=fill(B, n),
    L=fill(L/n, n),
    s=fill(s, n),
    each T_start=0.5*(T_start_hot + T_start_cold))
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));

  replaceable package MediumPri = Modelica.Media.R134a.R134a_ph
    "Primary fluid"
    annotation (Dymola_choicesAllMatching=true);
  replaceable package MediumSec =
      Modelica.Media.Water.WaterIF97OnePhase_ph
    "Secondary fluid";

  parameter Modelica.Units.SI.Length B=0.25 "wide of heat exchanger";
  parameter Modelica.Units.SI.Length H=0.025 "height of heat exchanger";
  parameter Modelica.Units.SI.Length L=0.4 "length of heat exchanger";
  parameter Modelica.Units.SI.Length s=0.005
    "thickness of wall between channels";
  parameter Modelica.Units.SI.Temperature T_amb=300 "ambient temperature";
  parameter Modelica.Units.SI.PressureDifference dp_hot=0
    "pressure drop hot side";
  parameter Modelica.Units.SI.PressureDifference dp_cold=0
    "pressure drop cold side";
parameter Integer n(min=1)=3 "number of discretized elements";
parameter Integer k(min=1)=20 "number of parallel plates";
//Modelica.SIunits.Temperature T_start_wall = 0.5*(T_start_cold + T_start_hot);
  parameter Modelica.Units.SI.Temperature T_start_cold=303.15;
  parameter Modelica.Units.SI.Temperature T_start_hot=373.15;
  parameter Modelica.Units.SI.Pressure p_start_cold=100000;
  parameter Modelica.Units.SI.Pressure p_start_hot=2500000;
  Modelica.Units.SI.HeatFlowRate Q_ges;
  Modelica.Units.SI.HeatFlowRate Q_cold;
  Modelica.Units.SI.HeatFlowRate Q_hot;
  Modelica.Fluid.Interfaces.FluidPort_a port_in_hot(redeclare package Medium =
        MediumPri,h_outflow(start=MediumPri.h_default))
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_in_cold(redeclare package Medium =
        MediumSec,h_outflow(start=MediumSec.h_default))
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_out_hot(redeclare package Medium =
        MediumPri,h_outflow(start=MediumPri.h_default))
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_out_cold(redeclare package Medium =
               MediumSec,h_outflow(start=MediumSec.h_default))
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
    Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.FluidCells.FluidElement_water fluidElement_cold[n](
    redeclare each package Medium = MediumSec,
    B=fill(B, n),
    H=fill(H, n),
    L=fill(L/n, n),
    dp=fill(dp_cold/n, n),
    T_amb=fill(T_amb, n),
    each T_start=T_start_cold,
    each p_start=p_start_cold,
    each k=k)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.FluidCells.FluidElement_refrigerant fluidElement_hot[n](
    redeclare each package Medium = MediumPri,
    B=fill(B, n),
    H=fill(H, n),
    L=fill(L/n, n),
    dp=fill(dp_hot/n, n),
    T_amb=fill(T_amb, n),
    each T_start=T_start_hot,
    each p_start=p_start_hot,
    each k=k)
    annotation (Placement(transformation(extent={{10,-50},{-10,-70}})));

equation
//fluid flowconnect whole channel
for i in 1:(n-1) loop
  connect(fluidElement_hot[i].port_b, fluidElement_hot[i+1].port_a);
  connect(fluidElement_cold[i].port_b, fluidElement_cold[i+1].port_a);
end for;

//heat flow
  for i in 1:n loop
   connect(wallElement[i].heatPort_a, fluidElement_cold[i].heatport);
   connect(wallElement[i].heatPort_b, fluidElement_hot[n-i+1].heatport);
  end for;
  Q_ges = wallElement[1].Q_element + wallElement[2].Q_element + wallElement[3].Q_element + wallElement[4].Q_element + wallElement[5].Q_element;
  Q_cold = wallElement[1].Q_cold + wallElement[2].Q_cold + wallElement[3].Q_cold + wallElement[4].Q_cold + wallElement[5].Q_cold;
  Q_hot = wallElement[1].Q_hot + wallElement[2].Q_hot + wallElement[3].Q_hot + wallElement[4].Q_hot + wallElement[5].Q_hot;
//inlet an outlet
  connect(port_in_hot, fluidElement_hot[1].port_a) annotation (Line(points={{100,-60},
          {10,-60}},                           color={0,127,255}));
  connect(fluidElement_hot[n].port_b, port_out_hot) annotation (Line(points={{-10,-60},
          {-100,-60}},                       color={0,127,255}));
  connect(port_in_cold, fluidElement_cold[1].port_a)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(fluidElement_cold[n].port_b, port_out_cold)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-88,-6},{88,-88}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,90},{88,4}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,50},{40,50}},
          color={28,108,200},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{38,-46},{-42,-46}},
          color={238,46,47},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Open})}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #000000\">Model of a simple heat exchanger using finite volume method</span></h4>
</html>"));
end Condenser;
