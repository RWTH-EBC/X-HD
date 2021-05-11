within VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Utilities;
model closedVolume2
  "model using correlation for fluid dependent values"
  extends Records.Geometry_Roskoch;
  //Volumina

  extends
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Utilities.Records.StartValues_Reciprocating_R32;

  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={20,100})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Heat_port
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_a Fluid_in(redeclare package Medium =
        VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b Fluid_out(redeclare package Medium =
        VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput v_pis annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-20,100})));
  Modelica.Blocks.Interfaces.RealOutput alpha_gas_cyl
    "Heat tranfer cooefficient between gas and cylinder" annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={22,-102})));

algorithm
  when modi == 1 then
    i:=i + 1;
  end when;
 when modi == 2 and i>1 then
    eta_is :=(-m_out*(h_out_is - h_in))/(-U_out - U_in);
    lambda :=m_in/(state_in.d*V_0*i);
 end when;

equation

  //Energy balance
  der(m_gas)*u_gas + m_gas*der(u_gas) - der(W_rev) - der(W_irr) - Heat_port.Q_flow - U_flow_in - U_flow_out = 0;

  //Heat transfer Coefficient (Gas to cylinder)
  alpha = 127.93*D_pis^(-0.2)*(p_gas/1e6)^(0.8)*T_gas^(-0.53)*(c1*v_pis_avg)^(0.8);
  alpha_gas_cyl = alpha;
  //Work, reversible and irreversible
  der(W_rev) = -p_gas*der(V_gas);
  der(W_irr) = abs(-p_rub*der(V_gas));
  d_gas = m_gas/V_gas;

  //Effective area of valves
  //G_dot_out = -der(m_out) / Aeff_out;
  Aeff_in_cor =2.0415e-3*(Modelica.Constants.R/
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.refrigerantConstants.molarMass)
    ^(-0.9826);
  Aeff_out_cor = smooth(1,if der(m_out) < m_out_avg then 5.1109e-4 * G_dot_out^(-0.4860) else Aeff_out);
  G_dot_out = smooth(1, if der(m_out) < 0 then  -der(m_out) / Aeff_out  else   4000);///-m_out_avg / Aeff_out);
  //State in piston
  (state_dh,h_delta,n) = Utilities.setState_dh(d=d_gas, h=h_gas);
  u_gas = h_gas - p_gas / d_gas;
  p_gas = state_dh.p;
  T_gas = state_dh.T;

  //Mass balance
  if Fluid_in.p > p_gas then //Suction
    der(m_gas) = Aeff_in_cor*sqrt(2*d_gas*abs((Fluid_in.p - p_gas)));
    U_flow_in = der(m_gas) * h_in;
    U_flow_out = 0;
    der(m_in) = der(m_gas);
    der(m_out) = 0;
    //c1 = 6.18;
    modi = 1;
  elseif p_gas > Fluid_out.p then //Discharge
    der(m_gas) = -Aeff_out_cor*sqrt(2*d_gas*abs((Fluid_out.p - p_gas)));
    U_flow_out = der(m_gas) * h_gas;
    U_flow_in = 0;
    der(m_in) = 0;
    der(m_out) = der(m_gas);
    //c1 = 2.28;
    modi = 3;
  else //Compression or expansion
    der(m_gas) = 0;
    U_flow_in = 0;
    U_flow_out = 0;
    der(m_in) = 0;
    der(m_out) = 0;
    //c1 = 6.18;
    modi = 2;
  end if;
  c1 = smooth(2, if der(V_gas) > 0 then 6.18 else 2.28);

  //Connect ports
  //Fluid ports
  Fluid_in.m_flow = der(m_in);
  Fluid_out.m_flow = der(m_out);
  Fluid_in.h_outflow = h_gas;
  Fluid_out.h_outflow = h_gas;
  h_in = inStream(Fluid_in.h_outflow);
  state_in =
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.setState_ph(
    p=Fluid_in.p, h=h_in);
  //Heat port
  Heat_port.T = T_gas;
  //Real inputs
  V_gas = u;
  v_pis_avg = v_pis;

  //Average
  if time > 0.05 then
  m_in_avg = m_in / time;
  m_out_avg = m_out / time;
  P = (W_irr+W_rev) / time;
  else
    m_in_avg = 0.01;
    m_out_avg = -0.01;
    P=0;
  end if;

  //Isentropic efficiency
  der(U_in) = U_flow_in;
  der(U_out) = U_flow_out;
  s_out_is =
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.specificEntropy(
    state_in);
  h_out_is =
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Medium.specificEnthalpy_ps(
    p=Fluid_out.p, s=s_out_is);
//        if time > 0.05 then
//          eta_is = (-m_out * (h_out_is - h_in))  / ( -U_out - U_in);
//          lambda = m_in / ( state_in.d * V_0 * i);
//        else
//          eta_is = 0;
//          lambda = 0;
//        end if;

  //Volumetric efficiency
  V_0 =  Modelica.Constants.pi * H * ( 1 + c_dead) * (0.5 * D_pis)^2;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-50,36},{50,-90}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,62},{-48,62},{-48,-30},{-52,-30},{-52,62}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{48,60},{52,60},{52,-34},{48,-34},{48,60}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-48,40},{48,30}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-6,92},{6,40}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Forward),
        Polygon(
          points={{-48,-90},{48,-90},{48,70},{52,70},{52,-94},{-52,-94},{-52,
              70},{-48,70},{-48,-90}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward)}),                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=0.2,
      Interval=3e-05,
      Tolerance=0.001,
      __Dymola_Algorithm="Dassl"));
end closedVolume2;