within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Utilities;
record CompressorSpecifications
  // Values from: Influence of Clearance volume on the performance of the rolling piston type rotary compressor
  constant Radius R=0.027 "Radius cylinder";

  constant Radius r=0.0234 "Radius piston";

  constant Length L=0.238 "Length cylinder";

  constant Length t_b=0.004 "Vane thickness";

  constant Length h_b=0.005 "Vane height";

  constant Length H_shell = 0.2 "Compressor shell height";

  constant Radius R_shell = 0.05;

  constant Angle Theta_suc_1=0.31 "Suction valve first angle";

  constant Angle Theta_suc_2=0.61 "Suction valve second angle";

  constant Angle Theta_dis_1=-0.38 "Discharge valve first angle";

  constant Angle Theta_dis_2=-0.12 "Discharge valve second angle";

  constant Length d_suc=0.008 "Suction port diameter";

  constant Length d_dis=0.007 "Discharge port diameter";

  constant Volume V_v=2e-6 "Clearance volume";
  //correct Value is 2e-7, 2e-6 used for model stability

  //constant Volume V_0=13.5e-6 "Swept Volume";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CompressorSpecifications;
