within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities.Geometry;
model Volumes

  extends
    ModularPhysicalCompressors.Rotary.Utilities.CompressorSpecifications;

  Angle Theta360
    "1st Volume: Angle between y-axis and vector pointing to center of piston 0 - 360";

  Angle Theta720
    "1st Volume: Angle between y-axis and vector pointing to center of piston 0 - 720";

  Angle Gamma720
    "2nd Volume: Angle between y-axis and vector pointing to center of piston 0 - 720";

  Angle phi "Accumulated angle of rotation";

  parameter Angle del_phi=0.5*pi;

  Area A_cyl "Area connecting gas and cylinder";
  Area A_pis "Area connecting gas and rolling piston";
  Area A_wal "Area connecting gas and top and bottom wall";
  Area A_tot "total Area";

  Volume V_total "Total volume cylinder";

  Volume V_gas "Volume that can be filled with gas";

  Volume V_suc "Volume of suction chamber";

  Volume V_dis "Volume of discharge chamber";

  Volume V_vane "Volume of vane";

  Velocity v_avg "Average piston velocity";

  Real a "Ratio of piston radius r and cylinder radius R";

  Modelica.Blocks.Interfaces.RealOutput V1
    annotation (Placement(transformation(extent={{80,50},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput V2
    annotation (Placement(transformation(extent={{-80,50},{-120,90}})));
  Modelica.Blocks.Interfaces.RealOutput T1
    annotation (Placement(transformation(extent={{80,10},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput T2
    annotation (Placement(transformation(extent={{-80,10},{-120,50}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));

  Modelica.Blocks.Interfaces.RealOutput v_m
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-100})));
  Modelica.Blocks.Interfaces.RealOutput A_heat_1
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={100,-10})));
  Modelica.Blocks.Interfaces.RealOutput A_heat_2
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={-100,-10})));
equation

  V_total = R^2*pi*L + V_v;
  V_gas = V_total - L*pi*r^2 - V_vane;
  a = r/R;

  V_vane = t_b*h_b/2*R*(1 - (1 - a)*cos(Theta360) - sqrt((1 - a)^2*(cos(
    Theta360))^2 + 2*a - 1));
  // Gleichung aus Geometrical Optimisation of a Rotary Compressor for Refrigerators

  phi = flange_a.phi + del_phi;

  flange_a.tau = 0;

  Theta360 = rem(phi, 2*pi);
  Theta720 = rem(phi, 4*pi);
  Gamma720 = rem(phi + 2*pi, 4*pi);

  V_suc = V_v + 1/2*L*R^2*((1 - a^2)*Theta360 - (1 - a)^2*0.5*sin(2*Theta360) -
    a^2*asin((1/a - 1)*sin(Theta360)) - a*(1 - a)*sin(Theta360)*sqrt(1 - (1/a -
    1)^2*(sin(Theta360))^2)) - V_vane;
  // Gleichung aus Geometrical Optimisation of a Rotary Compressor for Refrigerators

  V_dis = V_v + V_gas - V_suc - V_vane;

  A_cyl = L*R*Theta360;
  A_pis = L*r*(Theta360+asin((R-r)/r*sin(Theta360)));
  A_wal = (R^2-r^2)*Theta360;
 // A_tot = A_cyl+A_pis+A_wal;
 A_tot = A_wal;
  A_heat_1 = A_tot;

  A_heat_2 = R*L*2*pi  + r*L*2*pi  + (R^2-r^2)*pi - A_tot;

  if Theta720 < 2*pi then
    V1 = V_suc;
    V2 = V_dis;
  else
    V1 = V_dis;
    V2 = V_suc;
  end if;

  if time > 0 then
    v_avg = der(phi)*(R-r);
  else
    v_avg = 0;
  end if;

  v_avg = v_m;
  T1 = Theta720;
  T2 = Gamma720;

  annotation (Icon(graphics={Ellipse(
          extent={{-56,54},{56,-54}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid), Text(
          extent={{-52,74},{56,54}},
          lineColor={28,108,200},
          textString="Volumes")}));
end Volumes;
