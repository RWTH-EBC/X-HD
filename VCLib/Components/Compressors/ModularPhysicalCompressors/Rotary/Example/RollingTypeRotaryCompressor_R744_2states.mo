within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Example;
model RollingTypeRotaryCompressor_R744_2states
   "Compressor Model using Refrigerant R32"

  Modelica.Fluid.Sources.FixedBoundary Evaporator_out(
  use_p=true,
  use_T=true,
  redeclare package Medium = Rotary.Medium,
    nPorts=2,
    T(displayUnit="K") = 275.15,
    p(displayUnit="bar") = 4000000)
              annotation (Placement(transformation(extent={{-96,-12},{-76,8}})));
  Modelica.Fluid.Sources.FixedBoundary Condenser_in(
  use_T=true,
  redeclare package Medium = Rotary.Medium,
  T(displayUnit="degC") = 373.15,
    nPorts=2,
    p=5600000)                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={88,0})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(
        displayUnit="rpm") = 314.15926535898)
    annotation (Placement(transformation(extent={{-12,74},{8,94}})));
  final parameter Modelica.Units.SI.ThermalConductance G=0.24
    "Constant thermal conductance of material";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Ambient(T=298.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-90})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CompressorWall(C=5, T(
        start=340, displayUnit="K")) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-86,-80})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor_ambient(G=G)
    "Thermal conduction between cylinder and ambient" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={52,-90})));
  Utilities.Compression_R744_old piston1
    annotation (Placement(transformation(extent={{16,-12},{36,8}})));
  Utilities.Compression_R744_old piston2
    annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));

  Utilities.Geometry.Volumes volumes
    annotation (Placement(transformation(extent={{-12,38},{8,58}})));
  Utilities.Controller controller
    annotation (Placement(transformation(extent={{-24,20},{-44,40}})));
  Utilities.ThermalConductor_Gas_Cylinder thermalConductor_Gas_Cylinder_1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={26,-56})));
  Utilities.ThermalConductor_Gas_Cylinder thermalConductor_Gas_Cylinder_2
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-34,-54})));
equation
  connect(Ambient.port, thermalConductor_ambient.port_a)
    annotation (Line(points={{80,-90},{62,-90}}, color={191,0,0}));
  connect(constantSpeed.flange, volumes.flange_a) annotation (Line(points={{8,
          84},{14,84},{14,64},{-2,64},{-2,57.8}}, color={0,0,0}));
  connect(controller.flange_a, volumes.flange_a) annotation (Line(points={{-34,
          39},{-34,64},{-2,64},{-2,57.8}}, color={0,0,0}));
  connect(volumes.V1, piston1.V1)
    annotation (Line(points={{8,55},{26,55},{26,8}}, color={0,0,127}));
  connect(volumes.T1, piston1.T1) annotation (Line(points={{8,51},{16,51},{16,
          20},{8,20},{8,3},{16,3}}, color={0,0,127}));
  connect(volumes.A_heat_1, thermalConductor_Gas_Cylinder_1.A_cg) annotation (
      Line(points={{8,47},{12,47},{12,28},{6,28},{6,-52},{16,-52}}, color={0,0,
          127}));
  connect(piston1.alpha_h, thermalConductor_Gas_Cylinder_1.alpha) annotation (
      Line(points={{19,-12},{20,-12},{20,-36},{2,-36},{2,-60},{16,-60}}, color=
          {0,0,127}));
  connect(piston1.Heat_port, thermalConductor_Gas_Cylinder_1.port_b)
    annotation (Line(points={{25,-11},{25,-46},{26,-46}}, color={191,0,0}));
  connect(piston2.Heat_port, thermalConductor_Gas_Cylinder_2.port_b)
    annotation (Line(points={{-33,-9},{-33,-44},{-34,-44}}, color={191,0,0}));
  connect(piston2.alpha_h, thermalConductor_Gas_Cylinder_2.A_cg) annotation (
      Line(points={{-39,-10},{-39,-30},{-52,-30},{-52,-50},{-44,-50}}, color={0,
          0,127}));
  connect(volumes.A_heat_2, thermalConductor_Gas_Cylinder_2.alpha) annotation (
      Line(points={{-12,47},{-14,47},{-14,46},{-62,46},{-62,-58},{-44,-58}},
        color={0,0,127}));
  connect(volumes.V2, controller.V_in) annotation (Line(points={{-12,55},{-18,
          55},{-18,35},{-24,35}}, color={0,0,127}));
  connect(controller.V_out, piston2.V1) annotation (Line(points={{-44,35},{-50,
          35},{-50,16},{-32,16},{-32,10}}, color={0,0,127}));
  connect(volumes.T2, piston2.T1) annotation (Line(points={{-12,51},{-54,51},{
          -54,5},{-42,5}}, color={0,0,127}));
  connect(piston2.v_avg, piston1.v_avg) annotation (Line(points={{-42,-3},{-54,
          -3},{-54,-14},{-2,-14},{-2,-5},{16,-5}}, color={0,0,127}));
  connect(volumes.v_m, piston1.v_avg)
    annotation (Line(points={{-2,38},{-2,-5},{16,-5}}, color={0,0,127}));
  connect(Evaporator_out.ports[1], piston2.Fluid_in)
    annotation (Line(points={{-76,0},{-42,0}}, color={0,127,255}));
  connect(Evaporator_out.ports[2], piston1.Fluid_in) annotation (Line(points={{
          -76,-4},{-66,-4},{-66,-20},{-14,-20},{-14,-2},{16,-2}}, color={0,127,
          255}));
  connect(piston1.Fluid_out, Condenser_in.ports[1])
    annotation (Line(points={{36,-2},{78,-2}}, color={0,127,255}));
  connect(piston2.Fluid_out, Condenser_in.ports[2]) annotation (Line(points={{
          -22,0},{-18,0},{-18,14},{56,14},{56,2},{78,2}}, color={0,127,255}));
  connect(thermalConductor_Gas_Cylinder_2.port_a, CompressorWall.port)
    annotation (Line(points={{-34,-64},{-34,-80},{-76,-80}}, color={191,0,0}));
  connect(thermalConductor_Gas_Cylinder_1.port_a, CompressorWall.port)
    annotation (Line(points={{26,-66},{26,-80},{-76,-80}}, color={191,0,0}));
  connect(thermalConductor_ambient.port_b, CompressorWall.port) annotation (
      Line(points={{42,-90},{-34,-90},{-34,-80},{-76,-80}}, color={191,0,0}));

end RollingTypeRotaryCompressor_R744_2states;
