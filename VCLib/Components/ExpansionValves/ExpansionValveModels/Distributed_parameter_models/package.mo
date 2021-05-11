within VCLib.Components.ExpansionValves.ExpansionValveModels;
package Distributed_parameter_models







  annotation (Documentation(info="<html>
<p>Distributed parameter models can be further classified into homogeneous flow models (Bansal and Rupasingh, 1998) and separated flow models (Wong and Ooi, 1996; Ding, 2007). Homogenous flow models assume that the slip ratio between liquid phase and vapor phase is unity, and the void fraction can be analytically evaluated. While separated two-phase flow is considered, the void fraction needs to be estimated using semi-empirical equationsdistributed parameter models can be further classified into homogeneous flow models (Bansal and Rupasingh, 1998) and separated flow models (Wong and Ooi, 1996; Ding, 2007). Homogenous flow models assume that the slip ratio between liquid phase and vapor phase is unity, and the void fraction can be analytically evaluated. While separated two-phase flow is considered, the void fraction needs to be estimated using semi-empirical equations.(http://docs.lib.purdue.edu/iracc/1090 )</p>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          origin={10,10},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}}),
        Ellipse(
          origin={10,10},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10,10},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10,10},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}})}));
end Distributed_parameter_models;
