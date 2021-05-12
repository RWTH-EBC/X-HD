within VCLib.HeatPumpFlowSheets.HPS_model.Components.Storage;
model Bouyancy
  outer HPS_model.Components.BaseClasses.BaseParameters.BaseParameters
    baseParameters "System properties";
  parameter Modelica.SIunits.Area A = 1;
  parameter Modelica.SIunits.RelativePressureCoefficient beta = 0.00035;
  parameter Modelica.SIunits.Length dx = 0.2;
  parameter Real kappa = 0.4;
  Modelica.SIunits.TemperatureDifference dT;
  Modelica.SIunits.ThermalConductivity lambda_eff;
  parameter Modelica.SIunits.Acceleration g = baseParameters.g;
  parameter Modelica.SIunits.SpecificHeatCapacity cp = baseParameters.cp_Water;
  parameter Modelica.SIunits.ThermalConductivity lambda = baseParameters.lambda_Water;
  parameter Modelica.SIunits.Density rho = baseParameters.rho_Water;
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(Placement(transformation(extent = {{-16, 86}, {4, 106}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(Placement(transformation(extent = {{-16, -104}, {4, -84}})));
equation
  dT = port_a.T - port_b.T;
  if dT > 0 then
    lambda_eff = lambda;
  else
    lambda_eff = lambda + 2 / 3 * rho * cp * kappa * dx ^ 2 * sqrt(abs(-g * beta * dT / dx));
  end if;
  port_a.Q_flow = lambda_eff * A / dx * dT;
  port_a.Q_flow + port_b.Q_flow = 0;
  annotation(Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),           Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">Lecture Information</span></h4>
<p>Introduced in lecture: V07 - Speicher </p>
</html>"));
end Bouyancy;
