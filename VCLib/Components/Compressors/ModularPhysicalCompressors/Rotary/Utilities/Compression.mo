within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Compression

  extends
    ModularPhysicalCompressors.Rotary.Utilities.CompressorSpecifications;
    parameter Real a_co=3e-1;

    parameter Real b_ex=-1.3;
  // State and Conversion variables

  Mass m(start=2e-4) "Mass in chamber";

  Mass m_in(start=small) "Mass entering through suction port";

  Mass m_out "Mass exiting through discharge port";

  MassFlowRate m_dot_out_avg "Average mass flow through discharge valve";

  MassFlowRate m_dot_in_avg "Average mass flow through discharge valve";

  Real G_dot_out(min=small) "Mass flow density at valve outlet";

  Work W_rev(start=0) "Reversible work";

  Work W_irr(start=0) "Irreversible work";

  SpecificInternalEnergy u(start=450e3) "specific internal energy of gas";

  SpecificEnthalpy h_in
    "Specific enthalpy of gas entering through suction port";

  Enthalpy H_in "Enthalpy of gas entering through suction port";

  Enthalpy H_out "Enthalpy of gas exiting through discharge port";

  EnthalpyFlowRate H_dot_in(start=0)
    "Enthalpy flow of gas entering through suction port";

  EnthalpyFlowRate H_dot_out(start=0)
    "Enthalpy flow of gas exiting through discharge port";
  Enthalpy H "Enthalpy of gas in chamber";

  InternalEnergy U "Internal Energy of gas in chamber";

  Entropy S "Entropy of gas in chamber";

  Power P "Mechanical Power on chamber";

  SpecificEnthalpy h(start=500e3) "Specific enthalpy of gas";

  SpecificEnthalpy h_out_is "Specific enthalpy of isentropic state change";

  SpecificEntropy s "Specific entropy of fluid inside chamber";

  SpecificEntropy s_in "Specific entropy of fluid at inlet";

  Volume V(min=0.001) "Volume in chamber";

  VolumeFlowRate V_dot "Volume flow rat";

  Angle Theta720 "Angle of Rotation every 2 cycles";

  Pressure p(start=1e5, max=700e5) "Pressure in compressor";

  Pressure p_rub "Friction Pressure";

  Temperature T(start=300) "Temperature in compressor";

  Density rho(start=5) "Density";

  //Density rho_0 "Density of incoming fluid";

  Area A_suc "Area of suction port inlet valve";

  Area A_dis "Area of discharge port outlet valve";

  Area A_suc_cor "corrected Area of suction port inlet valve";

  Area A_dis_cor "corrected Area of discharge port outlet valve";

  Area A_0 "Area of displaced discharge valve height";

  Length y "height of displaced discharge valve";

  Volume V_0 "Swept volume + dead volume";

  // Mode tracker

  Integer ModeMass(start=1);

  Integer ModeWork(start=1);

  // Iteration variables

  Modelica.Units.SI.SpecificEnthalpy h_delta;

  Integer n(start=1);

  // Efficiency variables

  Real eta_is "Isentropic Efficiency";

  Real eta_is_w "Isentropic Efficiency calculated through Work";

  Real lambda_h "Volumetric Efficiency";

  Integer i(start=0);

  Medium.ThermodynamicState state_dh;

  Medium.ThermodynamicState state_in;

  // Heat exchange variables

  Real c1;

  ThermalConductivity lambda_t "Thermal conductivity of gas in chamber";

  DynamicViscosity my "Dynamic viscosity of gas in chamber";

  Real Pr "Prantl number of gas in chamber";

  Real Re "Reynolds number of gas in chamber";

  Length L_ref "Characteristic length used to calculate heat transfer";

    Length L_ref_cor;

  Velocity u_inf "Mean velocity used to calculate heat transfer";

  SpecificHeatCapacity cp "Specific heat capacity for constant pressure";
      Medium.SaturationProperties satp;

    Medium.ThermodynamicState dew_state;

    Temperature T_sat;

    Real dT_sh;

  Modelica.Blocks.Interfaces.RealInput V1 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

  Modelica.Blocks.Interfaces.RealInput T1 annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,50})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Heat_port annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-10,-90})));
  Modelica.Fluid.Interfaces.FluidPort_a Fluid_in(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b Fluid_out(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealOutput alpha_h annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-70,-100})));
  Modelica.Blocks.Interfaces.RealInput v_avg annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,-30})));

algorithm
  when ModeMass == 1 then
    i := i + 1;
  end when;
  when ModeMass == 2 and i > 3 then
    eta_is := (-m_out*(h_out_is - h_in))/(-H_out - H_in);
    lambda_h := m_in/(state_in.d*V_0*i);
  end when;

equation

  // TO BE CHANGED

  p_rub = 48.92e3;

  // =====================================================
  // Inputs

  Theta720 = T1;
  V = V1;
  Fluid_in.m_flow = der(m_in);
  Fluid_in.h_outflow = h;
  h_in = inStream(Fluid_in.h_outflow);
  state_in = Medium.setState_ph(p=Fluid_in.p, h=h_in);

  // =====================================================
  // Outputs

  Fluid_out.m_flow = der(m_out);
  Fluid_out.h_outflow = h;

  // =====================================================
  // State variables

  U = m*u;
  S = m*s;
  H = U + p*V;
  V_dot = der(V);
  rho = m/V;
  (state_dh,h_delta,n) = Utilities.setState_dh(d=rho, h=h);

  u = h - p/rho;
  p = state_dh.p;
  T = state_dh.T;

    satp = Medium.setSat_p(Fluid_in.p);
  dew_state = Medium.setDewState(satp);

  T_sat = dew_state.T;

  dT_sh = state_in.T - T_sat;

  // =====================================================
  // Energy balance

  if p < Fluid_out.p and Theta720 > 3.7*pi then

    0 = der(m)*u + m*der(u) - H_dot_in - H_dot_out - der(W_rev) - der(W_irr) -
      Heat_port.Q_flow;

    ModeWork = 1;

  else

    0 = der(m)*u + m*der(u) - H_dot_in - H_dot_out - der(W_rev) - der(W_irr) -
      Heat_port.Q_flow;

    ModeWork = 2;

  end if;

  // =====================================================
  // Mass balance

  if Fluid_in.p >= p then
    // Suction

    der(m) = A_suc_cor*sqrt(2*rho*abs((Fluid_in.p - p)));
    der(m_in) = der(m);
    der(m_out) = 0;

    H_dot_in = der(m_in)*h_in;
    H_dot_out = 0;

    ModeMass = 1;

  elseif p > Fluid_out.p then
    // Discharge

    der(m) = -A_dis_cor*sqrt(2*rho*abs((p - Fluid_out.p)));
    der(m_out) = der(m);
    der(m_in) = 0;

    H_dot_in = 0;
    H_dot_out = der(m_out)*h;

    ModeMass = 3;

  else
    // Compression

    der(m) = 0;
    der(m_out) = 0;
    der(m_in) = 0;

    H_dot_in = 0;
    H_dot_out = 0;

    ModeMass = 2;

  end if;

  // =====================================================
  // Work

  der(W_rev) = -p*der(V);
  der(W_irr) = abs(-p_rub*der(V));

  // =====================================================
  // Valves

  //A_suc = (R*abs(Theta_suc_2-Theta_suc_1)/2/pi)^2*pi;
  //A_dis = (R*abs(Theta_dis_2-Theta_dis_1)/2/pi)^2*pi;

  A_suc = d_suc^2*pi/4;
  A_dis = d_dis^2*pi/4;

  //A_suc_cor = 2.0415e-1 * (Modelica.Constants.R / Medium.refrigerantConstants.molarMass)^(-0.9826);

  A_suc_cor = A_suc;

  // A_dis_cor = A_dis;

  A_dis_cor = smooth(1, if der(m_out) < m_dot_out_avg then a_co*G_dot_out^b_ex
     else A_dis);

  //  A_dis_cor = A_dis/sqrt(1+(A_0/A_dis)^2);

  A_0 = d_dis*pi*y;

  y = 0.005*(p - Fluid_out.p)/p;

  G_dot_out = smooth(1, if der(m_out) < 0 then -der(m_out)/A_dis else 4000);

  ///-m_dot_out_avg / Aeff_out);

  // ======================================================
  // Heat losses / gains
  // Model from Calculations for Compression Efficiency Caused by Heat Transfer in Compact Rotary Compressors

  // alpha_h = 127.93*2*r^(-0.2)*(p/1e6)^(0.8)*T^(-0.53)*(c1*v_avg)^(0.8);

  alpha_h = 0.037*lambda_t/L_ref_cor*Pr^(1/3)*Re^(4/5);

  c1 = smooth(2, if der(V) > 0 then 6.18 else 2.28);

  Heat_port.T = T;
  Re = u_inf*L_ref_cor*rho/my;
  //Re=1;

  my = Medium.dynamicViscosity(state_dh);

  lambda_t = abs(Medium.thermalConductivity(state_dh));
  //lambda_t = 1;
  cp = Medium.specificHeatCapacityCp(state_dh);
  //cp = 1;

  L_ref = (2*pi - rem(Theta720, 2*pi))*(R + r)/2;

  L_ref_cor = smooth(1, if L_ref > 2*pi*(R+r)/8 then L_ref else 2*pi*(R+r)/8);
  //L_ref_cor = L_ref + 0.001;

  u_inf = abs(R*der(Theta720)/2);

  Pr = my*cp/lambda_t;
  //Pr = 1;

  // =====================================================
  // Volumetric and isentropic effiencies

  der(H_out) = H_dot_out;
  der(H_in) = H_dot_in;

  s_in = Medium.specificEntropy(state_in);
  h_out_is = Medium.specificEnthalpy_ps(p=Fluid_out.p, s=s_in);
  s = Medium.specificEntropy(state_dh);

  V_0 = (R^2-r^2)*pi*L;

  // Efficiency calculated through Work

  if time > 0 then
    eta_is_w = W_rev/(W_rev + W_irr);
  else
    eta_is_w = 0;
  end if;

  //        if time > 0.05 then
  //     eta_is = (-m_out * (h_out_is - h_in))  / ( -H_out - H_in);
  //      lambda_h = m_in / ( state_in.d * V_v * i);
  //     else
  //      eta_is = 0;
  //      lambda_h = 0;
  //      end if;

  // =====================================================
  // Averages

  if time > 0 then
    P = (W_irr + W_rev)/time;
  else  P = 0;
      end if;

  if time > 0.05 then
    m_dot_in_avg = m_in/time;
    m_dot_out_avg = m_out/time;

  else
    m_dot_in_avg = 0.01;
    m_dot_out_avg = -0.01;

  end if;

  // =====================================================

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,30},{40,-30}},
          lineColor={0,0,0},
          fillColor={182,182,182},
          fillPattern=FillPattern.CrossDiag),
        Ellipse(
          extent={{-6,8},{6,-4}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,48},{2,28}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,76},{58,60}},
          lineColor={28,108,200},
          textString="Compression 1 chamber")}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Compression;
