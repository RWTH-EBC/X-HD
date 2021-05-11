within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.HeatTransfers;
model HeatTransfer_refrigerant_advanced
  import Condenser_funktionsfaehig =
    VCLib.Components.HeatExchangers.HeatExchanger_FVM;

  //Model for calculation of the heat transfer coefficient using Kandlikar
 //Inlet, outlet
  final constant Real small=ModelicaServices.Machine.small;
extends
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer;

outer Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.Properties.ElementProperties properties;
// Modelica.SIunits.Velocity u(start=41)
//                                      "velocity of fluid at pipe inlet";

 //1 phase
  Modelica.Units.SI.ReynoldsNumber Re_1(start=973591)
    "Reynolds number of fluid for 1 phase";
  Modelica.Units.SI.NusseltNumber Nu_1(start=1293)
    "Nusselt number of fluid for 1 phase";
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha_1(start=200)
    "heat transfer coefficient for 1 phase";
 Real ksi_1(start=0.015)
                        "dummy value for calculatig alpha_1";
  Modelica.Units.SI.ReynoldsNumber Re_10(start=973591)
    "Reynolds number of fluid for 2 phases";
  Modelica.Units.SI.NusseltNumber Nu_10(start=1293)
    "Nusselt number of fluid for 2 phases";
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha_10(start=200)
    "heat transfer coefficient for 2 phases";
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha_2(start=200)
    "heat transfer coefficient for 2 phases";
 Real ksi_10(start=0.015)
                        "dummy value for calculating alpha_2";
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha(start=200)
    "real heat transfer coefficient, depends on phase";
 Integer phase(start=1)       "number of phases";
// Modelica.SIunits.Density rho;
 Real Co(start=0.01) "convection number";
 Real Bo(start=80) "boiling number";
 Real y(start=973591)
                     "dummy value for smoothing nusselt number";

equation
  phase = properties.phase;
 // u = abs(properties.m_in/(rho*properties.A_square));
 // rho = max(properties.rho, small);

 Re_1 = max(properties.m_in*properties.D/(properties.A_square * (properties.eta+small)), small);
 Re_10 = max(properties.m_in*properties.D*properties.dl/((properties.rho+small) * properties.A_square *(properties.eta0+small)), small);
 //pipe friction
 ksi_1 = (1.8 * Modelica.Math.log10(Re_1+small) - 1.5)^(-2);
 ksi_10 = (1.8 * Modelica.Math.log10(Re_10+small) - 1.5)^(-2);

 //convection and boiling number for calculating the heat transfer coefficient in the two phase region (Kandlikar)
 Co = max((((1/(properties.x_void+small)) -1)^0.8 * ((properties.dv+small)/(properties.dl+small))^0.5), small);
 Bo = properties.A_heat/properties.A_square;

  // if noEvent(Re_1<=small) then
 //    Nu_1 = small;
 //    Nu_10 = small;
 //  elseif noEvent(Re_1<2300) then
 //    Nu_1=(4.861^3 + (1.841* (Re_1 * properties.Pr * properties.D/properties.L)^(1/3))^3)^(1/3);
 //    Nu_10 = (4.861^3 + (1.841* (Re_10 * properties.Pr0 * properties.D/properties.L)^(1/3))^3)^(1/3)                                                                                                   "laminar";
 //  elseif noEvent(Re_1>4e4) then
 //    Nu_1 = ((ksi_1/8)*Re_1*properties.Pr) / (1 + 12.7*sqrt(ksi_1/8)*(properties.Pr^(2/3)-1)) * (1+(properties.D/properties.L)^(2/3))                                                                                                                                    "turbulent";
 //    Nu_10 = ((ksi_10/8)*Re_10*properties.Pr0) / (1 + 12.7*sqrt(ksi_10/8)*(properties.Pr0^(2/3)-1)) * (1+(properties.D/properties.L)^(2/3));
 //  else
  //   Nu_1 = ((4.86 + (0.061*(Re_1 * properties.Pr * properties.D/properties.L)^1.2)/(1+0.091*(Re_1 * properties.Pr* properties.D/properties.L)^0.17))^3 + (7.55 + (0.024* (Re_1 * properties.Pr * properties.D/properties.L)^1.14)/(1+0.0358*(Re_1 * properties.Pr * properties.D/properties.L)^0.64 * (properties.Pr)^0.17))^3 + ((2/(1+22*properties.Pr))^(1/6) * (Re_1 * properties.Pr * properties.D/properties.L)^0.5)^3)^(1/3);
  //   Nu_10 = ((4.86 + (0.061*(Re_10 * properties.Pr0 * properties.D/properties.L)^1.2)/(1+0.091*(Re_10 * properties.Pr0* properties.D/properties.L)^0.17))^3 + (7.55 + (0.024* (Re_10 * properties.Pr0 * properties.D/properties.L)^1.14)/(1+0.0358*(Re_10 * properties.Pr0 * properties.D/properties.L)^0.64 * (properties.Pr0+small)^0.17))^3 + ((2/(1+22*properties.Pr0))^(1/6) * (Re_10 * properties.Pr0 * properties.D/properties.L)^0.5)^3)^(1/3);
  // end if;

  //calculating Nusselt number for the laminar, the turbulent and the mixing region
   if noEvent(Re_1<2299.99) then
     y = Re_1;
     Nu_1 = Modelica.Fluid.Utilities.regStep(y,(4.861^3 + (1.841* (Re_1 * properties.Pr * properties.D/properties.L)^(1/3))^3)^(1/3), small, small);
     Nu_10 = Modelica.Fluid.Utilities.regStep(y, (4.861^3 + (1.841* (Re_10 * properties.Pr0 * properties.D/properties.L)^(1/3))^3)^(1/3), small, small);
   elseif noEvent(Re_1>3.999e4) then
     y = Re_1 - 4e4;
     Nu_1 = Modelica.Fluid.Utilities.regStep(y,((ksi_1/8)*Re_1*properties.Pr) / (1 + 12.7*sqrt(ksi_1/8)*(properties.Pr^(2/3)-1)) * (1+(properties.D/properties.L)^(2/3)), ((4.86 + (0.061*(Re_1 * properties.Pr * properties.D/properties.L)^1.2)/(1+0.091*(Re_1 * properties.Pr* properties.D/properties.L)^0.17))^3 + (7.55 + (0.024* (Re_1 * properties.Pr * properties.D/properties.L)^1.14)/(1+0.0358*(Re_1 * properties.Pr * properties.D/properties.L)^0.64 * (properties.Pr)^0.17))^3 + ((2/(1+22*properties.Pr))^(1/6) * (Re_1 * properties.Pr * properties.D/properties.L)^0.5)^3)^(1/3),small);
     Nu_10 = Modelica.Fluid.Utilities.regStep(y,((ksi_10/8)*Re_10*properties.Pr0) / (1 + 12.7*sqrt(ksi_10/8)*(properties.Pr0^(2/3)-1)) * (1+(properties.D/properties.L)^(2/3)),((4.86 + (0.061*(Re_10 * properties.Pr0 * properties.D/properties.L)^1.2)/(1+0.091*(Re_10 * properties.Pr0* properties.D/properties.L)^0.17))^3 + (7.55 + (0.024* (Re_10 * properties.Pr0 * properties.D/properties.L)^1.14)/(1+0.0358*(Re_10 * properties.Pr0 * properties.D/properties.L)^0.64 * (properties.Pr0+small)^0.17))^3 + ((2/(1+22*properties.Pr0))^(1/6) * (Re_10 * properties.Pr0 * properties.D/properties.L)^0.5)^3)^(1/3),small);
   else
     y = Re_1-2300;
     Nu_1 = Modelica.Fluid.Utilities.regStep(y,((4.86 + (0.061*(Re_1 * properties.Pr * properties.D/properties.L)^1.2)/(1+0.091*(Re_1 * properties.Pr* properties.D/properties.L)^0.17))^3 + (7.55 + (0.024* (Re_1 * properties.Pr * properties.D/properties.L)^1.14)/(1+0.0358*(Re_1 * properties.Pr * properties.D/properties.L)^0.64 * (properties.Pr)^0.17))^3 + ((2/(1+22*properties.Pr))^(1/6) * (Re_1 * properties.Pr * properties.D/properties.L)^0.5)^3)^(1/3), (4.861^3 + (1.841* (Re_1 * properties.Pr * properties.D/properties.L)^(1/3))^3)^(1/3), small);
     Nu_10 = Modelica.Fluid.Utilities.regStep(y,((4.86 + (0.061*(Re_10 * properties.Pr0 * properties.D/properties.L)^1.2)/(1+0.091*(Re_10 * properties.Pr0* properties.D/properties.L)^0.17))^3 + (7.55 + (0.024* (Re_10 * properties.Pr0 * properties.D/properties.L)^1.14)/(1+0.0358*(Re_10 * properties.Pr0 * properties.D/properties.L)^0.64 * (properties.Pr0+small)^0.17))^3 + ((2/(1+22*properties.Pr0))^(1/6) * (Re_10 * properties.Pr0 * properties.D/properties.L)^0.5)^3)^(1/3),(4.861^3 + (1.841* (Re_10 * properties.Pr0 * properties.D/properties.L)^(1/3))^3)^(1/3), small);
   end if;

   //current alpha for two-phase (alpha_2) and one-phase flow (alpha_1). alpha_10 is a dummy value for calculating alpha_2 if the fluid occured as a liquid phase
 if noEvent((properties.m_in)<=small) then
    alpha_2 = small;
    alpha_1 = small;
    alpha_10 = small;
 else
   alpha_1 = Nu_1 *properties.lambda/properties.D;
   alpha_10 = Nu_10 * properties.lambda0/properties.D;
   alpha_2 =  max(((0.6683 * Co^(-0.2) * alpha_10 + 1058 * Bo^0.7 * 1.63 *alpha_10)*(1-properties.x_void+small)^0.8), ((1.136 * Co^(-0.9) + 667.2 * Bo^0.7 * 1.63 * alpha_10)*(1-properties.x_void+small)^0.8));
end if;

  alpha= smooth(1, if (phase==1) then alpha_1 else
                 if (phase==2) then alpha_2 else
                 if small > 0 then (1.5/small)*((1.5/small)^2 - 3)*(alpha_2-alpha_1)/4 + (alpha_1+alpha_2)/2 else (alpha_1+alpha_2)/2);
//  alpha =  if ((phase==1)) then alpha_1
  //   else alpha_2;

heatPorts[1].Q_flow = -alpha * properties.A_heat *(properties.T - heatPorts[1].T);

   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #000000\">The heat transfer coefficient in the two-phase region is calculated using Kandlikar (\"A Model for Correlating Flow Boiling Heat Transfer in Augmented Tubes and Compact Evaporators.\")</span></h4>
<p><b>The <code>Nusseltnumber&nbsp;in the one-phase-flow is calculated by&nbsp;VDI&nbsp;heat&nbsp;atlas,&nbsp;chapter&nbsp;G4&nbsp;&quot;L&auml;ngsumstr&ouml;mte&nbsp;ebene&nbsp;W&auml;nde&quot;&nbsp;written&nbsp;by&nbsp;Volker&nbsp;Gnielinski</b></code></p>
</html>"));
end HeatTransfer_refrigerant_advanced;
