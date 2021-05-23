within VCLib.Components.Compressors.ModularPhysicalCompressors.Rotary.Example;
model RollingTypeRotaryCompressor_R410A_1state_test
   "Compressor Model using Refrigerant R410a"
  parameter Modelica.Media.Interfaces.Types.Temperature T_evap=273.15;
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure p_cond=1200000
    "Condenser Boundary pressure";
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure p_evap=600000
    "Evaporator Boundary pressure";
  parameter Modelica.Units.SI.Frequency speed=63 "Rotational speed in Hz";
  Modelica.Fluid.Sources.FixedBoundary Evaporator_out(
  use_p=true,
  use_T=true,
  redeclare package Medium = Rotary.Medium,
  nPorts=1,
    T(displayUnit="K") = T_evap,
    p(displayUnit="bar") = p_evap)
              annotation (Placement(transformation(extent={{-94,22},{-74,42}})));
  Modelica.Fluid.Sources.FixedBoundary Condenser_in(
  use_T=true,
  redeclare package Medium = Rotary.Medium,
  T(displayUnit="degC") = 373.15,
  nPorts=1,
    p=p_cond)                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={78,32})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(
        displayUnit="rpm") = 2*pi*speed)
    annotation (Placement(transformation(extent={{-94,74},{-74,94}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CompressorWall(     T(
        start=340, displayUnit="K"), C=5)
                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-66,-84})));
  Utilities.Compression_R410A piston1(
    u(start=450e3),
    h(start=500e3),
    a_co=0.5,
    p(start=400000))
    annotation (Placement(transformation(extent={{20,22},{40,42}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor
    thermalConductor_ambient(G=G)
    "Thermal conduction between cylinder and ambient" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2,-84})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Ambient(T=298.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-84})));
  final parameter Modelica.Units.SI.ThermalConductance G=0.24
    "Constant thermal conductance of material";
  Utilities.Geometry.Volumes volumes
    annotation (Placement(transformation(extent={{-46,56},{-26,76}})));
  Utilities.ThermalConductor_Gas_Cylinder thermalConductor_Gas_Cylinder
    annotation (Placement(transformation(extent={{-14,-54},{6,-34}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection
    annotation (Placement(transformation(extent={{30,-94},{50,-74}})));
  Modelica.Blocks.Sources.Constant const(k=5)
    annotation (Placement(transformation(extent={{52,-32},{72,-12}})));
equation
  connect(CompressorWall.port, thermalConductor_ambient.port_b)
    annotation (Line(points={{-56,-84},{-12,-84}},color={191,0,0}));
  connect(Evaporator_out.ports[1], piston1.Fluid_in)
    annotation (Line(points={{-74,32},{20,32}}, color={0,127,255}));
  connect(piston1.Fluid_out, Condenser_in.ports[1])
    annotation (Line(points={{40,32},{68,32}}, color={0,127,255}));
  connect(constantSpeed.flange, volumes.flange_a)
    annotation (Line(points={{-74,84},{-36,84},{-36,75.8}}, color={0,0,0}));
  connect(volumes.V1, piston1.V1)
    annotation (Line(points={{-26,73},{30,73},{30,42}}, color={0,0,127}));
  connect(volumes.T1, piston1.T1) annotation (Line(points={{-26,69},{4,69},{4,
          37},{20,37}}, color={0,0,127}));
  connect(piston1.Heat_port, thermalConductor_Gas_Cylinder.port_b)
    annotation (Line(points={{29,23},{29,-44},{6,-44}}, color={191,0,0}));
  connect(thermalConductor_Gas_Cylinder.port_a, thermalConductor_ambient.port_b)
    annotation (Line(points={{-14,-44},{-26,-44},{-26,-84},{-12,-84}},color={
          191,0,0}));
  connect(volumes.A_heat_1, thermalConductor_Gas_Cylinder.A_cg)
    annotation (Line(points={{-26,65},{0,65},{0,-34}}, color={0,0,127}));
  connect(volumes.v_m, piston1.v_avg)
    annotation (Line(points={{-36,56},{-36,29},{20,29}}, color={0,0,127}));
  connect(piston1.alpha_h, thermalConductor_Gas_Cylinder.alpha) annotation (
      Line(points={{23,22},{22,22},{22,-14},{-8,-14},{-8,-34}}, color={0,0,127}));

  connect(thermalConductor_ambient.port_a, convection.solid)
    annotation (Line(points={{8,-84},{30,-84}}, color={191,0,0}));
  connect(convection.fluid, Ambient.port)
    annotation (Line(points={{50,-84},{70,-84}}, color={191,0,0}));
  connect(const.y, convection.Gc) annotation (Line(points={{73,-22},{84,-22},{
          84,-58},{40,-58},{40,-74}},
                                   color={0,0,127}));
end RollingTypeRotaryCompressor_R410A_1state_test;