within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
model Compression_R32_old

  extends
    ModularPhysicalCompressors.Rotary.Utilities.CompressorSpecifications;

  Integer ModeMass(start=1);

  Integer ModeWork(start=1);

  Mass m(start=5e-6) "Mass in chamber";

  Mass m_in(start=small) "Mass entering through suction port";

  Mass m_out "Mass exiting through discharge port";

  MassFlowRate m_out_avg;

  MassFlowRate m_in_avg;

  Real G_dot_out(min=small) "Mass flow density at valve outlet";

  Real c1;

  Work W_rev(start=0) "Reversible work";

  Work W_irr(start=0) "Irreversible work";

  SpecificInternalEnergy u(start=500e3) "specific internal energy of gas";

  SpecificEnthalpy h_in
    "Specific enthalpy of gas entering through suction port";

  Enthalpy H_in "Enthalpy of gas entering through suction port";

  Enthalpy H_out "Enthalpy of gas exiting through discharge port";

  EnthalpyFlowRate H_dot_in(start=0)
    "Enthalpy flow of gas entering through suction port";

  EnthalpyFlowRate H_dot_out(start=0)
    "Enthalpy flow of gas exiting through discharge port";

  SpecificEnthalpy h(start=550e3) "Specific enthalpy of gas";

  SpecificEnthalpy h_out_is "Specific enthalpy of isentropic state change";

  SpecificEntropy s_out_is "Specific entropy of fluid at inlet";

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

  // Iteration variables

  Modelica.Units.SI.SpecificEnthalpy h_delta;

  Integer n(start=1);

  // Efficiency variables

  Real eta_is "Isentropic Efficiency";

  Real lambda "Volumetric Efficiency";

  Integer i(start=0);

  Medium.ThermodynamicState state_dh;

  Medium.ThermodynamicState state_in;

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
  when ModeMass == 3 and i > 2 then
    eta_is := (-m_out*(h_out_is - h_in))/(-H_out - H_in);
    lambda := m_in/(state_in.d*V_v*i);
  end when;

equation

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
  // state variables
  V_dot = der(V);
  rho = m/V;
  (state_dh,h_delta,n) = Utilities.setState_dh(d=rho, h=h);

  u = h - p/rho;
  p = state_dh.p;
  T = state_dh.T;

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

  A_dis_cor = smooth(1, if der(m_out) < m_out_avg then 9e-1*G_dot_out^(-1.3)
     else A_dis);

  //  A_dis_cor = A_dis/sqrt(1+(A_0/A_dis)^2);

  A_0 = d_dis*pi*y;

  y = 0.005*(p - Fluid_out.p)/p;

  G_dot_out = smooth(1, if der(m_out) < 0 then -der(m_out)/A_dis else 4000);
  // G_dot_out = noEvent(if der(m_out) < 0 then -der(m_out)/A_dis else 4000);

  ///-m_out_avg / Aeff_out);

  // =====================================================
  // Heat

  // Heat transfer Coefficient (Gas to cylinder)

  alpha_h = 127.93*2*r^(-0.2)*(p/1e6)^(0.8)*T^(-0.53)*(c1*v_avg)^(0.8);

  c1 = smooth(2, if der(V) > 0 then 6.18 else 2.28);

  Heat_port.T = T;

  // =====================================================
  // Average

  if time > 0.05 then
    m_in_avg = m_in/time;
    m_out_avg = m_out/time;

  else

    m_in_avg = 0.01;
    m_out_avg = -0.01;

  end if;

  // =====================================================
  // Volumetric and isentropic effiencies

  der(H_out) = H_dot_out;
  der(H_in) = H_dot_in;

  s_out_is = Medium.specificEntropy(state_in);
  h_out_is = Medium.specificEnthalpy_ps(p=Fluid_out.p, s=s_out_is);

  //        if time > 0.05 then
  //     eta_is = (-m_out * (h_out_is - h_in))  / ( -H_out - H_in);
  //      lambda = m_in / ( state_in.d * V_v * i);
  //     else
  //      eta_is = 0;
  //      lambda = 0;
  //      end if;

  // =====================================================
  // TO BE CHANGED

  p_rub = 48.92e3;

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
          preserveAspectRatio=false)),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Compression_R32_old;
