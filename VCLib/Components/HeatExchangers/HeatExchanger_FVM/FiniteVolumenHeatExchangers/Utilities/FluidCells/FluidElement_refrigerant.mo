within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.FluidCells;
model FluidElement_refrigerant
  import Condenser_funktionsfaehig =
    VCLib.Components.HeatExchangers.HeatExchanger_FVM;

   Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare each package Medium =
               Medium,h_outflow(start=Medium.h_default))
     annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
   Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare each package Medium =
               Medium,h_outflow(start=Medium.h_default))
     annotation (Placement(transformation(extent={{90,-10},{110,10}})));
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatport
     annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));

replaceable package Medium = Modelica.Media.R134a.R134a_ph "Medium model within the fluid element";
Medium.BaseProperties medium "Medium in the fluid element";

replaceable model HeatTransfer =
    Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.HeatTransfers.HeatTransfer_refrigerant_advanced;

///// INITIALIZATION------------------------------------
  parameter Modelica.Units.SI.Temperature T_start=293.15
    "initial value of the temperature";
  parameter Modelica.Units.SI.Pressure p_start=500000
    "inital value of the pressure";
   //     parameter Modelica.SIunits.Density rho_start=10;
  Modelica.Units.SI.MassFlowRate m_in(min=small, start=0.2)
    "mass flow rate at inlet";
  Modelica.Units.SI.MassFlowRate m_out(start=-0.2) "mass flow rate at outlet";

//Geometry
  parameter Modelica.Units.SI.Length B "wide of the heat exchanger";
  parameter Modelica.Units.SI.Length H "Height of one fluid channel";
  Modelica.Units.SI.Diameter D "Hydraulic diameter of plate heat exchanger";
  parameter Modelica.Units.SI.Length L "Length of the heat exchanger";
  parameter Modelica.Units.SI.PressureDifference dp "pressure drop";
  parameter Modelica.Units.SI.Temperature T_amb "ambient temperature";
        parameter Integer k;

//thermodynamic properties
  Modelica.Units.SI.ThermalConductivity lambda
    "thermal conductivity of the fluid";
  Modelica.Units.SI.DynamicViscosity eta(start=14.94e-6)
    "dynamic visocsity of the fluid";
  Modelica.Units.SI.ThermalConductivity lambda0
    "thermal conductivity of the fluid if there is only a liquid phase";
  Modelica.Units.SI.DynamicViscosity eta0(start=14.94e-6)
    "dynamic visocsity of the fluid if there is only a liquid phase";
  Modelica.Units.SI.PrandtlNumber Pr(start=6.69e-3)
    "Prandtl number of the fluid";
  Modelica.Units.SI.PrandtlNumber Pr0(start=6.69e-3)
    "Prandtl number of the fluid if there is only a liquid phase";
        //Modelica.SIunits.SpecificHeatCapacity cp;
  Modelica.Units.SI.Density dl=max(Medium.bubbleDensity(sat), small)
    "density of the liquid phase";
  Modelica.Units.SI.Density dv=max(Medium.dewDensity(sat), small)
    "density of the vapor phase";
        Integer phase(start=1) "number of occuring phases: 1 for liquid/vapor and 2 for two-phase region";

   //geometrical properties
  Modelica.Units.SI.Volume V(start=8.3e-4) "volume of fluid";
  Modelica.Units.SI.Area A_square(start=0.0125) "cross area of fluid";
  Modelica.Units.SI.Area A_heat(start=0.037)
    "wet area where heat transfer occurs";
  Modelica.Units.SI.Density rho "density of the fluid";
  Modelica.Units.SI.Pressure p(start=p_start) "pressure at the inlet";
  Modelica.Units.SI.Temperature T(start=T_start) "temperature of the fluid";
  Modelica.Units.SI.SpecificEnthalpy h(start=Medium.h_default)
    "enthalpy of the fluid";
  Modelica.Units.SI.SpecificEnthalpy hl=Medium.bubbleEnthalpy(sat)
    "Liquid enthalpy";
  Modelica.Units.SI.SpecificEnthalpy hv=Medium.dewEnthalpy(sat)
    "Vapor enthalpy";
        Medium.SaturationProperties sat(psat=p, Tsat=1)
    "Saturation temperature and pressure";
       final constant Real small=ModelicaServices.Machine.small;
  Modelica.Units.SI.SpecificEnthalpy h1 "specific enthalpy at port a";
  Modelica.Units.SI.SpecificEnthalpy h2 "specific enthalpy at port b";
  Modelica.Units.SI.MassFlowRate x "mass flow rate at port a";
       constant Real x_small = 1e-5;
  Modelica.Units.SI.MassFlowRate m1 "mass flow rate at port a";
  Modelica.Units.SI.MassFlowRate m2 "mass flow rate at port b";
  Modelica.Units.SI.Pressure p1 "pressure at port a";
  Modelica.Units.SI.Pressure p2 "pressure at port b";
       Real x_void(start=1) "void fraction of the fluid";

inner Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.Properties.ElementProperties properties annotation (Placement(transformation(extent={{-66,54},{-46,74}})));

inner Modelica.Fluid.System system "System wide properties";

  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium,
    V=B*H*L,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer,
    use_portsData=false,
    nPorts=2,
    p_start=p_start,
    T_start=T_start,
    use_T_start=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

    //////////////// TEST
  Modelica.Units.SI.SpecificEnthalpy hhInlM=inStream(port_a.h_outflow);
  Modelica.Units.SI.SpecificEnthalpy hOutM=port_b.h_outflow;
  Modelica.Units.SI.SpecificEnthalpy hhInlM_umgekehrt=inStream(port_b.h_outflow);
  Modelica.Units.SI.SpecificEnthalpy hOutM_umgekehrt=port_a.h_outflow;
equation
  //Conservative

  //-----h smooth
  x = port_a.m_flow;
  h1 = inStream(port_a.h_outflow);
  h2 = inStream(port_b.h_outflow);
  h = Modelica.Fluid.Utilities.regStep(x,h1,h2,x_small);

  m1 = port_a.m_flow;
  m2 = port_b.m_flow;
  m_in = Modelica.Fluid.Utilities.regStep(x,m1,m2,x_small);
  m_out = -m_in;

  p1 = port_a.p;
  p2 = port_b.p;
  p = Modelica.Fluid.Utilities.regStep(x,p1,p2,x_small);

    //-----------------to ensure the model's stability the following equations have been reformulated with "regStep"
    //if port_a.m_flow > small then
    //h   = inStream(port_a.h_outflow);
    //p   = port_a.p;
    //medium.Xi[:] = port_a.Xi_outflow[:];
    //m_in = port_a.m_flow;
    //m_out = port_b.m_flow;
   //elseif port_a.m_flow < small then
     //h   = inStream(port_b.h_outflow);
     //p   = port_b.p;
     //medium.Xi[:] = port_b.Xi_outflow[:];
     //m_in = port_b.m_flow;
     //m_out = port_a.m_flow;
   //else
     //h = 0.5 * (inStream(port_a.h_outflow) + inStream(port_b.h_outflow));
     //p = port_a.p;
     //medium.Xi[:] = port_a.Xi_outflow[:];
     //m_in = small;
     //m_out = small;
   //end if;

   //void fraction is calculated assuming that there is no pressure drop along the heat exchanger
x_void = min(max(((h-hl)/(hv-hl+small)), small), 1);
   medium.p = p;
   medium.h = h;
   medium.T = T;

//specific thermodynamic values
lambda = max(Medium.thermalConductivity(Medium.setState_phX(p, h, fill(0, Medium.nX))),small);
//cp = Medium.specificHeatCapacityCp(Medium.setState_phX(p,h,fill(0,Medium.nX)));
eta = max(Medium.dynamicViscosity(Medium.setState_phX(p,h,fill(0,Medium.nX))),small);
Pr = max(Medium.prandtlNumber(Medium.setState_phX(p,h,fill(0,Medium.nX))), small);
lambda0 = max(Medium.thermalConductivity(Medium.setState_phX(p, hl, fill(0, Medium.nX))),small);
eta0 = max(Medium.dynamicViscosity(Medium.setState_phX(p,hl,fill(0,Medium.nX))),small);
Pr0 = max(Medium.prandtlNumber(Medium.setState_phX(p,hl,fill(0,Medium.nX))), small);
phase =  if ((h < hl) or (h > hv) or (p > Modelica.Media.R134a.R134aData.data.FPCRIT)) then 1
     else 2;

  //Geometric values
  D = (2* B * H) / (B + H);
  A_heat = 2*k*(B + H) * L;
  A_square = k* B * H;
  V = A_square * L;
  //Pr = eta* cp / lambda;
  rho = max(medium.d, small);

//records
 properties.p_in = port_a.p;
 properties.m_in = m_in;
 properties.p_out = port_b.p;
 properties.m_out = m_out;
 properties.A_square = A_square;
 properties.A_heat = A_heat;
 properties.V  = V;
 properties.L = L;
 properties.B = B;
 properties.H = H;
 properties.D = D;
 properties.phase = phase;
// properties.n = n;

 properties.T = medium.T;
 properties.p = p;
 properties.h = h;
 properties.lambda = lambda;
 properties.rho = max(small,medium.d);
 properties.eta = eta;
 properties.Pr = Pr;
 properties.Pr0 = Pr0;
 properties.lambda0= lambda0;
 properties.eta0=eta0;
 properties.dl = dl;
 properties.dv = dv;
 properties.x_void = x_void;

  connect(volume.ports[1], port_b) annotation (Line(points={{0,-10},{52,-10},{52,0},{100,0}},
                       color={0,127,255}));
  connect(volume.heatPort, heatport) annotation (Line(points={{-8,0},{-6,0},{-6,
          -98},{0,-98}}, color={191,0,0}));
  connect(port_a, volume.ports[2]) annotation (Line(points={{-100,0},{-50,0},{-50,-10},{4,-10}}, color={0,127,255}));
     annotation (Placement(transformation(extent={{23,66},{43,46}})),
                Placement(transformation(extent={{-10,44},{10,64}})));
end FluidElement_refrigerant;
