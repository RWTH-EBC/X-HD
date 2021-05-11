within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.FluidCells;
model FluidElement_water
  import Condenser_funktionsfaehig =
    VCLib.Components.HeatExchangers.HeatExchanger_FVM;

   Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare each package Medium =
               Medium,
     h_outflow(start=Medium.h_default))
     annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
   Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare each package Medium =
               Medium, h_outflow(start=Medium.h_default))
     annotation (Placement(transformation(extent={{90,-10},{110,10}})));
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatport
     annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));

replaceable package Medium =
      Modelica.Media.Water.WaterIF97OnePhase_ph                        "Medium model within the fluid element";
Medium.BaseProperties medium "Medium in the fluid element";

replaceable model HeatTransfer =
    Condenser_funktionsfaehig.FiniteVolumenHeatExchangers.Utilities.HeatTransfers.HeatTransfer_water;

// final constant Real pi = Modelica.Constants.pi;

///// INITIALIZATION------------------------------------
  parameter Modelica.Units.SI.Temperature T_start=293.15
    "inital value for the temperature";
  parameter Modelica.Units.SI.Pressure p_start=500000
    "initial value of the pressure";
  parameter Modelica.Units.SI.Density rho_start=10
    "inital value fot the density";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start=411000
    "inital value for the enthalpy";
  Modelica.Units.SI.MassFlowRate m_in(start=1) "mass flow rate at inlet";
  Modelica.Units.SI.MassFlowRate m_out(start=-1) "mass flow rate at outlet";

//Geometry
  parameter Modelica.Units.SI.Length B "wide of the heat exchanger";
  parameter Modelica.Units.SI.Length H "Height of one fluid channel";
  Modelica.Units.SI.Diameter D "Hydraulic diameter of plate heat exchanger";
  parameter Modelica.Units.SI.Length L "Length of the heat exchanger";
  parameter Modelica.Units.SI.PressureDifference dp "pressure drop";
  parameter Modelica.Units.SI.Temperature T_amb "ambient temperature";
        parameter Integer k;
//properties
  Modelica.Units.SI.ThermalConductivity lambda
    "thermal conductivity of the fluid";
  Modelica.Units.SI.DynamicViscosity eta(start=14.94e-6)
    "dynamic viscosity of the fluid";
  Modelica.Units.SI.PrandtlNumber Pr(start=6.69e-3)
    "Prandtl number of the fluid";

  Modelica.Units.SI.Volume V(start=8.3e-4) "volume of fluid";
  Modelica.Units.SI.Area A_square(start=0.0125) "cross area of fluid";
  Modelica.Units.SI.Area A_heat(start=0.037)
    "wet area where heat transfer occurs";
  Modelica.Units.SI.Density rho "density of the fluid";
  Modelica.Units.SI.Pressure p(start=p_start) "pressure";
  Modelica.Units.SI.Temperature T(start=T_start, min=small)
    "temperature of the fluid";
  Modelica.Units.SI.SpecificEnthalpy h(start=Medium.h_default)
    "specific enthalpy of the fluid";
        final constant Real small=ModelicaServices.Machine.small;
  Modelica.Units.SI.SpecificEnthalpy h1 "specific enthalpy at inlet";
  Modelica.Units.SI.SpecificEnthalpy h2 "specific enthalpy at outlet";
  Modelica.Units.SI.MassFlowRate x "mass flow rate at inlet";
        constant Real x_small = 1e-5;
  Modelica.Units.SI.MassFlowRate m1 "mass flow rate at inlet";
  Modelica.Units.SI.MassFlowRate m2 "mass flow rate at outlet";
  Modelica.Units.SI.Pressure p1 "pressure at inlet";
  Modelica.Units.SI.Pressure p2 "presuure at outlet";
       //Modelica.SIunits.SpecificHeatCapacity cp;

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

  x = port_a.m_flow;
  h1 = inStream(port_a.h_outflow);
  h2 = inStream(port_b.h_outflow);
  h = Modelica.Fluid.Utilities.regStep(x,h1,h2,x_small);

  m1 = port_a.m_flow;
  m2 = port_b.m_flow;
  m_in = Modelica.Fluid.Utilities.regStep(x,m1,m2,x_small);
  m_out = Modelica.Fluid.Utilities.regStep(x,m2,m1,x_small);

  p1 = port_a.p;
  p2 = port_b.p;
  p = Modelica.Fluid.Utilities.regStep(x,p1,p2,x_small);

   medium.p = p;
   medium.h = h;
   medium.T = T;

//thermodynamic properties
lambda = max(Medium.thermalConductivity(Medium.setState_phX(p, h, fill(0, Medium.nX))),small);
//cp = Medium.specificHeatCapacityCp(Medium.setState_phX(p,h,fill(0,Medium.nX)));
eta = max(Medium.dynamicViscosity(Medium.setState_phX(p,h,fill(0,Medium.nX))),small);
Pr = max(Medium.prandtlNumber(Medium.setState_phX(p,h,fill(0,Medium.nX))),small);

//Geometric
  D = (2* B * H) / (B + H);
  A_heat = k*(B + H) * L;
  A_square = k*B * H;
  V = A_square * L;
  //Pr = eta* cp / lambda;
  rho = medium.d;

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
 properties.phase = 1;
// properties.n = n;

 properties.T = medium.T;
 properties.p = p;
 properties.h = h;
 properties.lambda = lambda;
 properties.rho = medium.d;
 properties.eta = eta;
 properties.Pr = Pr;
 properties.x_void = 1;
 properties.dl = rho;
 properties.dv = rho;
// properties.delta_h = delta_h;
 properties.lambda0 = lambda;
 properties.eta0 = eta;
 properties.Pr0 = Pr;

  connect(volume.ports[1], port_b) annotation (Line(points={{0,-10},{52,-10},{52,0},{100,0}},
                       color={0,127,255}));
  connect(volume.heatPort, heatport) annotation (Line(points={{-8,0},{-6,0},{-6,
          -98},{0,-98}}, color={191,0,0}));
  connect(port_a, volume.ports[2]) annotation (Line(points={{-100,0},{-50,0},{-50,-10},{4,-10}}, color={0,127,255}));
     annotation (Placement(transformation(extent={{23,66},{43,46}})),
                Placement(transformation(extent={{-10,44},{10,64}})));
end FluidElement_water;
