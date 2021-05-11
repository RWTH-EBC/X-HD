within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.HeatTransfers;
model HeatTransfer_water
  import Condenser_funktionsfaehig =
    VCLib.Components.HeatExchangers.HeatExchanger_FVM;

  //Model for calculation of Nusseltnumber in VDI heat atlas, chapter G4 "Längsumströmte ebene Wände" written by Volker Gnielinski
 //Inlet, outlet

final constant Real small=ModelicaServices.Machine.small;

extends
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer;

outer Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.Properties.ElementProperties properties;

  Modelica.Units.SI.ReynoldsNumber Re(start=973591);
  Modelica.Units.SI.NusseltNumber Nu(start=1293);
  Modelica.Units.SI.Velocity u(start=41);
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha(start=58.4);
 Real ksi(start=0.015);

// Modelica.SIunits.Temperature T_wall=55 "Temperature wall surface";
// Integer n;

//  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatport;

equation

//  D = (2* B * H) / (B + H);
//  A_heat = (B + H) * L;
//  A_square = B * H;
//  V = A_square * L;
  u = abs(properties.m_in/properties.rho/properties.A_square);

 if noEvent(u<=small) then
    Re = small;
    ksi = small;
    Nu = small;
    alpha = small;
else
   Re = max(u*properties.D*properties.rho/properties.eta, small);
   ksi = 8 * 0.0296 * (Re)^(-0.2);
   Nu = (ksi/8*Re*properties.Pr)/(1+12.7*sqrt(ksi/8)*(properties.Pr^(2/3)-1));
   alpha = Nu *properties.lambda/properties.D;
end if;

heatPorts[1].Q_flow = -alpha * properties.A_heat *(properties.T - heatPorts[1].T);

//record
//properties.A_square = A_square;
//properties.A_heat = A_heat;
//properties.V = V;
//properties.B = B;
//properties.L = L;
//properties.H = H;
//properties.D = D;
//properties.n = n;
   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<pre><span style=\"color: #006400;\">Model&nbsp;for&nbsp;calculation&nbsp;of&nbsp;Nusseltnumber&nbsp;in&nbsp;VDI&nbsp;heat&nbsp;atlas,&nbsp;chapter&nbsp;G4&nbsp;&quot;L&auml;ngsumstr&ouml;mte&nbsp;ebene&nbsp;W&auml;nde&quot;&nbsp;written&nbsp;by&nbsp;Volker&nbsp;Gnielinski</span></pre>
</html>"));
end HeatTransfer_water;
