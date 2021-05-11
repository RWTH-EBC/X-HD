within VCLib.Components.Compressors;
package ModularPhysicalCompressors "Quasi White Box Simulation Models for Compressors"



  annotation (Documentation(info="<html>
<p>Physical (detailed) compressor models (Chen <i>et al.</i>, 2002; Chen <i>et al</i>., 2004; Rigola <i>et al</i>., 2005; Mathison <i>et al</i>., 2008), require many configuration parameters of the compressor, and simulates almost every individual process including the compression process, heat transfer between refrigerant and compression parts, internal refrigerant leakage, and overall energy balance of the compressor, etc. This type of models is useful for the compressor design and not suited for the system level simulation owing to complexity and slow computation speed.(http://docs.lib.purdue.edu/iracc/1090 )</p>
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
end ModularPhysicalCompressors;
