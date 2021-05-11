within VCLib.Components.ExpansionValves.ExpansionValveModels;
package Correlation_based_models
  annotation (Documentation(info="<html>
<p>Correlation based models (Stoecker, 1983; Kim et al., 1994; Kim and O&rsquo;Neal, 1994; ASHRAE, 2002; Choi et al., 2003; Li et al., 2004; Park et al., 2007) tend to calculate the mass flow rate given the inlet condition and outlet pressure. These models use simple equations and have a good accuracy in the range of regression. However, the downside of these models is the unpredictable accuracy of extrapolation. When the fluid condition is out of the regression range, the predicted results using these models are usually doubtful. Furthermore, these models tend to be refrigerant-dependent, the existing correlations might work well for some refrigerants, but not for others (Zhang and Ding, 2001). (http://docs.lib.purdue.edu/iracc/1090 )</p>
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
end Correlation_based_models;
