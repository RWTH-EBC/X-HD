within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.WallCells;
model WallElement "wall elemnt made of copper"
  import Condenser_funktionsfaehig =
    VCLib.Components.HeatExchangers.HeatExchanger_FVM;

extends
    Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.Properties.WallMaterial(
    rho=8920 "Density of wall material",
    lambda=400 "Thermal conductivity of wall",
    cP=385 "Specific heat capacity of wall",
    eps=0.9 "Emissivity of inner wall surface");

final constant Real pi = Modelica.Constants.pi;
  parameter Modelica.Units.SI.Length B "width of the element";
  parameter Modelica.Units.SI.Length s "wall element thickness";
  parameter Modelica.Units.SI.Length L "length";
  parameter Modelica.Units.SI.Temperature T_start;
  Modelica.Units.SI.Length d "hydraulic diameter";
  Modelica.Units.SI.Area A_heat "wall surface that exchanges heat";
  Modelica.Units.SI.Volume V "volume of the wall";
  Modelica.Units.SI.Temperature T(start=T_start, fixed=true)
    "temperature of the wall";
  Modelica.Units.SI.TemperatureSlope der_T(start=0)
    "derivative of the wall's temperature";
//Modelica.SIunits.HeatFlowRate Q_flow_1 "cold side";
//Modelica.SIunits.HeatFlowRate Q_flow_2 "hot side";
  Modelica.Units.SI.HeatFlowRate Q_hot "heat flow rate of hot side";
  Modelica.Units.SI.HeatFlowRate Q_cold "heat flow rate of cold side";
  Modelica.Units.SI.HeatFlowRate Q_element "entire amount of exchanged heat";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_a "cold side, has to be negative"
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort_b "hot side, has to be positive"
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
equation
  der(T) = der_T;
  A_heat = B * L;
  V = B*s*L;
  d= s/2;

  //Energy balance
  V * rho * cP * der_T = heatPort_a.Q_flow + heatPort_b.Q_flow;
  //heat transport Q
  heatPort_a.Q_flow = - A_heat *(T - heatPort_a.T) * lambda / d;
  heatPort_b.Q_flow = A_heat * (heatPort_b.T - T) * lambda / d;
  Q_hot = heatPort_b.Q_flow;
  Q_cold = -heatPort_a.Q_flow;
  Q_element = heatPort_b.Q_flow + heatPort_a.Q_flow;
  //Energy balance
  //V * rho * cP * der_T = Q_flow_2 - Q_flow_1;
  //heat transport Q
  //Q_flow_1 = A_heat *(T - heatPort_a.T) * lambda / d;
  //Q_flow_2 = A_heat * (heatPort_b.T - T) * lambda / d;
  //Q_flow_1 = - heatPort_a.Q_flow;
  //Q_flow_2 = heatPort_b.Q_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WallElement;
